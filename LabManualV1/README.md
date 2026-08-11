# EEM 441 Lab Manual --- Build Instructions

## Quick fix if you're seeing "errors" that are actually engine mismatch

If your editor shows errors as soon as you compile, the most common cause
is:
1. **Wrong engine.** This document needs **LuaLaTeX**, not pdfLaTeX or
   XeLaTeX. `\setmainfont` (from `fontspec`) does not exist in pdfLaTeX ---
   that alone will look like a cascade of errors.
2. **Missing `-shell-escape`.** The `minted` package shells out to
   Pygments for syntax highlighting; without `-shell-escape` it refuses
   to run.
3. **Files not sitting together.** `main.tex` pulls in `preamble.tex`,
   `experiments/*.tex`, and the `fonts/` folder via relative paths. If you
   copy-pasted just the contents of `main.tex` into a new file, none of
   that will resolve. Keep the whole folder structure intact and compile
   `main.tex` from inside it.

`main.tex` already has magic comments at the top (`% !TEX program =
lualatex`) that most editors (TeXstudio, Overleaf) pick up automatically.
VS Code's LaTeX Workshop extension does **not** honour `-shell-escape`
from magic comments alone, so it needs an explicit recipe --- see below.

## VS Code / LaTeX Workshop setup (one-time, per machine)

Open **Settings (JSON)** (Ctrl+Shift+P -> "Preferences: Open User Settings (JSON)")
and add:

```json
{
  "latex-workshop.latex.tools": [
    {
      "name": "lualatex-shell-escape",
      "command": "lualatex",
      "args": [
        "-shell-escape",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    }
  ],
  "latex-workshop.latex.recipes": [
    {
      "name": "lualatex x3 (shell-escape)",
      "tools": ["lualatex-shell-escape", "lualatex-shell-escape", "lualatex-shell-escape"]
    }
  ],
  "latex-workshop.latex.recipe.default": "lualatex x3 (shell-escape)"
}
```

Three passes are needed (not one) so the table of contents and all
cross-references (Figure/Table/Listing numbers) resolve correctly.

**MiKTeX-specific note:** the first time you compile, MiKTeX will likely
pop up a dialog asking permission to run `pygmentize` (an external
program) or to install a missing package on the fly --- accept these
prompts. If `pygmentize` isn't found at all:

```
pip install Pygments
```

and confirm it's on your PATH (`pygmentize --version` in a terminal).

## Compiling from the command line (alternative to VS Code)

From this directory:

```bash
lualatex -shell-escape main.tex
lualatex -shell-escape main.tex   # run twice more for
lualatex -shell-escape main.tex   # TOC / cross-references / minted cache
```

## Requirements

- **LuaLaTeX** (part of any reasonably current TeX Live / MiKTeX install)
- **Pygments** (`pip install Pygments`) --- provides `pygmentize`, used by `minted`
- The following LaTeX packages: `fontspec`, `unicode-math`, `tcolorbox`,
  `tikz`, `minted`, `enumitem`, `booktabs`, `longtable`, `multirow`,
  `caption`, `hyperref`, `fancyhdr`, `titlesec`, `titletoc`, `csquotes`,
  `babel`. MiKTeX will offer to auto-install any of these the first time
  they're used, if "install packages on the fly" is enabled (it is by
  default). A full TeX Live install (`scheme-full`) already has all of
  these.

### If your TeX install is missing `luaotfload` (rare --- mainly minimal Docker images)

If you see errors like `module 'luaotfload-main' not found`, install, in
order (each depends on the previous):

1. `lua-uni-algos` --- <https://github.com/latex3/lua-uni-algos>
2. `lualibs` --- <https://github.com/latex3/lualibs> (`l3build install`)
3. `luaotfload` --- <https://github.com/latex3/luaotfload> (`l3build install`)
4. `lualatex-math` --- <https://github.com/phst/lualatex-math> (docstrip: `tex lualatex-math.ins`)

A standard MiKTeX or TeX Live install will not need this.

## Structure

```
main.tex             Master document: cover page, TOC, includes all experiments
preamble.tex          Shared fonts, colors, section-box styles, minted/TikZ config
experiments/
  exp01.tex .. exp10.tex   One file per experiment
fonts/
  PlexSans/           IBM Plex Sans (body text)
  STIX2/              STIX Two Math (math)
  JetBrainsMono/      JetBrains Mono (code, ligatures disabled)
figures/
  usm-logo.png        USM crest, used on the cover page
  exp1-2-trainer.jpg  Photo of the DC Motor/PID trainer, used in Exp 1 & 2
```

All paths in `preamble.tex` and the `\includegraphics` calls in
`experiments/exp01.tex` / `exp02.tex` are relative to wherever `main.tex`
is compiled from --- so the whole folder must stay together.

## Fonts

All three fonts are vendored locally in `fonts/` under their respective
open licenses (SIL OFL) --- no system font installation needed.

## Notes on Experiments 1 & 2

Figure 1 (Exp 1) and Figure 2 (Exp 2) are a photo of the actual DC
Motor/PID Control trainer bench unit, replacing the earlier schematic
block diagrams. The Exp 2 closed-loop procedure text now points students
to the DIP switch on the pictured PID Controller daughterboard rather
than an abstract summing-junction diagram.

## Notes on Experiments 7 & 8

These two experiments describe new lab hardware (ADAM-3968/PCIE-1816 for
Exp 7, ADAM-3937/PCIE-1750-U for Exp 8) rather than the original PCL-818L
setup, and include open-ended circuit-design tasks for students (filter
design in Exp 7, signal-conditioning design in Exp 8). Sections still
pending finalization are marked with an orange "Pending" callout box in
the compiled PDF --- search for `\begin{needsupdate}` in `exp07.tex` /
`exp08.tex` to find them in source.
