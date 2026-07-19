\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/07/19 Resume class]

\LoadClass[11pt]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage[a4paper, left=1cm, right=1cm, top=1cm, bottom=1cm,
footskip=0cm]{geometry}
\RequirePackage[english]{babel}
\RequirePackage{helvet}
\renewcommand{\familydefault}{\sfdefault}
\RequirePackage{fancyhdr}
\RequirePackage{parskip}
\RequirePackage{hyperref}
\RequirePackage{xifthen}
\RequirePackage{titlesec}
\RequirePackage{layout}
\RequirePackage{tabularx}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}
\RequirePackage{blindtext}
\RequirePackage[nopar]{kantlipsum}

\setlist[itemize]{
  leftmargin=1em,
  labelsep=0.5em,
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\setlength{\parskip}{0pt}

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

\newcommand{\setfullname}[2]{%
  \newcommand{\fullname}{#1~#2}%
}

\newcommand{\namesep}{\vspace{0.5em}}
\newcommand{\namefontsize}{14pt}

\newcommand{\displayfullname}{%
  \begin{center}
    {\fontsize{\namefontsize}{\dimexpr1.2\namefontsize}\selectfont\fullname}
  \end{center}
  \namesep
}

\newcommand{\location}[1]{
  \def\mylocation{#1}
}
\newcommand{\tel}[1]{%
  \def\mytel{\href{tel:#1}{#1}}%
}
\newcommand{\email}[1]{%
  \def\myemail{\href{mailto:#1}{#1}}%
}
\newcommand{\github}[1]{%
  \def\mygithub{\href{https://github.com/#1}{github.com/#1}}%
}
\newcommand{\linkedin}[1]{%
  \def\mylinkedin{\href{https://www.linkedin.com/in/#1}{linked.com/in/#1}}%
}

\newcommand{\displaycontactinfo}{%
  \begin{center}
    \ifthenelse{\isundefined{\mylocation}}{}{%
      \mylocation\separator
    }%
    \ifthenelse{\isundefined{\mytel}}{}{%
      \mytel\separator
    }%
    \ifthenelse{\isundefined{\myemail}}{}{%
      \myemail\separator
    }%
    \ifthenelse{\isundefined{\mygithub}}{}{%
      \mygithub\separator
    }%
    \ifthenelse{\isundefined{\mylinkedin}}{}{%
      \mylinkedin
    }%
  \end{center}
}

\newcommand{\displaytopinfo}{%
  \displayfullname
  \displaycontactinfo
  \vspace{1em}
}

\newcommand{\separator}{\ |\ }

\titleformat{\section}       % Customize the \section command
{\bfseries\fontsize{14pt}{14pt}\selectfont\raggedright}
{}{0em}            % No numbering
{}                 % No additional code before the heading
[\titlerule]       % Horizontal line after the heading

\titlespacing*{\section}{0pt}{0pt}{0pt}

\newcommand{\summarysection}[1]{%
  #1
  \vspace{1em}
}

\newcommand{\sectiontitlegap}{0.5em}
\newcommand{\sectionaftergap}{0.75em}
\newcommand{\entrytitlesep}{0.25em}
\newcommand{\entryaftergap}{0.5em}
\newcommand{\skillsrowsep}{0.2em}

\newcommand{\newsection}[2]{%
  \section*{#1}%
  \vspace{\sectiontitlegap}%
  #2%
  \vspace{-\entryaftergap}
  \vspace{\sectionaftergap}%
}

\newcommand{\allskills}{}
\newcommand{\addskill}[2]{
  \appto{\allskills}{
    #1 & #2 \\[\skillsrowsep]
  }
}

\newcommand{\experienceentry}[5]{%
  \begin{tabularx}{\textwidth}{@{}X r@{}}%
    \fontsize{14pt}{14pt}\selectfont\textbf{#1} & #2 \\
    #3 & #4
  \end{tabularx}%
  \par\vspace{-\topsep}\vspace{-\partopsep}%
  \vspace{\entrytitlesep}%
  #5
  \par
  \vspace{\entryaftergap}%
}

\newcommand{\projectentry}[2]{%
  \begin{tabularx}{\textwidth}{@{}X@{}}%
    \fontsize{14pt}{14pt}\selectfont\textbf{#1}
  \end{tabularx}%
  \par\vspace{-\topsep}\vspace{-\partopsep}%
  \vspace{\entrytitlesep}%
  #2
  \par
  \vspace{\entryaftergap}%
}

\newcommand{\educationentry}[5]{%
  \begin{tabularx}{\textwidth}{@{}X r@{}}%
    \fontsize{14pt}{14pt}\selectfont\textbf{#1} & #2 \\
    #3 & #4
  \end{tabularx}%
  \par\vspace{-\topsep}\vspace{-\partopsep}%
  \vspace{\entrytitlesep}%
  #5
  \par
  \vspace{\entryaftergap}%
}

\newcommand{\insertskills}{%
  \begin{tabularx}{\textwidth}{@{}l L{\textwidth}}
    \allskills
  \end{tabularx}
  \vspace{-\skillsrowsep}
}
