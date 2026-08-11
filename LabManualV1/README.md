# EEM 441 Lab Manual --- Build Instructions

## Compiling

This document only needs **LuaLaTeX** --- no `-shell-escape`, no Pygments,
no `minted`/`latexminted`. Code syntax highlighting uses the `listings`
package, which ships with every LaTeX distribution and needs no external
programs.

From this directory:

```bash
lualatex main.tex
lualatex main.tex   # run twice more for
lualatex main.tex   # TOC / cross-references
```

Three passes are needed (not one) so the table of contents and all
cross-references (Figure/Table/Listing numbers) resolve correctly. On the
first pass, "Reference ... undefined" warnings for every figure/table are
expected and harmless; they disappear by the second or third pass.

## VS Code / LaTeX Workshop setup

This project includes a `.vscode/settings.json` with a simple build
recipe (plain `lualatex`, run three times, no special flags). Open the
whole `source` folder via **File -> Open Folder...** (not just the
`.tex` file) so VS Code picks up that workspace configuration
automatically, then open `main.tex` and press **Ctrl+Alt+B**.

If you'd rather not rely on the bundled settings, any LuaLaTeX-based
recipe works fine --- `latexmk -lualatex`, a plain `lualatex` recipe, etc.
There is no shell-escape requirement to configure.

## Requirements

- **LuaLaTeX** (part of any TeX Live / MiKTeX install --- including a
  minimal one; nothing exotic is required)
- The following LaTeX packages: `fontspec`, `unicode-math`, `tcolorbox`,
  `tikz`, `listings`, `enumitem`, `booktabs`, `longtable`, `multirow`,
  `caption`, `hyperref`, `fancyhdr`, `titlesec`, `titletoc`, `csquotes`,
  `babel`. MiKTeX will offer to auto-install any of these the first time
  they're used (default behaviour). A full TeX Live install
  (`scheme-full`) already has all of these.

### If your TeX install is missing `luaotfload` (rare --- mainly minimal Docker images)

If you see errors like `module 'luaotfload-main' not found`, your TeX
installation is missing LuaLaTeX's OpenType font loader. This is very
unusual for a normal MiKTeX or TeX Live install; if it happens, install,
in order (each depends on the previous):

1. `lua-uni-algos` --- <https://github.com/latex3/lua-uni-algos>
2. `lualibs` --- <https://github.com/latex3/lualibs> (`l3build install`)
3. `luaotfload` --- <https://github.com/latex3/luaotfload> (`l3build install`)
4. `lualatex-math` --- <https://github.com/phst/lualatex-math> (docstrip: `tex lualatex-math.ins`)

## Structure

```
main.tex             Master document: cover page, TOC, includes all experiments
preamble.tex          Shared fonts, colors, section-box styles, listings/TikZ config
experiments/
  exp01.tex .. exp10.tex   One file per experiment
fonts/
  PlexSans/           IBM Plex Sans (body text)
  STIX2/              STIX Two Math (math)
  JetBrainsMono/      JetBrains Mono (code, ligatures disabled)
figures/
  usm-logo.png        USM crest, used on the cover page
  exp1-2-trainer.jpg  Photo of the DC Motor/PID trainer, used in Exp 1 & 2
.vscode/
  settings.json       VS Code / LaTeX Workshop build recipe (plain lualatex x3)
```

All paths in `preamble.tex` and the `\includegraphics` calls in
`experiments/exp01.tex` / `exp02.tex` are relative to wherever `main.tex`
is compiled from --- so the whole folder must stay together.

## Fonts

All three fonts are vendored locally in `fonts/` under their respective
open licenses (SIL OFL) --- no system font installation needed.

## Code highlighting

Code listings use `listings` with custom styles defined in
`preamble.tex`: `verilogstyle`, `vhdlstyle`, `cstyle`, `cppstyle`, and
`pythonstyle` (VHDL and Verilog use `listings`' built-in IEEE-1364-based
language definitions). Colours are matched to the manual's accent
palette rather than a generic default theme. To add a new code listing,
use:

```latex
\begin{codepanel}{filename.v}{verilogstyle}
\begin{lstlisting}
... code here, verbatim, no escaping needed for { } # etc. ...
\end{lstlisting}
\end{codepanel}
```

Swap `verilogstyle` for `vhdlstyle`, `cstyle`, `cppstyle`, or
`pythonstyle` as needed.

## Notes on Experiments 1 & 2

Figure 1 (Exp 1) and Figure 2 (Exp 2) are a photo of the actual DC
Motor/PID Control trainer bench unit, replacing the earlier schematic
block diagrams. The Exp 2 closed-loop procedure text points students to
the DIP switch on the pictured PID Controller daughterboard rather than
an abstract summing-junction diagram.

## Notes on Experiments 7 & 8

These two experiments describe new lab hardware (ADAM-3968/PCIE-1816 for
Exp 7, ADAM-3937/PCIE-1750-U for Exp 8) rather than the original PCL-818L
setup, and include open-ended circuit-design tasks for students (filter
design in Exp 7, signal-conditioning design in Exp 8). Sections still
pending finalization are marked with an orange "Pending" callout box in
the compiled PDF --- search for `\begin{needsupdate}` in `exp07.tex` /
`exp08.tex` to find them in source.
