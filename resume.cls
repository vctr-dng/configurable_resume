\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2026/07/19 Resume class]

\RequirePackage{kvoptions}

\SetupKeyvalOptions{family=resume,prefix=resume@}
\DeclareStringOption[11pt]{fontsize}
\DeclareStringOption[a4paper]{paper}
\DeclareStringOption[1cm]{margin}
\DeclareStringOption[]{leftmargin}
\DeclareStringOption[]{rightmargin}
\DeclareStringOption[]{topmargin}
\DeclareStringOption[]{bottommargin}
\DeclareStringOption[0.25cm]{footskip}
\DeclareVoidOption{10pt}{\def\resume@fontsize{10pt}}
\DeclareVoidOption{11pt}{\def\resume@fontsize{11pt}}
\DeclareVoidOption{12pt}{\def\resume@fontsize{12pt}}
\DeclareVoidOption{a4paper}{\def\resume@paper{a4paper}}
\DeclareVoidOption{letterpaper}{\def\resume@paper{letterpaper}}
\ProcessKeyvalOptions*

\ifx\resume@leftmargin\@empty\let\resume@leftmargin\resume@margin\fi
\ifx\resume@rightmargin\@empty\let\resume@rightmargin\resume@margin\fi
\ifx\resume@topmargin\@empty\let\resume@topmargin\resume@margin\fi
\ifx\resume@bottommargin\@empty\let\resume@bottommargin\resume@margin\fi

\LoadClass[\resume@fontsize,\resume@paper]{article}

\RequirePackage[T1]{fontenc}
\RequirePackage[\resume@paper, left=\resume@leftmargin,
  right=\resume@rightmargin, top=\resume@topmargin, bottom=\resume@bottommargin,
footskip=\resume@footskip]{geometry}
\RequirePackage[english]{babel}
\RequirePackage{helvet}
\renewcommand{\familydefault}{\sfdefault}
\RequirePackage{fancyhdr}
\RequirePackage{parskip}
\RequirePackage{hyperref}
\urlstyle{same}
\RequirePackage{xparse}
\RequirePackage{xifthen}
\RequirePackage{titlesec}
\RequirePackage{layout}
\RequirePackage{tabularx}
\RequirePackage{etoolbox}
\RequirePackage{enumitem}

\input{resume-default-config.tex}

\AtBeginDocument{%
  \setlength{\parskip}{\resumeparskip}%
  \setlist[itemize]{%
    leftmargin=\bulletleftmargin,
    labelsep=\bulletlabelsep,
    topsep=\bullettopsep,
    partopsep=\bulletpartopsep,
    itemsep=\bulletitemsep,
    parsep=\bulletparsep,
  }%
  \titleformat{\section}%
  {\bfseries\fontsize{\sectionfontsize}{\sectionbaselineskip}\selectfont\raggedright}%
  {}{\sectionlabelsep}%
  {}%
  [\titlerule]%
  \titlespacing*{\section}{\sectionleftskip}{\sectionbeforeskip}{\sectionafterskip}%
}

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}

