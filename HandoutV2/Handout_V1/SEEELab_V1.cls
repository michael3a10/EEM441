\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SEEELab_V1}[2025/09/23 v1.4 SEEELab layout with margin ToC]

% ===== Base class =====
\LoadClass[11pt,a4paper,twoside,openany]{memoir}

% ===== Packages =====
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{calc}
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning}
\RequirePackage{etoolbox}
\RequirePackage{ifoddpage}   % for outer margin placement
\RequirePackage{marginnote}  % better margin notes
\RequirePackage{titletoc}    % compact contents printing
\RequirePackage{hyperref}

% ===== Colors (safe defaults) =====
\definecolor{USMTeal}{HTML}{006E6D}
\definecolor{USMPurple}{HTML}{6A1B9A}
\definecolor{LightGray}{gray}{0.35}

% Avoid marginnote warnings with footnotes, etc.
\renewcommand*{\marginfont}{\footnotesize}

% ===== Metadata Macros =====
\newcommand*{\labtitle}[1]{\def\seee@labtitle{#1}}
\newcommand*{\labsubtitle}[1]{\def\seee@labsubtitle{#1}}
\newcommand*{\labauthor}[1]{\def\seee@labauthor{#1}}
\newcommand*{\labdate}[1]{\def\seee@labdate{#1}}
\newcommand*{\coursecode}[1]{\def\seee@coursecode{#1}}
\newcommand*{\semester}[1]{\def\seee@semester{#1}}
\newcommand*{\lablogo}[1]{\def\seee@lablogo{#1}}

% Defaults so nothing is undefined
\labtitle{Untitled Experiment}
\labsubtitle{}
\labauthor{}
\labdate{\today}
\coursecode{}
\semester{}
\lablogo{}

% ===== Page Geometry (memoir) =====
\setlrmarginsandblock{*}{35mm}{*}
\setulmarginsandblock{30mm}{*}{*}
\checkandfixthelayout

% Page style: page number bottom center, clean headers
\makepagestyle{seee}
\makeoddfoot{seee}{}{{\small\thepage}}{}
\makeevenfoot{seee}{}{{\small\thepage}}{}
\makeoddhead{seee}{}{}{}
\makeevenhead{seee}{}{}{}
\makeheadrule{seee}{\textwidth}{0pt}
\pagestyle{seee}
\aliaspagestyle{chapter}{seee}

% ===== Margin ToC (kaohandt-inspired) =====
% Debug switch
\newif\ifSEEEDebugTOC
\newcommand{\SEEEDebugTOCOn}{\SEEEDebugTOCtrue}
\newcommand{\SEEEDebugTOCOff}{\SEEEDebugTOCfalse}

% Width of margin ToC box = memoir's \marginparwidth unless overridden
\newlength{\seee@margintocwidth}
\AtBeginDocument{\setlength{\seee@margintocwidth}{\marginparwidth}}

% Compact entry styles
\titlecontents{section}
  [0pt]
  {\small}
  {\contentslabel{1.25em}}
  {}
  {\hfill\contentspage}
  [1pt]

\titlecontents{subsection}
  [1.25em]
  {\small}
  {\contentslabel{1.25em}}
  {}
  {\hfill\contentspage}
  [0pt]

% Start collecting contents from the beginning
\AtBeginDocument{\startcontents}

% Helper: place content in the OUTER margin (right on odd, left on even)
\newcommand{\seee@outermarginnote}[1]{%
  \checkoddpage
  \ifoddpage
    \normalmarginpar
  \else
    \reversemarginpar
  \fi
  \marginnote{#1}[-\baselineskip]%
}

% Framed box only when debug is ON
\newcommand{\seee@maybe@frame}[1]{%
  \ifSEEEDebugTOC
    \fboxrule=.3pt \fboxsep=4pt \fbox{#1}%
  \else
    #1%
  \fi
}

% Public macro: print a margin ToC where called
\newcommand{\makemargintoc}{%
  \begingroup
    \setcounter{tocdepth}{2}% show through subsections
    \seee@outermarginnote{\seee@maybe@frame{%
      \begin{minipage}{\seee@margintocwidth}
        \raggedright
        {\bfseries\footnotesize\textcolor{USMTeal}{Contents}}\par\vspace{.35\baselineskip}
        \printcontents{}{1}{}{}% use \titlecontents definitions
      \end{minipage}%
    }}%
  \endgroup
}

% ===== Title Block =====
\newlength\seee@titleleft
\setlength\seee@titleleft{0.64\textwidth}

\newcommand*{\makelabtitle}{%
  \thispagestyle{empty}%
  \vspace*{6mm}%
  \noindent
  \begin{minipage}[t]{\seee@titleleft}
    {\Large\bfseries \seee@labtitle}\par
    \ifstrempty{\seee@labsubtitle}{}{%
      \vspace{1mm}{\large\itshape \seee@labsubtitle}\par}%
    \vspace{4mm}
    {\normalsize \textbf{Course:}~\seee@coursecode\quad
                 \textbf{Semester:}~\seee@semester}\par
    \vspace{2mm}
    {\normalsize \textbf{Author:}~\seee@labauthor}\par
    {\normalsize \textbf{Date:}~\seee@labdate}\par
  \end{minipage}%
  \hfill
  \begin{minipage}[t]{\textwidth-\seee@titleleft-1em}
    \raggedleft
    \ifstrempty{\seee@lablogo}{}{%
      \includegraphics[width=0.95\linewidth]{\seee@lablogo}}%
  \end{minipage}
  \par\vspace{4mm}\noindent\color{USMTeal}\rule{\textwidth}{.8pt}\color{black}%
  \vspace{0.5\baselineskip}%
}

% ===== Sectioning look =====
\setsecnumdepth{subsection}
\maxtocdepth{subsection}
\setsecheadstyle{\bfseries\Large}
\setsubsecheadstyle{\bfseries\large}
\setsubsubsecheadstyle{\bfseries}

% ===== Lists (simple helpers) =====
\newenvironment{ObjectivesList}{\begin{itemize}}{\end{itemize}}
\newenvironment{ApparatusList}{\begin{itemize}}{\end{itemize}}

% ===== Hyperref defaults =====
\hypersetup{
  colorlinks=true,
  linkcolor=USMTeal,
  urlcolor=USMTeal,
  citecolor=USMTeal,
  pdfauthor={\seee@labauthor},
  pdftitle={\seee@labtitle}
}
