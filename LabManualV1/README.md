# EEM 441 Lab Manual --- Build Instructions

## Compiling

From this directory:

```bash
lualatex -shell-escape main.tex
lualatex -shell-escape main.tex   # run twice more for
lualatex -shell-escape main.tex   # TOC / cross-references / minted cache
```

`-shell-escape` is required because the `minted` package calls out to
Pygments (`pygmentize`) for VHDL/Verilog syntax highlighting.

## Requirements

- **LuaLaTeX** (part of any reasonably current TeX Live / MiKTeX install)
- **Pygments** (`pip install Pygments`) --- provides `pygmentize`, used by `minted`
- The following LaTeX packages: `fontspec`, `unicode-math`, `tcolorbox`,
  `tikz`, `minted`, `enumitem`, `booktabs`, `longtable`, `multirow`,
  `caption`, `hyperref`, `fancyhdr`, `titlesec`, `titletoc`, `csquotes`,
  `babel`. These ship with any full TeX Live install (`scheme-full`).

### If your TeX install is missing `luaotfload`

Some minimal/pruned TeX Live installs (e.g. certain Docker images) do not
include `luaotfload`, which `fontspec`/`unicode-math` require under
LuaLaTeX. If you see errors like `module 'luaotfload-main' not found`,
you'll need to install, in order (each depends on the previous):

1. `lua-uni-algos` --- <https://github.com/latex3/lua-uni-algos>
2. `lualibs` --- <https://github.com/latex3/lualibs> (`l3build install`)
3. `luaotfload` --- <https://github.com/latex3/luaotfload> (`l3build install`)
4. `lualatex-math` --- <https://github.com/phst/lualatex-math> (docstrip: `tex lualatex-math.ins`)

Normally none of this is necessary --- a standard TeX Live install
already has all of these.

## Structure

```
main.tex            Master document: cover page, TOC, includes all experiments
preamble.tex         Shared fonts, colors, section-box styles, minted/TikZ config
experiments/
  exp01.tex .. exp10.tex   One file per experiment
fonts/
  PlexSans/          IBM Plex Sans (body text)
  STIX2/             STIX Two Math (math)
  JetBrainsMono/     JetBrains Mono (code, ligatures disabled)
figures/
  usm-logo.png       USM crest, used on the cover page
```

## Fonts

All three fonts are vendored locally in `fonts/` under their respective
open licenses (SIL OFL) --- no system font installation needed. Font paths
in `preamble.tex` are relative to the directory `main.tex` is compiled
from.

## Notes on Experiments 7 & 8

These two experiments describe new lab hardware (ADAM-3968/PCIE-1816 for
Exp 7, ADAM-3937/PCIE-1750-U for Exp 8) rather than the original PCL-818L
setup, and include open-ended circuit-design tasks for students (filter
design in Exp 7, signal-conditioning design in Exp 8). Sections still
pending finalization are marked with an orange "Pending" callout box in
the compiled PDF --- search for `\begin{needsupdate}` in `exp07.tex` /
`exp08.tex` to find them in source.
