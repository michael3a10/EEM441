
% SEEELab.cls — v1.8 (robust margin envs using \NewEnviron body capture)
% - Fix for list-in-margin errors: capture environment body, then typeset inside \marginpar.
% - No tcolorbox in margins; single/dual logos unchanged.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SEEELab}[2025/09/18 v1.8 SEEE Lab Manual Class]

% ---------- Options -----------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\newif\if@twoside
\DeclareOption{oneside}{\PassOptionsToClass{oneside}{article} \@twosidefalse}
\DeclareOption{twoside}{\PassOptionsToClass{twoside}{article} \@twosidetrue}
\newcommand\@lab@fonts{palatino}
\DeclareOption{fonts=palatino}{\renewcommand\@lab@fonts{palatino}}
\DeclareOption{fonts=helvetica}{\renewcommand\@lab@fonts{helvetica}}
\DeclareOption{fonts=arial}{\renewcommand\@lab@fonts{helvetica}} % arial -> helvetica fallback
\DeclareOption{fonts=bookman}{\renewcommand\@lab@fonts{bookman}}
\ProcessOptions\relax

% ---------- Base class --------------------------------------------------------
\LoadClass[12pt,a4paper]{article}

% ---------- Packages ----------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{calc}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{microtype}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref}
\RequirePackage{amsmath,amssymb}
\RequirePackage{listings}
\RequirePackage{etoolbox}
\RequirePackage{tocloft}
\RequirePackage{environ} % <-- capture environment body safely

% ---------- Fonts -------------------------------------------------------------
\ifboolexpr{ bool{xetex} or bool{luatex} }{%%
  \RequirePackage{fontspec}
  \ifstrequal{\@lab@fonts}{palatino}{\setmainfont{TeX Gyre Pagella}}{}
  \ifstrequal{\@lab@fonts}{helvetica}{\setmainfont{TeX Gyre Heros}}{}
  \ifstrequal{\@lab@fonts}{bookman}{\setmainfont{TeX Gyre Bonum}}{}
}{%% pdfTeX fallback
  \RequirePackage[utf8]{inputenc}
  \ifstrequal{\@lab@fonts}{palatino}{\RequirePackage[sc]{mathpazo}}{}
  \ifstrequal{\@lab@fonts}{helvetica}{\RequirePackage[scaled]{helvet} \renewcommand{\familydefault}{\sfdefault}}{}
  \ifstrequal{\@lab@fonts}{bookman}{\RequirePackage{bookman}}{}
}

% ---------- Geometry & margin lane -------------------------------------------
\geometry{a4paper, left=2.5cm, right=4.0cm, top=3.0cm, bottom=2.5cm}
\setlength{\marginparwidth}{3.3cm}
\setlength{\marginparsep}{0.7cm}
\normalmarginpar

% ---------- Colors ------------------------------------------------------------
\definecolor{USMPurple}{HTML}{4B2E83}
\definecolor{USMGold}{HTML}{B58500}
\definecolor{SEEEBlue}{HTML}{004E7C}
\colorlet{BrandPrimary}{SEEEBlue}
\colorlet{BrandAccent}{USMGold}

% ---------- Hyperref ----------------------------------------------------------
\hypersetup{colorlinks=true, linkcolor=BrandPrimary, urlcolor=BrandPrimary}

% ---------- Header / Footer ---------------------------------------------------
\newcommand\lab@leftlogo{}
\newcommand\lab@rightlogo{}
\newcommand\lab@singlelogoPath{}
\newcommand\lab@singlelogoOpts{height=10mm}

