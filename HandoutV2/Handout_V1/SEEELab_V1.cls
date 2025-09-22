\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SEEELab_V1}[2025/09/22 v1.7 SEEELab layout]

% ===== Base class =====
\LoadClass[11pt,a4paper,twoside,openany]{memoir}

% ===== Packages =====
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}

% ----- Safe default colors (avoid "undefined color" errors) -----
\definecolor{USMTeal}{HTML}{14737E}
\definecolor{USMPurple}{HTML}{5C2D91}
\definecolor{USMGray}{gray}{0.25}

% ===== Internal storage for metadata =====
\makeatletter
\newcommand\@labtitle{}
\newcommand\@labsubtitle{}
\newcommand\@labauthor{}
\newcommand\@labdate{\today}
\newcommand\@coursecode{}
\newcommand\@semester{}
\newcommand\@lablogo{Figures/Logo_USM_SEEE} % path to logo image (optional)
\makeatother

% ===== Public setters =====
\newcommand{\labtitle}[1]{\makeatletter\gdef\@labtitle{#1}\makeatother}
\newcommand{\labsubtitle}[1]{\makeatletter\gdef\@labsubtitle{#1}\makeatother}
\newcommand{\labauthor}[1]{\makeatletter\gdef\@labauthor{#1}\makeatother}
\newcommand{\labdate}[1]{\makeatletter\gdef\@labdate{#1}\makeatother}
\newcommand{\coursecode}[1]{\makeatletter\gdef\@coursecode{#1}\makeatother}
\newcommand{\semester}[1]{\makeatletter\gdef\@semester{#1}\makeatother}
\newcommand{\lablogo}[1]{\makeatletter\gdef\@lablogo{#1}\makeatother}

% ===== Page style: show SECTION in headers (not Chapter) =====
\makepagestyle{labmanual}
\makepsmarks{labmanual}{%
  \nouppercaseheads
  \createmark{chapter}{both}{nonumber}{}{}% suppress chapter mark
  \createmark{section}{both}{shownumber}{}{\,}% use section titles
}
\makeevenhead{labmanual}{\small\leftmark}{}{\small\thepage}
\makeoddhead {labmanual}{\small\rightmark}{}{\small\thepage}
\makeevenfoot{labmanual}{}{}{}%
\makeoddfoot {labmanual}{}{}{}%
\pagestyle{labmanual}
\aliaspagestyle{chapter}{labmanual}
\aliaspagestyle{plain}{labmanual}

% Marking
\makeatletter
\renewcommand*{\sectionmark}[1]{\markboth{\thesection\ #1}{\thesection\ #1}}
\makeatother

\setsecnumdepth{section}

% ===== Simple ToC helper =====
\newcommand{\makemargintoc}{%
  \begingroup
  \setcounter{tocdepth}{1}% sections only
  \renewcommand{\contentsname}{}%
  \tableofcontents*%
  \endgroup
}

% ===== Helpers (robust emptiness tests; defined with @ letter) =====
\makeatletter
\newcommand{\SEEE@maybe@logo}{%
  \ifx\@lablogo\@empty\else
    \vspace*{0.5ex}%
    \includegraphics[height=14mm]{\@lablogo}\par
    \vspace{0.5ex}%
  \fi
}
\newcommand{\SEEE@maybe@subtitle}{%
  \ifx\@labsubtitle\@empty\else
    {\large \@labsubtitle\par}%
  \fi
}
\makeatother

% ===== Simple, centered title block =====
% IMPORTANT: define while @ is a letter so tokens like \@labtitle are correct.
\makeatletter
\newcommand{\makelabtitle}{%
  \thispagestyle{labmanual}%
  \begin{center}
    \begingroup\setlength{\parskip}{2pt}% tighter
      \SEEE@maybe@logo
      {\Large\bfseries \@labtitle\par}
      \SEEE@maybe@subtitle
      \vspace{0.6ex}
      {\normalsize \@labauthor\par}
      {\small \@labdate\par}
      \vspace{0.6ex}
      {\normalsize \@coursecode\par}
      {\small \@semester\par}
    \endgroup
  \end{center}
  \vspace{1.2ex}
}
\makeatother

% ===== Lists =====
\newlist{AlphaList}{enumerate}{1}
\setlist[AlphaList,1]{label=\Alph*), leftmargin=1.6em, itemsep=.15em, topsep=.3em}

% ===== Section heading look =====
\setsecheadstyle{\Large\bfseries}
\setsubsecheadstyle{\large\bfseries}
\setsubsubsecheadstyle{\normalsize\bfseries}

% ===== Microtype (if available) =====
\IfFileExists{microtype.sty}{\RequirePackage[protrusion=true,expansion=true]{microtype}}{}

% ===== End of class =====
