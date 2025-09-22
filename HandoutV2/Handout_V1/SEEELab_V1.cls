% SEEELab_V1.cls — v1.3a
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{SEEELab_V1}[2025/09/22 v1.3a SEEELab layout]

\LoadClass[12pt,a4paper,twoside,openany]{memoir}

% ---------- Packages ----------
\RequirePackage{graphicx}
\RequirePackage{xcolor}
\RequirePackage{tikz}
\usetikzlibrary{calc,positioning}
\RequirePackage{eso-pic}
\RequirePackage{etoolbox}
\RequirePackage[most]{tcolorbox}

% ---------- Graphics path ----------
\newcommand\seee@graphicsdir{Figures/}
\newcommand{\SEEELabGraphicsDir}[1]{%
  \renewcommand\seee@graphicsdir{#1}\graphicspath{{\seee@graphicsdir}{./}}}
\AtBeginDocument{\graphicspath{{\seee@graphicsdir}{./}}%
  \DeclareGraphicsExtensions{.pdf,.png,.jpg,.jpeg}}

% ---------- Geometry (mm) ----------
\newcommand\seee@InnerMargin{28}
\newcommand\seee@BindingOffset{8}
\newcommand\seee@OuterMargin{48}
\newcommand\seee@TopMargin{25}
\newcommand\seee@BottomMargin{30}
\newcommand\seee@SidenoteWidth{20}
\newcommand\seee@HeaderBand{12}
\newcommand\seee@HeaderRuleGap{5}
\newcommand\seee@FooterBand{8}

\newlength\seeeInnerMargin      \setlength{\seeeInnerMargin}{\seee@InnerMargin mm}
\newlength\seeeBindingOffset    \setlength{\seeeBindingOffset}{\seee@BindingOffset mm}
\newlength\seeeOuterMargin      \setlength{\seeeOuterMargin}{\seee@OuterMargin mm}
\newlength\seeeTopMargin        \setlength{\seeeTopMargin}{\seee@TopMargin mm}
\newlength\seeeBottomMargin     \setlength{\seeeBottomMargin}{\seee@BottomMargin mm}
\newlength\seeeSidenoteWidth    \setlength{\seeeSidenoteWidth}{\seee@SidenoteWidth mm}
\newlength\seeeHeaderBandLen    \setlength{\seeeHeaderBandLen}{\seee@HeaderBand mm}
\newlength\seeeHeaderRuleGapLen \setlength{\seeeHeaderRuleGapLen}{\seee@HeaderRuleGap mm}
\newlength\seeeFooterBandLen    \setlength{\seeeFooterBandLen}{\seee@FooterBand mm}

\setstocksize{297mm}{210mm}
\settrimmedsize{\stockheight}{\stockwidth}{*}
\setbinding{\seeeBindingOffset}
\setlrmarginsandblock{\seeeInnerMargin}{\seeeOuterMargin}{*}
\setulmarginsandblock{\seeeTopMargin}{\seeeBottomMargin}{*}
\setmarginnotes{\seeeSidenoteWidth}{8mm}{5mm}
\setheadfoot{\seeeHeaderBandLen}{\seeeFooterBandLen}
\setheaderspaces{*}{\seeeHeaderRuleGapLen}{*}
\checkandfixthelayout

% ---------- Images ----------
\def\seee@lablogo{}\newcommand{\lablogo}[1]{\def\seee@lablogo{#1}}
\def\seee@badge{} \newcommand{\coursebadge}[1]{\def\seee@badge{#1}}

\newlength\seeeLogoH
\newlength\seeeBadgeH
\setlength{\seeeLogoH}{\seeeHeaderBandLen}\addtolength{\seeeLogoH}{-1mm}
\setlength{\seeeBadgeH}{\seeeHeaderBandLen}\addtolength{\seeeBadgeH}{-1mm}
\newcommand\seee@BadgeInsetNum{8}
\newcommand\seee@LogoShiftNum{8}
\newcommand{\SETLogoHeight}[1]{\setlength{\seeeLogoH}{#1}}
\newcommand{\SETBadgeHeight}[1]{\setlength{\seeeBadgeH}{#1}}
\newcommand{\SETBadgeInset}[1]{\renewcommand\seee@BadgeInsetNum{#1}}
\newcommand{\SETLogoShift}[1]{\renewcommand\seee@LogoShiftNum{#1}}

% ---------- Date box content ----------
\def\seee@StartDate{—}
\def\seee@SubmissionDate{—}
\newcommand{\StartDate}[1]{\def\seee@StartDate{#1}}
\newcommand{\SubmissionDate}[1]{\def\seee@SubmissionDate{#1}}
\def\seeeGroupVal{} \newcommand{\Group}[1]{\def\seeeGroupVal{#1}}

\newif\ifSEEELAB@datebox \SEEELAB@dateboxtrue
\newcommand{\SEEELabDateBoxOn}{\SEEELAB@dateboxtrue}
\newcommand{\SEEELabDateBoxOff}{\SEEELAB@dateboxfalse}
\newcommand\seee@DateBoxGap{1}
\newcommand{\SETDateBoxYOffset}[1]{\renewcommand\seee@DateBoxGap{#1}}
\newcommand\seee@DateBoxXOff{0}
\newcommand{\SETDateBoxXOffset}[1]{\renewcommand\seee@DateBoxXOff{#1}}
\def\seee@DateBoxWidthManual{}
\newcommand{\SETDateBoxWidth}[1]{\def\seee@DateBoxWidthManual{#1}}

% ---------- Colors / palettes ----------
\definecolor{USMSkyAccent}{HTML}{3B6EA5}
\definecolor{USMSkyBack}{HTML}{F0F6FF}
\definecolor{USMTealAccent}{HTML}{2B7A78}
\definecolor{USMTealBack}{HTML}{EAF4F2}

\tcbset{SEEE/datebox/base/.style={enhanced, boxrule=0.5pt, arc=1mm,
  left=1.5mm,right=1.5mm, top=.7mm,bottom=.7mm}}
\tcbset{SEEE/datebox/.style={SEEE/datebox/base,
  colback=USMTealBack, colframe=USMTealAccent}}
\newcommand{\UseDateBoxPalette}[1]{%
  \tcbset{SEEE/datebox/.style={SEEE/datebox/base, colback=#1!5, colframe=#1!60!black}}}
\def\seee@DateBoxFont{\sffamily\footnotesize}
\newcommand{\SETDateBoxFont}[1]{\def\seee@DateBoxFont{#1}}

% ---------- Debug header zones ----------
\newif\ifSEEELAB@showzones \SEEELAB@showzonesfalse
\newcommand{\SEEELabShowHeaderZonesOn}{\SEEELAB@showzonestrue}
\newcommand{\SEEELabShowHeaderZonesOff}{\SEEELAB@showzonesfalse}

% ---------- Header band with named datebox node ----------
\newcommand*\SEEELabHeader{%
  \AddToShipoutPictureBG*{%
    \begin{tikzpicture}[remember picture, overlay, x=1mm, y=1mm]
      \pgfmathsetmacro{\PW}{\paperwidth/1mm}
      \pgfmathsetmacro{\PH}{\paperheight/1mm}
      \pgfmathsetmacro{\Inner}{\seee@InnerMargin + \seee@BindingOffset}
      \pgfmathsetmacro{\Outer}{\seee@OuterMargin}
      \pgfmathsetmacro{\Top}{\seee@TopMargin}
      \pgfmathsetmacro{\HB}{\seee@HeaderBand}
      \pgfmathsetmacro{\YBot}{\PH - \Top}
      \pgfmathsetmacro{\YTop}{\YBot + \HB}

      \ifodd\value{page}
        \pgfmathsetmacro{\XTextMin}{\Inner}
        \pgfmathsetmacro{\XTextMax}{\PW - \Outer}
        \pgfmathsetmacro{\BadgeL}{\XTextMax}
        \pgfmathsetmacro{\BadgeR}{\PW}
      \else
        \pgfmathsetmacro{\XTextMin}{\Outer}
        \pgfmathsetmacro{\XTextMax}{\PW - \Inner}
        \pgfmathsetmacro{\BadgeL}{0}
        \pgfmathsetmacro{\BadgeR}{\Outer}
      \fi
      \pgfmathsetmacro{\LogoCenterX}{0.5*(\XTextMin+\XTextMax)}
      \pgfmathsetmacro{\Inset}{\seee@BadgeInsetNum}
      \pgfmathsetmacro{\LogoShift}{\seee@LogoShiftNum}
      \ifodd\value{page}\pgfmathsetmacro{\LogoX}{\LogoCenterX - \LogoShift}
      \else\pgfmathsetmacro{\LogoX}{\LogoCenterX + \LogoShift}\fi

      % logo zone (optional)
      \ifx\seee@lablogo\@empty\else
        \node[anchor=center] at (\LogoX, \YBot+0.5*\HB)
          {\includegraphics[height=\seeeLogoH,keepaspectratio]{\seee@lablogo}};
      \fi

      % badge (named node for datebox anchoring)
      \ifx\seee@badge\@empty
        \ifodd\value{page}
          \node[anchor=east, inner sep=0] (seeeBadge)
            at (\BadgeR-\Inset, \YBot+0.5*\HB) {\rule{18mm}{\seeeBadgeH}};
        \else
          \node[anchor=west, inner sep=0] (seeeBadge)
            at (\BadgeL+\Inset, \YBot+0.5*\HB) {\rule{18mm}{\seeeBadgeH}};
        \fi
      \else
        \ifodd\value{page}
          \node[anchor=east, inner sep=0] (seeeBadge)
            at (\BadgeR-\Inset, \YBot+0.5*\HB)
            {\includegraphics[height=\seeeBadgeH,keepaspectratio]{\seee@badge}};
        \else
          \node[anchor=west, inner sep=0] (seeeBadge)
            at (\BadgeL+\Inset, \YBot+0.5*\HB)
            {\includegraphics[height=\seeeBadgeH,keepaspectratio]{\seee@badge}};
        \fi
      \fi

      % date box (named: seeeDateBox)
      \ifSEEELAB@datebox
        \pgfmathsetmacro{\Gap}{\seee@DateBoxGap}
        \pgfmathsetmacro{\XOff}{\seee@DateBoxXOff}
        \pgfmathsetmacro{\DateW}{max(10, \Outer - 2*\Inset)}
        \edef\SEEE@DateWidthArg{\DateW mm}%
        \ifx\seee@DateBoxWidthManual\@empty\else\edef\SEEE@DateWidthArg{\seee@DateBoxWidthManual}\fi
        \ifodd\value{page}
          \node[anchor=north east, inner sep=0] (seeeDateBox)
            at ([xshift=-\XOff mm, yshift=-\Gap mm] seeeBadge.south east) {%
              \begin{tcolorbox}[SEEE/datebox, width=\SEEE@DateWidthArg]
                {\seee@DateBoxFont \textbf{Group:}~\seeeGroupVal\\[-1pt]
                 \textbf{Start Date:}~\seee@StartDate\\[-1pt]
                 \textbf{Submission Date:}~\seee@SubmissionDate}
              \end{tcolorbox}};
        \else
          \node[anchor=north west, inner sep=0] (seeeDateBox)
            at ([xshift=\XOff mm, yshift=-\Gap mm] seeeBadge.south west) {%
              \begin{tcolorbox}[SEEE/datebox, width=\SEEE@DateWidthArg]
                {\seee@DateBoxFont \textbf{Group:}~\seeeGroupVal\\[-1pt]
                 \textbf{Start Date:}~\seee@StartDate\\[-1pt]
                 \textbf{Submission Date:}~\seee@SubmissionDate}
              \end{tcolorbox}};
        \fi
      \fi
    \end{tikzpicture}%
  }%
}
\AtBeginDocument{\SEEELabHeader}

% ---------- Page style (centered page number) ----------
\makepagestyle{seeelab}
\makeoddhead{seeelab}{}{}{}
\makeevenhead{seeelab}{}{}{}
\makeoddfoot{seeelab}{}{\thepage}{}
\makeevenfoot{seeelab}{}{\thepage}{}
\pagestyle{seeelab}
\aliaspagestyle{chapter}{seeelab}

% ---------- “Article-like” numbering (no chapter numbers) ----------
\AtBeginDocument{%
  \setcounter{secnumdepth}{3}\setcounter{tocdepth}{2}%
  \renewcommand{\thesection}{\arabic{section}}%
  \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}%
  \renewcommand{\thesubsubsection}{\thesubsection.\arabic{subsubsection}}%
}

% ---------- Title block (NOT a heading) ----------
\newlength\seeeTitleXShift \setlength{\seeeTitleXShift}{0mm}
\newlength\seeeTitleYShift \setlength{\seeeTitleYShift}{0mm}
\newcommand{\SETTitleXShift}[1]{\setlength{\seeeTitleXShift}{#1}}
\newcommand{\SETTitleYShift}[1]{\setlength{\seeeTitleYShift}{#1}}
\newcommand{\Experiment}[2]{%
  \vspace*{\seeeTitleYShift}\noindent\hspace*{-\seeeTitleXShift}%
  \begin{minipage}{\dimexpr\linewidth+\seeeTitleXShift\relax}
    {\bfseries\Huge Experiment~#1\par}\vspace{2pt}
    {\bfseries\LARGE #2\par}%
  \end{minipage}\par\vspace{.8\baselineskip}%
}

% ---------- Abstract (centered label + width trim) ----------
\newlength\seeeAbstractRightTrim \setlength{\seeeAbstractRightTrim}{0mm}
\newcommand{\SETAbstractRightTrim}[1]{\setlength{\seeeAbstractRightTrim}{#1}}
\newenvironment{SEEEAbstract}{%
  \par\addvspace{.6\baselineskip}%
  \noindent\centerline{\textbf{Abstract}}\smallskip
  \noindent\begin{minipage}{\dimexpr\linewidth-\seeeAbstractRightTrim\relax}\small
}{%
  \end{minipage}\par\addvspace{.6\baselineskip}
}

% ---------- Margin TOC + Objectives/Apparatus ----------
\newlength\seeeMarginTOCWidth \setlength{\seeeMarginTOCWidth}{\seeeSidenoteWidth}
\newlength\seeeMarginTOCAfterDate \setlength{\seeeMarginTOCAfterDate}{1mm}
\newlength\seeeMarginTOCXOff      \setlength{\seeeMarginTOCXOff}{0mm}
\newlength\seeeMarginTOCInset     \setlength{\seeeMarginTOCInset}{2mm}
\newlength\seeeMarginTOCYGap      \setlength{\seeeMarginTOCYGap}{1.5mm}
\newcommand{\SETMarginTOCWidth}[1]{\setlength{\seeeMarginTOCWidth}{#1}}
\newcommand{\SETMarginTOCAfterDate}[1]{\setlength{\seeeMarginTOCAfterDate}{#1mm}}
\newcommand{\SETMarginTOCXOffset}[1]{\setlength{\seeeMarginTOCXOff}{#1mm}}
\newcommand{\SETMarginTOCInset}[1]{\setlength{\seeeMarginTOCInset}{#1mm}}
\newcommand{\SETMarginTOCYGap}[1]{\setlength{\seeeMarginTOCYGap}{#1mm}}
\def\seeeTOCfont{\sffamily\small}
\newcommand{\SETMarginTOCFont}[1]{\def\seeeTOCfont{#1}}

\def\seeeObjectives{}\newcommand{\Objectives}[1]{\def\seeeObjectives{#1}}
\def\seeeApparatus{} \newcommand{\Apparatus}[1]{\def\seeeApparatus{#1}}
\newlength\seeeSideGap \setlength{\seeeSideGap}{3mm}
\newcommand{\SETSideGap}[1]{\setlength{\seeeSideGap}{#1mm}}
\tcbset{SEEE/sidebox/.style={enhanced, arc=1mm, boxrule=.5pt,
  colback=USMSkyBack, colframe=USMSkyAccent,
  left=1mm,right=1mm,top=.8mm,bottom=.8mm}}

% --- TOC storage (no @ in the name -> robust) ---
\newsavebox{\seeeTOCbox}
\newlength\seeeTOCheight
\newif\ifSEEE@TOCdebug \SEEE@TOCdebugfalse
\newcommand{\SEEEDebugTOCOn}{\SEEE@TOCdebugtrue}
\newcommand{\SEEEDebugTOCOff}{\SEEE@TOCdebugfalse}

\makeatletter
\newcommand\seee@setTOClen[2]{\@ifundefined{#1}{}{\expandafter\setlength\csname #1\endcsname{#2}}}
\newcommand\seee@setTOCcmd[2]{\@ifundefined{#1}{}{\expandafter\renewcommand\csname #1\endcsname{#2}}}

\newcommand{\seee@buildtocbox}{%
  \setcounter{tocdepth}{2}%
  \seee@setTOCcmd{cftchapterfont}{\sffamily\bfseries}
  \seee@setTOCcmd{cftsectionfont}{\sffamily}
  \seee@setTOCcmd{cftsubsectionfont}{\sffamily}
  \seee@setTOCcmd{cftchapterpagefont}{\sffamily}
  \seee@setTOCcmd{cftsectionpagefont}{\sffamily}
  \seee@setTOCcmd{cftsubsectionpagefont}{\sffamily}
  \seee@setTOClen{cftbeforechapskip}{2pt}
  \seee@setTOClen{cftbeforesecskip}{1pt}
  \seee@setTOClen{cftbeforesubsecskip}{1pt}
  \seee@setTOCcmd{cftdotsep}{1}
  \begin{lrbox}{\seeeTOCbox}
    \begin{minipage}[t]{\seeeMarginTOCWidth}
      \seeeTOCfont\raggedright
      \@starttoc{toc}%
    \end{minipage}
  \end{lrbox}
  \setlength{\seeeTOCheight}{\dimexpr\ht\seeeTOCbox+\dp\seeeTOCbox\relax}
}

\newcommand{\SEEEtableofcontents}{%
  \seee@buildtocbox
  \AddToShipoutPictureFG*{%
    \begin{tikzpicture}[remember picture,overlay,x=1mm,y=1mm]
      \ifcsname pgf@sh@ns@seeeDateBox\endcsname
        \ifodd\value{page}
          \coordinate (SEEEtoc) at
            ([xshift=\seeeMarginTOCXOff, yshift=-\seeeMarginTOCAfterDate] seeeDateBox.south east);
          \node[anchor=north east, inner sep=0] at (SEEEtoc) {\usebox{\seeeTOCbox}};
          \ifSEEE@TOCdebug \draw[magenta] (SEEEtoc) node[magenta] {$\times$};\fi
          \coordinate (SEEEside) at ([yshift=-\seeeTOCheight-\seeeSideGap] SEEEtoc);
          \node[anchor=north east, inner sep=0] at (SEEEside) {%
            \begin{minipage}{\seeeMarginTOCWidth}\seeeTOCfont
              \begin{tcolorbox}[SEEE/sidebox,title=Objectives]\seeeObjectives\end{tcolorbox}\vspace{1mm}
              \begin{tcolorbox}[SEEE/sidebox,title=Apparatus]\seeeApparatus\end{tcolorbox}
            \end{minipage}};
        \else
          \coordinate (SEEEtoc) at
            ([xshift=-\seeeMarginTOCXOff, yshift=-\seeeMarginTOCAfterDate] seeeDateBox.south west);
          \node[anchor=north west, inner sep=0] at (SEEEtoc) {\usebox{\seeeTOCbox}};
          \ifSEEE@TOCdebug \draw[magenta] (SEEEtoc) node[magenta] {$\times$};\fi
          \coordinate (SEEEside) at ([yshift=-\seeeTOCheight-\seeeSideGap] SEEEtoc);
          \node[anchor=north west, inner sep=0] at (SEEEside) {%
            \begin{minipage}{\seeeMarginTOCWidth}\seeeTOCfont
              \begin{tcolorbox}[SEEE/sidebox,title=Objectives]\seeeObjectives\end{tcolorbox}\vspace{1mm}
              \begin{tcolorbox}[SEEE/sidebox,title=Apparatus]\seeeApparatus\end{tcolorbox}
            \end{minipage}};
        \fi
      \fi
    \end{tikzpicture}%
  }%
  \thispagestyle{seeelab}%
}
\renewcommand{\tableofcontents}{\SEEEtableofcontents}
\makeatother