\newcommand\lablogos[2]{\renewcommand\lab@leftlogo{#1}\renewcommand\lab@rightlogo{#2}}
\newcommand\lablogo[2][]{\renewcommand\lab@singlelogoOpts{#1}\renewcommand\lab@singlelogoPath{#2}}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[C]{%
  \vspace{5pt}% keep clear of banner
  \ifx\lab@singlelogoPath\empty
    \ifx\lab@leftlogo\empty\relax\else
      \raisebox{-0.2\height}{\includegraphics[height=10mm]{\lab@leftlogo}}%
    \fi
    \hspace{1em}%
    \ifx\lab@rightlogo\empty\relax\else
      \raisebox{-0.2\height}{\includegraphics[height=9.5mm]{\lab@rightlogo}}%
    \fi
  \else
    \includegraphics[\lab@singlelogoOpts]{\lab@singlelogoPath}%
  \fi
}
\fancyfoot[C]{\thepage}

% ---------- First-page banner (simple framed box) ----------------------------
\newcommand\firstpagebanner{%
  \vspace*{14mm}% space below header logos
  \noindent\fcolorbox{BrandPrimary}{BrandAccent!10}{%
    \parbox{\dimexpr\textwidth-2\fboxrule-2\fboxsep}{%
      {\rmfamily\bfseries\large \labcoursecode\; /\; \labsemester\; \quad Due Date:\; \rule{3cm}{0.4pt}}%
    }%
  }\par\medskip
}

% ---------- Metadata ----------------------------------------------------------
\newcommand\labcoursecode{EEM441}
\newcommand\labsemester{Semester I (2025/2026)}
\newcommand\labexperimenttitle{Experiment Title}
\newcommand\experimenttitle[1]{\renewcommand\labexperimenttitle{#1}}
\newcommand\coursecode[1]{\renewcommand\labcoursecode{#1}}
\newcommand\semester[1]{\renewcommand\labsemester{#1}}

% ---------- ToC in margin -----------------------------------------------------
\renewcommand{\contentsname}{Contents}
\setlength{\cftbeforesecskip}{2pt}
\newcommand\makemargintoc{%
  \marginpar{\raggedright\footnotesize\textbf{Contents}\par
    \vspace{0.3ex}\begin{minipage}[t]{\marginparwidth}\tableofcontents\end{minipage}}}

% ---------- Robust margin environments (capture body) ------------------------
\NewEnviron{Objectives}{%
  \marginpar{\raggedright\footnotesize\textbf{Objectives}\par
    \vspace{0.3ex}\begin{minipage}[t]{\marginparwidth}\BODY\end{minipage}}}
\NewEnviron{Apparatus}{%
  \marginpar{\raggedright\footnotesize\textbf{Apparatus}\par
    \vspace{0.3ex}\begin{minipage}[t]{\marginparwidth}\BODY\end{minipage}}}

\NewEnviron{ObjectivesList}{%
  \marginpar{\raggedright\footnotesize\textbf{Objectives}\par
    \vspace{0.3ex}\begin{minipage}[t]{\marginparwidth}%
      \begin{enumerate}[leftmargin=*,itemsep=0.2em,topsep=0.2em]\BODY\end{enumerate}%
    \end{minipage}}}
\NewEnviron{ApparatusList}{%
  \marginpar{\raggedright\footnotesize\textbf{Apparatus}\par
    \vspace{0.3ex}\begin{minipage}[t]{\marginparwidth}%
      \begin{enumerate}[leftmargin=*,itemsep=0.2em,topsep=0.2em]\BODY\end{enumerate}%
    \end{minipage}}}

% Convenience A–D list
\newlist{AlphaList}{enumerate}{1}
\setlist[AlphaList]{label=\Alph*) , leftmargin=1.2em, itemsep=.15em, topsep=.2em}

% ---------- Title page --------------------------------------------------------
\newcommand\makelabtitle{%
  \thispagestyle{empty}%
  \firstpagebanner
  \vspace{10pt}
  {\Huge\bfseries\labexperimenttitle}\par\vspace{2cm}
  \clearpage}

% ---------- Listings ----------------------------------------------------------
\lstset{basicstyle=\ttfamily\footnotesize, keywordstyle=\bfseries, commentstyle=\itshape\color{gray},
        numbers=left, numberstyle=\tiny, stepnumber=1, numbersep=5pt}
