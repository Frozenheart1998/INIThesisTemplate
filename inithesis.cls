%%
%% inithesis -- a document class for thesiss and theses
%% conforming to the 2007 Carnegie Mellon University guidelines.  This class is by
%% Michael Gratton.  It is based on the 2004 LaTeX 2e version of 
%% report.cls and code in the older dukethesis.sty.
%%
%% report.cls is Copyright 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 
%% 2003 2004 The LaTeX3 Project.
%%
%% inithesis.cls contained work by Daniel Votipka, Mark Holliday, Charlie Martin, Russ Tuck,
%% Sean O'Connell, Michael Todd, Syam Gadde, and Rajiv Wickremesinghe.
%% 
%% 
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%% 
%% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
%%
%% Version 1
%% Mar 10, 2012  - Daniel Votipka (dvotipka@andrew.cmu.edu)
%% 
%% This class conforms to the 2012 CIT style guidelines for theses,
%% including:
%% 1) Page numbers centered in the footer of each page
%% 2) Margins: 1in all around
%% 3) Title page and copyright page automatically generated at \maketitle.  
%%    The signature page is imported from signature.pdf
%% 4) 'Double' spacing throughout body text (really about 10pt extra instead
%%    of 12pt extra, but it passes)
%% 5) Single spacing in the Table of Contents, List of Tables, List of 
%%    Figures, Bibliography, and in chapter, section titles, and figure/table 
%%    captions.
%% 6) Footnotes are numbered consecutively within a chapter and placed at the
%%    bottom of the page on which the reference number appears.
%% 7) Page ordering and numbering: roman numeral page numbers appear
%%    in the frontmatter (prior to the introduction or Chapter 1).  The first 
%%    numbered page is the Abstract (usuall iv).  Arabic numbering from '1'
%%    starts in the Introduction or Chapter 1 if there's no Introduction.
%% 8) Optional material supported: 
%%    *Acknowledgements
%%    *Appendicies
%%
%% This class also provides some handy features:
%% 1) Use the option 'economy' to get a single-spaced document appropriate for
%%    giving to colleagues.
%% 2) Change your copyright from 'All rights reserved' if you're not actaully
%%    reserving all your rights.
%%


\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{inithesis}
              [2007/04/16 Version 0.3]
\RequirePackage{graphicx}
\RequirePackage{ifthen}

% Test if pdflatex is being used
%\newif\ifpdf\ifx\pdfoutput\undefined\pdffalse\else\pdfoutput=1\pdftrue\fi

% Internal logic (replicates some book.cls features)
\newif\if@frontmatter
\@frontmattertrue
\newif\if@inappendix
\@inappendixfalse

% Option switches and their default values
\newif\if@Gradschool  % Produce extra frontmatter for grad school
\newif\if@MS  % Masters thesis format
\newlength\@SimSpace  % double-space
\newlength\@OpenupSpace
\newboolean{oldstyle} 
\newboolean{centerpage}