\newcolumntype{L}[1]{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

\NewDocumentCommand{\setfullname}{m m}{%
  \def\fullname{#1~#2}%
}

\NewDocumentCommand{\displayfullname}{}{%
  \begin{center}
    {\fontsize{\namefontsize}{\namebaselineskip}\selectfont\fullname}
  \end{center}
  \vspace{\namesep}
}

% Each contact item is stored in its own slot so that \displaycontactinfo can
% emit them in a fixed order, independent of the order the user calls the
% commands below. The display order is:
%   Location, Telephone, Email, Github, Website, Linkedin
\newcounter{resume@contactcount}
\newcommand{\resume@setcontact}[2]{%
  \csgdef{resume@contact@#1}{#2}%
}

\NewDocumentCommand{\location}{m}{%
  \resume@setcontact{location}{#1}%
}
\ExplSyntaxOn
\tl_new:N \l_resume_tel_target_tl
\cs_new_protected:Npn \resume_add_tel:nn #1#2
{
  \tl_set:Nn \l_resume_tel_target_tl {#1}
  \tl_if_blank:VTF \l_resume_tel_target_tl
  { \tl_set:Nn \l_resume_tel_target_tl {#2} }
  { }
  \tl_remove_all:Nn \l_resume_tel_target_tl { ~ }
  \resume@setcontact{tel}{\href{tel:\tl_use:N \l_resume_tel_target_tl}{#2}}
}
\NewDocumentCommand{\tel}{O{} m}{%
  \resume_add_tel:nn {#1} {#2}%
}
\ExplSyntaxOff
\NewDocumentCommand{\email}{m}{%
  \resume@setcontact{email}{\href{mailto:#1}{\nolinkurl{#1}}}%
}
\NewDocumentCommand{\github}{m}{%
  \resume@setcontact{github}{\href{https://github.com/#1}{\nolinkurl{github.com/#1}}}%
}
\NewDocumentCommand{\linkedin}{m}{%
  \resume@setcontact{linkedin}{\href{https://www.linkedin.com/in/#1}{\nolinkurl{linkedin.com/in/#1}}}%
}
\NewDocumentCommand{\website}{O{} m}{%
  \ifblank{#1}{%
    \resume@setcontact{website}{\href{#2}{\nolinkurl{#2}}}%
  }{%
    \resume@setcontact{website}{\href{#2}{#1}}%
  }%
}

% Fixed display order for contact items, independent of call order.
\newcommand{\resume@emitcontact}[1]{%
  \ifcsdef{resume@contact@#1}{%
    \ifnum\value{resume@contactcount}>0\separator\fi
    \csuse{resume@contact@#1}%
    \stepcounter{resume@contactcount}%
  }{}%
}

\NewDocumentCommand{\displaycontactinfo}{}{%
  \begin{center}
    \setcounter{resume@contactcount}{0}%
    \forcsvlist{\resume@emitcontact}{location,tel,email,github,website,linkedin}%
  \end{center}
}

\NewDocumentCommand{\displaytopinfo}{}{%
  \displayfullname
  \displaycontactinfo
  \vspace{\topinfoaftergap}
}

\NewDocumentCommand{\summarysection}{+m}{%
  #1
  \vspace{\summaryaftergap}
}

\NewDocumentCommand{\resumesection}{m +m}{%
  \section*{#1}%
  \vspace{\sectiontitlegap}%
  #2%
  \vspace{-\entryaftergap}
  \vspace{\sectionaftergap}%
}

\newcommand{\allskills}{}
\NewDocumentCommand{\skillsentry}{m m}{%
  \appto{\allskills}{
    #1 & #2 \\[\skillsrowsep]
  }
}

\NewDocumentCommand{\experienceentry}{m m m m +m}{%
  \begin{tabularx}{\textwidth}{@{}X r@{}}%
    \fontsize{\entrytitlefontsize}{\entrytitlebaselineskip}\selectfont\textbf{#1}
    & #2 \\
    #3 & #4
  \end{tabularx}%
  \par\vspace{\entrylisttopsepcompensation}\vspace{\entrylistpartopsepcompensation}%
  \vspace{\entrytitlesep}%
  #5
  \par
  \vspace{\entryaftergap}%
}

\NewDocumentCommand{\projectsentry}{m +m}{%
  \begin{tabularx}{\textwidth}{@{}X@{}}%
    \fontsize{\entrytitlefontsize}{\entrytitlebaselineskip}\selectfont\textbf{#1}
  \end{tabularx}%
  \par\vspace{\entrylisttopsepcompensation}\vspace{\entrylistpartopsepcompensation}%
  \vspace{\entrytitlesep}%
  #2
  \par
  \vspace{\entryaftergap}%
}

\NewDocumentCommand{\educationentry}{m m m m +m}{%
  \begin{tabularx}{\textwidth}{@{}X r@{}}%
    \fontsize{\entrytitlefontsize}{\entrytitlebaselineskip}\selectfont\textbf{#1}
    & #2 \\
    #3 & #4
  \end{tabularx}%
  \par\vspace{\entrylisttopsepcompensation}\vspace{\entrylistpartopsepcompensation}%
  \vspace{\entrytitlesep}%
  #5
  \par
  \vspace{\entryaftergap}%
}

\NewDocumentCommand{\insertskills}{}{%
  \begin{tabularx}{\textwidth}{@{}l X@{}}
    \allskills
  \end{tabularx}
  \vspace{-\skillsrowsep}
}
