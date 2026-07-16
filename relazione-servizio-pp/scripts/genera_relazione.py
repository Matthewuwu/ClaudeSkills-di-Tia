#!/usr/bin/env python3
"""
Genera una relazione di servizio della Polizia Penitenziaria in formato .docx
a partire da una descrizione JSON.

Uso:
    python genera_relazione.py struttura.json /percorso/output/Relazione.docx

Lo schema del JSON è documentato in references/struttura.md.
Richiede python-docx (import docx).
"""

import sys
import re
import json
from docx import Document
from docx.shared import Pt, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_TAB_ALIGNMENT
from docx.enum.section import WD_SECTION
from docx.oxml.ns import qn
from docx.oxml import OxmlElement


def _add_inline(paragraph, text):
    """Aggiunge testo con supporto a **grassetto** e *corsivo* inline."""
    # Tokenizza su **...** e *...*
    pattern = re.compile(r'(\*\*[^*]+\*\*|\*[^*]+\*)')
    for token in pattern.split(text):
        if not token:
            continue
        if token.startswith('**') and token.endswith('**'):
            run = paragraph.add_run(token[2:-2])
            run.bold = True
        elif token.startswith('*') and token.endswith('*'):
            run = paragraph.add_run(token[1:-1])
            run.italic = True
        else:
            paragraph.add_run(token)


def _set_font_default(doc):
    style = doc.styles['Normal']
    style.font.name = 'Times New Roman'
    style.font.size = Pt(12)
    # garantisce il font anche per i caratteri complessi
    rpr = style.element.get_or_add_rPr()
    rfonts = rpr.get_or_add_rFonts()
    rfonts.set(qn('w:ascii'), 'Times New Roman')
    rfonts.set(qn('w:hAnsi'), 'Times New Roman')


def _add_page_number_footer(section):
    footer = section.footer
    p = footer.paragraphs[0]
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.add_run("Pag. ")
    _field(p, "PAGE")
    p.add_run(" di ")
    _field(p, "NUMPAGES")
    for run in p.runs:
        run.font.size = Pt(9)
        run.font.name = 'Times New Roman'


def _field(paragraph, field_name):
    fldStart = OxmlElement('w:fldChar')
    fldStart.set(qn('w:fldCharType'), 'begin')
    instr = OxmlElement('w:instrText')
    instr.set(qn('xml:space'), 'preserve')
    instr.text = f' {field_name} '
    fldEnd = OxmlElement('w:fldChar')
    fldEnd.set(qn('w:fldCharType'), 'end')
    run = paragraph.add_run()
    run._r.append(fldStart)
    run._r.append(instr)
    run._r.append(fldEnd)


def _heading(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(12)
    p.paragraph_format.space_after = Pt(6)
    run = p.add_run(text)
    run.bold = True
    run.font.size = Pt(13)
    run.font.name = 'Times New Roman'
    return p


def _body(doc, text, align=WD_ALIGN_PARAGRAPH.JUSTIFY):
    p = doc.add_paragraph()
    p.alignment = align
    p.paragraph_format.space_after = Pt(8)
    p.paragraph_format.line_spacing = 1.15
    _add_inline(p, text)
    return p


def _list_item(doc, text, numbered):
    style = 'List Number' if numbered else 'List Bullet'
    try:
        p = doc.add_paragraph(style=style)
    except KeyError:
        p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
    p.paragraph_format.space_after = Pt(6)
    _add_inline(p, text)
    return p


def build(data, out_path):
    doc = Document()
    _set_font_default(doc)

    section = doc.sections[0]
    section.page_height = Cm(29.7)
    section.page_width = Cm(21.0)
    for m in ('top_margin', 'bottom_margin', 'left_margin', 'right_margin'):
        setattr(section, m, Cm(2.5))
    _add_page_number_footer(section)

    # Titolo
    title = doc.add_paragraph()
    title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    title.paragraph_format.space_after = Pt(4)
    r = title.add_run(data.get('titolo', 'RELAZIONE DI SERVIZIO'))
    r.bold = True
    r.font.size = Pt(15)
    r.font.name = 'Times New Roman'

    if data.get('sottotitolo'):
        sub = doc.add_paragraph()
        sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
        sub.paragraph_format.space_after = Pt(14)
        sr = sub.add_run(data['sottotitolo'])
        sr.italic = True
        sr.font.size = Pt(11)
        sr.font.name = 'Times New Roman'

    # Destinatari
    for riga in data.get('destinatari', []):
        p = _body(doc, riga, align=WD_ALIGN_PARAGRAPH.LEFT)
        p.paragraph_format.space_after = Pt(2)
    if data.get('destinatari'):
        doc.add_paragraph().paragraph_format.space_after = Pt(2)

    # Incipit
    if data.get('incipit'):
        _body(doc, data['incipit'])

    # Premessa
    if data.get('premessa'):
        _body(doc, data['premessa'])

    # Sezioni
    for sez in data.get('sezioni', []):
        if sez.get('titolo'):
            _heading(doc, sez['titolo'])
        for par in sez.get('paragrafi', []):
            if isinstance(par, str):
                _body(doc, par)
            elif isinstance(par, dict) and par.get('tipo') == 'elenco':
                numbered = par.get('stile') == 'numerato'
                for voce in par.get('voci', []):
                    _list_item(doc, voce, numbered)

    # Chiusura
    if data.get('chiusura'):
        p = _body(doc, data['chiusura'])
        p.paragraph_format.space_before = Pt(8)
        p.paragraph_format.space_after = Pt(20)

    # Firma
    firma = doc.add_paragraph()
    firma.paragraph_format.space_before = Pt(10)
    tab_stops = firma.paragraph_format.tab_stops
    tab_stops.add_tab_stop(Cm(16), WD_TAB_ALIGNMENT.RIGHT)
    firma.add_run("Luogo e data ____________________")
    firma.add_run("\t")
    firma.add_run(data.get('firma_label', 'Il dipendente'))

    firma2 = doc.add_paragraph()
    ts2 = firma2.paragraph_format.tab_stops
    ts2.add_tab_stop(Cm(16), WD_TAB_ALIGNMENT.RIGHT)
    firma2.add_run("\t")
    firma2.add_run("__________________________")

    # Imposta lo zoom (evita warning di validazione su alcuni reader)
    try:
        settings = doc.settings.element
        zoom = settings.find(qn('w:zoom'))
        if zoom is None:
            zoom = OxmlElement('w:zoom')
            settings.append(zoom)
        zoom.set(qn('w:percent'), '100')
    except Exception:
        pass

    doc.save(out_path)
    return out_path


def main():
    if len(sys.argv) != 3:
        print("Uso: python genera_relazione.py struttura.json output.docx")
        sys.exit(1)
    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        data = json.load(f)
    out = build(data, sys.argv[2])
    print(f"Relazione generata: {out}")


if __name__ == '__main__':
    main()