\DeclareOption{economy}{%  Set a bunch of options at once
  \ExecuteOptions{singlespace,nogradschool,nobind}
}
\DeclareOption{gradschool}{\@Gradschooltrue}
\DeclareOption{nogradschool}{\@Gradschoolfalse}
\DeclareOption{MS}{\@MStrue}
\DeclareOption{PhD}{\@MSfalse}
\DeclareOption{oldstyle}{\setboolean{oldstyle}{true}}
\DeclareOption{newstyle}{\setboolean{oldstyle}{false}}
\DeclareOption{nobind}{\setboolean{centerpage}{true}}
\DeclareOption{bind}{\setboolean{centerpage}{false}}
\DeclareOption{doublespace}{%
	\setlength\@SimSpace{10pt} % Simulated double-space skip
	\setlength\@OpenupSpace{3\jot}
}
\DeclareOption{singlespace}{%
	\setlength\@SimSpace{\z@}  % Zero simulated double-space
	\setlength\@OpenupSpace{\z@}
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ExecuteOptions{gradschool,PhD,doublespace,newstyle,bind}
\ProcessOptions\relax
\LoadClass[12pt,letterpaper]{report}

% Float parameters.  Allow more float per page, open up spacing
\renewcommand{\topfraction}{.75}
\renewcommand{\bottomfraction}{.75}
\renewcommand{\textfraction}{.15}  % About 3 lines of double-spaced text
\renewcommand{\floatpagefraction}{.8}
\renewcommand{\dbltopfraction}{.97}
\renewcommand{\dblfloatpagefraction}{.9}
\setlength{\floatsep}{12pt plus 6pt minus 4pt}
\setlength{\textfloatsep}{15pt plus 8pt minus 5pt}
\setlength{\intextsep}{12pt plus 6pt minus 4pt}
\setlength{\dblfloatsep}{12pt plus 6pt minus 4pt}
\setlength{\dbltextfloatsep}{15pt plus 8pt minus 5pt}
% Float pages have floats near the top of the page
\setlength{\@fptop}{12pt minus 6pt}% removed ``plus 1fil''
\setlength{\@fpsep}{24pt plus 12pt minus 12pt}% removed ``plus 2fil''
\setlength{\@fpbot}{0pt plus 1fil}
\setlength{\@dblfptop}{0pt}% removed ``plus 1fil''
\setlength{\@dblfpsep}{24pt plus 12pt minus 12pt}% removed ``plus 2fil''
\setlength{\@dblfpbot}{0pt plus 1fil}


%-----------------------------------------------------------
%       DOUBLE    S P A C I N G:
% Most of the bother in the thesis format is in the disgusting double
% spacing requirements.  We handle it by a bit of plain TeX.  The 
% \openup command increases the space between baselines unscaled by font
% size.  Double-spacing is
% turned off by the macro \normalbaselines in figure captions, the toc,
% lof, lot, and bibliography.  In the later four, we FAKE double-spacing,
% typically with a \@SimSpace vertical space between entries.
% -----------------------------------------------------------
\newcommand{\@textspace}{\openup \@OpenupSpace\relax}


%-----------------------------------------------------------------------
% Names of environments
%-----------------------------------------------------------------------
\newcommand\ackname{Acknowledgements}

%-----------------------------------------------------------------------
%% Page size specifications
%-----------------------------------------------------------------------
%% Goal: 1.5in on binding edge.  Default 72pt margin plus 36pt
\ifthenelse{\boolean{centerpage}}{%
\setlength{\oddsidemargin}{0.25in}
\setlength{\evensidemargin}{0.25in}
}
{
\setlength{\oddsidemargin}{.25in} 
\if@twoside
	\setlength{\evensidemargin}{0in}
\else
	\setlength{\evensidemargin}{\oddsidemargin}
\fi
}
%% Deal with known screwiness in the top text placement.
\setlength{\topmargin}{ -24pt}
%% A page consists of 72pt top margin + 0pt header + X body height
%%                  + 25pt foot (with pg number) + 72pt bottom margin
%%                = 792pt = 11in
\setlength{\headheight}{0pt}
\setlength{\textheight}{ 623pt}
\setlength{\footskip}{ 25pt}
\setlength{\textwidth}{ 430pt}

%----------------------------------------------------------------------
% Variables for titlepages
%----------------------------------------------------------------------
\newcommand{\department}[1]{\gdef\@department{#1}}
\newcommand{\program}[1]{\gdef\@program{#1}}
%\newcommand{\subject}[1]{\gdef\@subject{#1}}
\newcommand{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand{\advisor}[1]{\gdef\@advisor{#1}}
\newcommand{\departmenthead}[1]{\gdef\@departmenthead{#1}}
\newcommand{\dean}[1]{\gdef\@dean{#1}}
\newcommand{\fulldate}[1]{\gdef\@fulldate{#1}}
\newcommand{\previousdegreelist}[1]{\gdef\@previousdegreelist{#1}}
\newcommand{\copyrighttext}[1]{\gdef\@copyrighttext{#1}}
\newcommand{\degreeyear}[1]{\gdef\@degreeyear{#1}}
% Set default values
\department{??DEPARTMENT??}
%\departmenthead{??DEPARTMENT HEAD??}
%\dean{??DEAN??}
\program{??PROGRAM??}
%\subject{\@department}  
%\supervisor{??THESIS ADVISOR??}
%\advisor{??ACADEMIC ADVISOR??}
\fulldate{??DATE??}
\previousdegreelist{??PREVIOUS DEGREES??}
\copyrighttext{All rights reserved}
\degreeyear{???}
% Count the number of members, include supervisor
\newcounter{@members}           % Number of member macros defined so far.
%\newcommand{\@membera}{\@member{\@supervisor, THESIS ADVISOR}}
%\setcounter{@members}{1}        % Supervisor is always 1st member
%\newcommand{\@memberb}{\@member{\@advisor, ACADEMIC ADVISOR}}
%\setcounter{@members}{2}
%\newcommand{\@memberc}{\@member{\@departmenthead, DEPARTMENT HEAD}}
%\setcounter{@members}{3}
%\newcommand{\@memberd}{\@member{\@dean, DEAN}}
%\setcounter{@members}{4}
% Members must be counted . . . up to seven non-supervisor members
\newcommand{\member}[1]{
  \addtocounter{@members}{1}    % Inc. num of members to include this new one.
  \ifcase\value{@members}
	 \or \or  
    \newcommand{\@memberb}{\@member{#1}} \or
    \newcommand{\@memberc}{\@member{#1}} \or
    \newcommand{\@memberd}{\@member{#1}} \or
    \newcommand{\@membere}{\@member{#1}} \or
    \newcommand{\@memberf}{\@member{#1}} \or
    \newcommand{\@memberg}{\@member{#1}}
  \else
     \ClassError{inithesis.cls}
        {Thesis format error.  Too many committee members.} 
  \fi
}
% Print a committee member's name with a signature line
\newcommand{\@member}[1]{
%\parbox{2.8in}{%
  \vskip 6.0ex  % Leave some room for signature
  %\raisebox{-8pt}[0pt][17pt]{\rule{2.8in}{.5pt} \hskip 1ex \rule{1in}{.5pt}}\par   % Print signature line.
  %\hfil \raisebox{0pt}[0pt][0pt]{#1 \hskip 1ex DATE} \hfil     % Print member name.
  \rule{3.45in}{.5pt} \hspace{.3in}\rule{1in}{.5pt}\par
  {\scriptsize #1 \hspace{.95in} DATE}
  %}
}

\renewcommand{\thefigure}{Figure \arabic{chapter}.\arabic{figure}}
\renewcommand{\thetable}{Table \arabic{chapter}.\arabic{table}}
\renewcommand{\tablename}{}

% -----------------------------------------------------------------------
% TITLE PAGES:
% a) make title page and copyright page
% b) if we're making g-school approved vers, make UMI abs page
% -----------------------------------------------------------------------
\renewcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  %\@signaturepage
  \newpage
  \thispagestyle{empty}
  \null
  \normalbaselines
  \begin{center}%
   {\openup 2pc \LARGE {\bf \@title} \par}%
   \vskip 3em%
   	 \normalsize Submitted in partial fulfillment of the requirements for \par%
    	\vskip 1em%
    	 \normalsize the degree of \par%
    	 \vskip 1em%
	 \normalsize Master of Science \par%
	 \vskip 1em%
	 \normalsize in \par%
	 \vskip 1em%
	 \normalsize \@program \par%
	 %\vskip 1em%
	% \normalsize by \par%
	 \vskip 5 em%
    {\large \@author \par }%
      \vskip 3em%
    	\normalsize \@previousdegreelist \par
%	 \normalsize \@department \par
%	 Carnegie Mellon University \par
% \if@Gradschool
%	\vskip 4ex%	
%	Date: \makebox[2in]{\hrulefill}\par\noindent
	%\vfill
  % \vskip 1em%
   %{\small Approved:\par}%
	%\@printsiglines
%\fi
	\vfill 
	\par
	\vspace{1em plus 2em minus 1em}
  \par \normalbaselines \noindent
 \if@Gradschool
	\if@MS
     {\normalsize
    	 Carnegie Mellon University
		\par Pittsburgh, PA \par 
		\vskip 2em%
     		 \par}
	\else
     {\normalsize
      thesis submitted in partial fulfillment of the requirements for the
      degree of 
		\par Doctor~of~Philosophy in the Department~of~\@department
      \par in the Graduate~School of ini~University\par}
  \fi
 \else
	\if@MS
      {\small M.S. Thesis } \par
	\else
      {\small Ph.D. thesis } \par
	\fi
 \fi
  \@fulldate
  \end{center}% 

  % UMI Abstract page too?
 % \if@Gradschool \if@MS \else
 % \@UMIabstract
  %\fi \fi

  % Everyone gets a copyright! Yay!
  \@copyrightpage
}

\newcommand\@UMIabstract{%
	\newpage
	\thispagestyle{empty}
	\null
	\normalbaselines
	\begin{center}
	{\Large \sc \underline{Abstract} \par}
	%{\normalsize (\@subject) \par }
	\vskip 1em%
	{\Large \@title \par}
	\vskip 1em%
	{\normalsize by \par }
	\vskip 1em%
	{\large \@author \par }
	  \vskip 1em%
	{\normalsize \@department \par Carnegie Mellon University }
	\vskip 4ex%
	Date: \makebox[2in]{\hrulefill}\par\noindent
	%\vskip 1em%
	%\vfill
   {\small Approved:\par}%
	\@printsiglines
	\vfill
   \par \normalbaselines \noindent
   {\normalsize%
   An abstract of a thesis submitted in partial fulfillment of the 
   requirements for 
	\par the degree of Doctor~of~Philosophy in the Department~of~\@department
	\par in the Graduate~School of Carnegie Mellon~University } \par
	{\normalsize \number\year}
   \end{center}% 
	\newpage
}

% Member signature lines function
% Print the committee members defined by the user.
% 0.4 -- removed 2-up layout, so page is ugly again.
\newcounter{@membersprinted}

\newcommand\@printsiglines{%
 \setcounter{@membersprinted}{0}
    \loop
      \ifnum \value{@membersprinted} < \value{@members}
         \addtocounter{@membersprinted}{1}
         \ifcase\value{@membersprinted}
           \or
           \@membera \par \or
           \@memberb \par \or
           \@memberc \par \or
           \end{flushright}
           \noindent {\scriptsize {\bf APPROVED BY THE COLLEGE COUNCIL}} \par
           \begin{flushright}
           \@memberd \par \or
           \@membere \par \or
           \@memberf \par \or
			\else \typeout{Too many committee members defined!}
         \fi
    \repeat
}%

%Signature page
\newcommand\@signaturepage{%
	\newpage
	\thispagestyle{empty}
	\normalbaselines
	  \begin{center}%
	    {\openup 2pc \LARGE {\bf Carnegie Mellon University} \par}%
	    \vskip 1em%
	    \large CARNEGIE INSTITUTE OF TECHNOLOGY \par%
	    \vskip 3em
	    \large THESIS \par%
	    \vskip 1em 
	    {\scriptsize SUBMITTED IN PARTIAL FULFILLMENT OF THE REQUIREMENTS} \par
	    \vskip 1em
	    {\scriptsize FOR THE DEGREE OF} {\normalsize{\bf Master of Science}} \par
	    \vskip 5em
	\end{center}
	{\scriptsize {\bf TITLE}} \hfill \underline{\makebox[4.8in][r]{\hfill{\normalsize \@title}\hfill}} \par
	\vskip 2em
	\noindent {\scriptsize {\bf PRESENTED BY}}  \underline{\makebox[4.8in][r]{\hfill{\normalsize \@author \hfill}}}\par
	\vskip 2em
	\noindent {\scriptsize {\bf ACCEPTED BY THE DEPARTMENT OF}}\par
	\vskip 1em
	\begin{flushright}
	\underline{\makebox[4.8in][r]{
		\hfill{\normalsize \@department}\hfill
	}}\par
	\@printsiglines
	\end{flushright}
}

% Copyright page
\newcommand\@copyrightpage{%
	\newpage
	\thispagestyle{empty}
	\normalbaselines
	\null
	\vfill
	\begin{center}
		\copyright\enspace \@author,\enspace\number\@degreeyear \par
		\@copyrighttext
	\end{center}
	\newpage
}%

% G-school does not allow parts!
\renewcommand\part{%
 \ClassWarning{Grad School guidelines forbid the use of parts!}
}
% % Modified the part env to start arabic page numbering 
% \renewcommand\part{%
%   \if@openright
%     \cleardoublepage
%   \else
%     \clearpage
%   \fi
%    \if@frontmatter
% 	   \@frontmatterfalse
% 	   \pagenumbering{arabic}
% 		\setcounter{page}{1}
% 	\fi
%   \thispagestyle{plain}%
%   \@tempswafalse
%   \null\vfil
%   \secdef\@part\@spart}
% \ifthenelse{\boolean{oldstyle}}{ }
% {
%   \def\@part[#1]#2{%
%   \ifnum \c@secnumdepth >-2\relax
%       \refstepcounter{part}%
%       \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
%     \else
%       \addcontentsline{toc}{part}{#1}%
%     \fi
%     \markboth{}{}%
%     {\centering
%      \interlinepenalty \@M
%      \normalfont
%      \ifnum \c@secnumdepth >-2\relax
% 	  {\large \bfseries Part} \par {\Huge\bfseries \thepart}
%        \par
%      \fi
%      \vskip 20\p@
%      \normalbaselines \huge \bfseries #2\par}%
%     \@endpart}
% }

%-------------------------------------------------------------------------
% Chapter format:
%-------------------------------------------------------------------------
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                         \refstepcounter{chapter}%
%                         \setcounter{chapter}{\value{chapter}+1}
%                         \setcounter{section}{0}
%                         \setcounter{subsection}{0}
%                         \setcounter{subsubsection}{0}
%                         \setcounter{paragraph}{0}
%                         \setcounter{subparagraph}{0}
		      % Done with frontmatter?
		      \if@frontmatter
			\@frontmatterfalse
			\pagenumbering{arabic}
			\setcounter{page}{1}
		      \fi
                         \typeout{\@chapapp\space\thechapter.}%                      
                         \if@inappendix
                         \addcontentsline{toc}{chapter}%
                                   {Appendix \protect\numberline{\thechapter}#1}%
                         \else
                         \addcontentsline{toc}{chapter}%
                                   {\protect\numberline{\thechapter}#1}%
                         \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \@makechapterhead{#2}%
                    \@afterheading
						  \normalbaselines
						  \@textspace  % double-spaced chapter text
}
% Format for normal chapters (and appendicies)
\ifthenelse{\boolean{oldstyle}}{ }
{%
\def\@makechapterhead#1{%
\vspace*{1in} % Leave space at top of page
  { 
  \parindent \z@ \raggedright \normalfont
		  \if@inappendix
		  % Include the word 'Appendix'
		  \makebox[\textwidth][r]{\Huge\bfseries \@chapapp\space\thechapter} 
		  \else
		  % Don't include the word 'Chapter'
		  \makebox[\textwidth][r]{\Huge\bfseries \thechapter} 
		  \fi
        \par\nobreak
        \vskip 10\p@
    \interlinepenalty\@M
	 % Title format
	 \parbox{\textwidth}{ \flushright{%
	  \normalbaselines \LARGE  #1  \par\nobreak }}
    \vskip 40\p@
  }%
  \vspace*{50\p@}%
  }

}

% A non-mainmatter chapter that appears in the ToC
\def\nmchapter#1{   
	\chapter*{#1}
   \addcontentsline{toc}{chapter}{#1}%
	\thispagestyle{plain}
	\normalbaselines
	\@textspace
}



%-------------------------------------------------------------------------
% Section format:
% \@startsection {NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE}
%            optional * [ALTHEADING]{HEADING}
%-------------------------------------------------------------------------
\ifthenelse{\boolean{oldstyle}}{%
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                              {\normalbaselines\normalfont\Large\bfseries}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                              {\normalbaselines\normalfont\large\bfseries}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                              {\normalbaselines\normalfont\normalsize\bfseries}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                              {\normalbaselines\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                              {\normalbaselines\normalfont\normalsize\bfseries}}
}
{%
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
					{\normalbaselines \normalfont\large}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
				  {\normalbaselines \normalfont\normalsize}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
				  {\normalbaselines \normalfont\normalsize\it}}
\renewcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus 1ex \@minus.2ex}%
                                    {-1em}%
				 {\normalbaselines \normalfont\small\it}}
\renewcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus 1ex \@minus .2ex}%
                                       {-1em}%
				 {\normalbaselines \normalfont\small\it}}
}



\newenvironment{symbollist}
{%
\normalbaselines
\begin{list}{ }{%
	\addtolength{\topsep}{0.5\@SimSpace}
	\addtolength{\itemsep}{0.5\@SimSpace}
	\setlength{\labelwidth}{0.24\textwidth}
	\setlength{\labelsep}{2em}
	\setlength{\parsep}{0pt}
	\setlength{\leftmargin}{\labelwidth}
	\setlength{\rightmargin}{0pt}
	}
}
{ \end{list} } 
\renewcommand\appendix{\par
  \@inappendixtrue
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}
}

%----------------------------------------------------------------
% Figure format
%----------------------------------------------------------------
% Note smallcaps 'Figure' instead of bold
\ifthenelse{\boolean{oldstyle}}{ }{%
%\def\fnum@figure{{\sc \figurename\nobreakspace\thefigure}}
\def\fnum@figure{{\thefigure}}
}
\setlength\abovecaptionskip{\z@} % reduced from 10pt
\setlength\belowcaptionskip{12pt plus 12 pt minus 12pt} % increased from 0\p@
% Single space captions
\long\def\@makecaption#1#2{%
  \vspace{1.5em}
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\normalbaselines #1: #2}%
  \ifdim \wd\@tempboxa >\hsize
   \normalbaselines #1: #2\par
  \else
    \global \@minipagefalse
	 \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip
}



%---------------------------------------------------------------------
% Table of contents, list of figures, list of tables
%---------------------------------------------------------------------
% Single space entries
\renewcommand\contentsname{\LARGE Table of Contents}

\renewcommand\tableofcontents{%
    \chapter*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
	 \normalbaselines
	 \@starttoc{toc}%
}
% Used \addvspace{\@SimSpace} to simulate double-spacing
\renewcommand*\l@section{{\protect\addvspace{\@SimSpace}}\@dottedtocline{1}{1.5em}{2.3em}}
\renewcommand*\l@subsection{{\protect\addvspace{\@SimSpace}}\@dottedtocline{2}{3.8em}{3.2em}}
\renewcommand*\l@subsubsection{{\protect\addvspace{\@SimSpace}}\@dottedtocline{3}{7.0em}{4.1em}}
\renewcommand*\l@paragraph{{\protect\addvspace{\@SimSpace}}\@dottedtocline{4}{10em}{5em}}
\renewcommand*\l@subparagraph{{\protect\addvspace{\@SimSpace}}\@dottedtocline{5}{12em}{6em}}
% Single spacing again . . .
\renewcommand\listoffigures{%
    \chapter*{\LARGE \listfigurename}%
	 %\addcontentsline{toc}{chapter}{\listfigurename}%
      \@mkboth{\MakeUppercase \listfigurename}%
              {\MakeUppercase \listfigurename}%
	 \normalbaselines
	 \@starttoc{lof}%
    }
% Used \addvspace{\@SimSpace} to simulate double-spacing
\renewcommand*\l@figure{{\protect\addvspace{\@SimSpace}}\@dottedtocline{1}{1.5em}{2.3em}}
% And again with single spacing . . .
\renewcommand\listoftables{%
    \chapter*{\LARGE \listtablename}%
	 %\addcontentsline{toc}{chapter}{\listtablename}%
      \@mkboth{\MakeUppercase\listtablename}%
              {\MakeUppercase\listtablename}%
	 \normalbaselines
	 \@starttoc{lot}%
}
\renewcommand*\l@table{{\protect\addvspace{\@SimSpace}}\@dottedtocline{1}{1.5em}{2.3em}}


%------------------------------------------------------------------------
% Bibliography
%------------------------------------------------------------------------
% You guessed it, single spacing
\renewenvironment{thebibliography}[1]{%
		\phantomsection
    	\addcontentsline{toc}{chapter}{\bibname}
		\normalbaselines % hello!
		\chapter*{\bibname}%
      \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
			  \addtolength{\itemsep}{0.5\@SimSpace} % 'double-spacing'
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m
}


%-----------------------------------------------------------------------
% Footnote formatting
%-----------------------------------------------------------------------
\renewcommand\@makefntext[1]{%
   \vspace{.7em}
    \parindent 1em%
    \noindent
	 \hb@xt@1em{\hss\@makefnmark} \normalbaselines #1}
% Footnote spacing -- looser spacing looks better with double-spaced text
\setlength{\footnotesep}{ 14pt}
\skip\footins 8pt plus 2pt minus 4pt  % Space between last line of body text 
	                                   % and first line of footnote


%-----------------------------------------------------------------------
% Introduction
%-----------------------------------------------------------------------
\newcommand\introduction{%
	\if@MS
	\ClassWarning{inithesis}{No introduction for MS thesis.}
	\fi
		\@frontmatterfalse
		\pagenumbering{arabic}
		\nmchapter{Introduction}
}

%-----------------------------------------------------------------------
% Dedication
%-----------------------------------------------------------------------
\newcommand\dedication[1]{%
	\if@MS
	  \ClassWarning{inithesis}{No allowed dedication for MS thesis.}
	\fi
	\newpage
	\null
	\thispagestyle{plain}
	\vspace*{2in}
	#1
	\newpage
}


%-----------------------------------------------------------------------
% Acknowledgements
%-----------------------------------------------------------------------
\newcommand\acknowledgements{%
	{\LARGE \nmchapter{\ackname}}
}


%-----------------------------------------------------------------------
% Abstract -- just another non-mainmatter chapter
%-----------------------------------------------------------------------
\renewcommand\abstract{%
  	{\LARGE \nmchapter{\abstractname}}
}




%-----------------------------------------------------------------------
% Body text format
%-----------------------------------------------------------------------
\pagestyle{plain}
\@textspace
\raggedbottom % Allow flexibility in text height per page

%----------------------------
% Frontmatter proccessing hack --
% Set page numbering to roman.  @frontmatter
% trips to false when the first numbered (non-starred) chapter is included.
%----------------------------
\@frontmattertrue
\pagenumbering{roman}


\endinput
