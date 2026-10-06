# Methodological manual — LaTeX project

A single-printable PDF manual for the course
**"Introduction to Operating Systems and Developer Tools"**
(NSU, Faculty of Information Technology, 1st year).

The PDF is assembled from many small `.tex` chapter files. Each topic lives in
its own file under `chapters/`, and `main.tex` `\input`s them in order. This
keeps the manual easy to extend: a new seminar/topic = a new chapter file added
to the list in `main.tex`.

This directory is the **repository root**: the files you see here (`main.tex`,
`Makefile`, `chapters/`, `style/`, `appendix/`) are what the build consumes.

## Quick start

```sh
# 1. install build dependencies (full list and rationale in "Prerequisites")
sudo apt install \
    texlive-xetex \
    texlive-latex-base texlive-latex-recommended texlive-latex-extra \
    texlive-lang-cyrillic \
    fonts-noto-core fonts-noto-mono \
    python3-pygments

pip install --user style/pygments-course

make # -> main.pdf
```

## Layout

```
main.tex                 entry point: title page, TOC, \input of all chapters
style/
  course.sty             packages + local styles (minted config, tip boxes)
  tikz-styles.tex        shared TikZ node/edge styles
  pygments-course/       custom Pygments style "course" (pip-installable plugin)
chapters/                one file per topic (kebab-case, numbered)
appendix/
  glossary.tex           glossary
  cheatsheets.tex        command reference tables
  references.tex         bibliography (GOST) + web resources
  roadmap.tex            course roadmap (topic -> lecture/lab -> status)
Makefile                 build helper
```

## Prerequisites

The document is built with **XeLaTeX** (Unicode-native). This is what makes the
Cyrillic text in the resulting PDF **searchable and copy-paste-able**: XeLaTeX
embeds a proper Unicode (ToUnicode) mapping, unlike the old `pdflatex` + `T2A`
setup (which used bitmap `cm-super` fonts and produced non-searchable text).

Debian/Ubuntu — install the engine, the usual LaTeX packages, Russian language
support, and the two fonts the document uses (`Noto Serif` for text, `Noto Sans
Mono` for code).

The fonts are chosen because in this TeX Live they embed a correct ToUnicode
CMap for Cyrillic. (Notably, `Latin Modern Roman` produces a broken CMap here,
so it is deliberately *not* used.)

### Code highlighting (minted / Pygments)

Code blocks are highlighted with **minted + Pygments**, *not* `listings`. The
reason: under XeLaTeX, `listings` cannot apply a colour to non-ASCII glyphs,
so Russian comments in code would have stayed black. Pygments colours every
glyph, so Russian comments render green exactly like English ones.

This needs two things at build time:

1. **`pygmentize`** (Pygments) on `PATH` — minted shells out to it.
   ```sh
   sudo apt-get install python3-pygments
   ```
2. **The `course` style plugin**, a small local package that registers a
   Pygments style named `course` (same palette the old listings used:
   comments `#008000`, keywords `#0000B2`, strings `#B20000`, and `Error`
   rendered as plain black with *no* red box). Install it once:
   ```sh
   pip install --user style/pygments-course   # or: pip install -e style/pygments-course
   ```
   Verify it is registered:
   ```sh
   pygmentize -L styles | grep course
   ```
   If your Python is *externally managed* (Debian/Ubuntu ≥ 24.04, Fedora —
   PEP 668), plain `pip install` is refused; use a virtualenv instead.

Because minted calls `pygmentize` from inside TeX, the build runs with
`-shell-escape` (the `Makefile` already passes it). Highlighting output is
cached in `_minted-<jobname>/`; `make clean` removes it.

## Build

```sh
make            # builds main.pdf (runs xelatex twice for TOC/refs)
make clean      # remove intermediate files and the PDF
```

The result is **`main.pdf`** in this directory.

If you build manually (without `make`):

```sh
xelatex main.tex
xelatex main.tex     # second pass resolves the TOC and cross-references
```

## Adding content

1. Add a new chapter: `chapters/NN-topic-name.tex` with `\chapter{...}` and a
   `\label{ch:NN-topic-name}`.
2. Register it in `main.tex` with `\input{chapters/NN-topic-name}` inside the
   right `\part{...}`.
3. Follow the content rules for every chapter: the "why" and theory (linked to
   OS internals), common mistakes and their fixes, a pointer to the relevant
   `man` page(s), self-check tasks for the reader, and at least one diagram.

## Language

Prose that students read is in **Russian**. Command names, flags, file paths
and terms stay in **English**, and the **comments inside code blocks are
written in Russian** too.

> **Code blocks (`minted`):** the typed command stays exactly as it runs on
> the server; the trailing comment is in Russian and is coloured green.
> The PDF text stays searchable and copyable.
>
> **Gotcha (Makefile blocks):** a real `Makefile` indents each recipe with a
> *tab*. A raw tab inside a minted block is passed to Pygments as the literal
> token `^^I`, which the lexer mis-parses, so the recipes are shown with *four
> spaces* instead. This is a display choice only — a working `Makefile` still
> needs a real tab (see the warning box in `chapters/14-make.tex`).
>
> **Gotcha (this TeX Live build):** an opening parenthesis `(` placed directly
> before a *Cyrillic* letter (e.g. `слово (осторожно)`) gets a broken Unicode
> mapping — on copy/paste the paren ends up *after* the word. A `(` before
> *Latin* is fine (`(dry run)`, `(swap)`). So in Russian comments avoid putting
> `(` right before a Cyrillic word: use a comma/colon or reword instead.
>
