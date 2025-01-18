% Note: This class is designed ONLY for 'fontscale.tex'. Compiled with LuaTeX.

% LaTeX2e version 2023-11-01 added \IfExplAtLeastTF.
\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass
  {beery}
  {2025-01-17}
  {}
  {}

\LoadClass { article }

\RequirePackage { fontscale }
\fontscalesetup { musical }
\RequirePackage { siunitx }
\sisetup { list-final-separator = { ,~ and~ } , mode = match }
\RequirePackage { mathtools }
\RequirePackage [ shortcuts , allowbreakbefore ] { extdash }
\RequirePackage { csquotes }
\RequirePackage { lmodern }
\RequirePackage { scaletextbullet }

\RequirePackage { tcolorbox }
\tcbuselibrary { breakable }
\NewTColorBox { mydisplaycode } { }
  {
      size   = minimal
    , left   = 2pt
    , right  = 2pt
    , top    = 2pt
    , bottom = 2pt
    , breakable
  }

% CUSTOM MACROS

\tl_const:Nn \c_beery_alphabet_tl { abcdefghijklmnopqrstuvwxyz }
\NewExpandableDocumentCommand \alphabet { } { \c_beery_alphabet_tl }
\NewDocumentCommand \Key
  { >{ \TrimSpaces } m >{ \TrimSpaces } o >{ \TrimSpaces } o }
  {
    \mode_leave_vertical:
    \group_begin:
      \ttfamily
      \IfNoValueTF {#3}
        {
          \IfNoValueTF {#2}
            {#1}
            { #1 $\,=\,$ \allowbreak #2 }
        }
        { #1 $\,=\,$ #2 \hspace* { \fill } \hbox:n { initial $\,=\,$ #3 } }
    \group_end:
  }
\NewDocumentCommand \Value { >{ \TrimSpaces } m } { \texttt {#1} \@ }
\NewDocumentCommand \cmd { >{ \TrimSpaces } m }
  { \texttt { \token_to_str:N #1 } \@ }
\NewDocumentCommand \cs { >{ \TrimSpaces } m }
  { \texttt { \token_to_str:c {#1} } \@ }
\NewDocumentCommand \marg { >{ \TrimSpaces } m }
  {
    \allowbreak
    \texttt { \c_left_brace_str }
    $\langle$
    \group_begin:
      \normalfont \itshape #1
    \group_end:
    $\rangle$
    \texttt { \c_right_brace_str }
  }
\NewDocumentCommand \oarg { >{ \TrimSpaces } m }
  {
    \allowbreak
    \texttt { [ }
    $\langle$
    \group_begin:
      \normalfont \itshape #1
    \group_end:
    $\rangle$
    \texttt { ] }
  }
\NewDocumentCommand \sarg { } { $\langle$ \texttt {*} $\rangle$ }
\NewDocumentCommand \meta { >{ \TrimSpaces } m }
  {
    $\langle$
    \group_begin:
      \normalfont \itshape #1
    \group_end:
    $\rangle$
  }
\NewDocumentCommand \cls { >{ \TrimSpaces } m } { \textsf {#1} \@ }
\NewDocumentCommand \env { >{ \TrimSpaces } m } { \texttt {#1} \@ }
\NewDocumentCommand \pkg { >{ \TrimSpaces } m } { \textsf {#1} \@ }
\NewDocumentCommand \latin { >{ \TrimSpaces } m } { \textit {#1} }

% PAGE STYLE

\hbox_set:Nn \l_tmpa_box { \c_beery_alphabet_tl }
\dim_const:Nn \c_beery_alphabet_dim { \box_wd:N \l_tmpa_box }
\dim_log:N \c_beery_alphabet_dim

\dim_const:Nn \c_beery_big_dim { \l_fontscale_normalsize_baselineskip_skip }
\dim_const:Nn \c_beery_medium_dim
  { \fp_to_dim:n { \dim_to_fp:n { \c_beery_big_dim / 2 } } }
\dim_const:Nn \c_beery_small_dim
  { \fp_to_dim:n { \dim_to_fp:n { \c_beery_big_dim / 4 } } }
\dim_log:N \c_beery_big_dim
\dim_log:N \c_beery_medium_dim
\dim_log:N \c_beery_small_dim

\skip_const:Nn \c_beery_big_skip
  {
    \c_beery_big_dim
    plus  \fp_to_dim:n { \dim_to_fp:n { \c_beery_big_dim } / 2 }
    minus \fp_to_dim:n { \dim_to_fp:n { \c_beery_big_dim } / 3 }
  }
\skip_const:Nn \c_beery_medium_skip { \c_beery_big_skip / 2 }
\skip_const:Nn \c_beery_small_skip  { \c_beery_big_skip / 4 }
\skip_set_eq:NN \bigskipamount   \c_beery_big_skip
\skip_set_eq:NN \medskipamount   \c_beery_medium_skip
\skip_set_eq:NN \smallskipamount \c_beery_small_skip
\skip_log:N \c_beery_big_skip
\skip_log:N \c_beery_medium_skip
\skip_log:N \c_beery_small_skip

\raggedbottom
\int_set:Nn \vbadness { 100 }

\skip_set:Nn \topskip { \l_fontscale_normalsize_size_dim }
\skip_set_eq:NN \splittopskip \topskip
\RequirePackage { geometry }
\dim_const:Nn \c_beery_textwidth_dim
  { \fp_to_dim:n { \c_e_fp * \dim_to_fp:n { \c_beery_alphabet_dim } } }
\dim_const:Nn \c_beery_textheight_dim
  { \fp_to_dim:n { 1.6180 * \dim_to_fp:n { \c_beery_textwidth_dim } } }
\dim_const:Nn \c_beery_footskip_dim
  { \c_beery_big_dim + \l_fontscale_footnotesize_baselineskip_skip }
\geometry
  {
      a4paper
    , textwidth = \c_beery_textwidth_dim
    , textheight = \c_beery_textheight_dim
    , heightrounded
    , centering
    , headheight = \l_fontscale_footnotesize_baselineskip_skip
    , headsep = \c_beery_big_dim
    , footskip = \c_beery_footskip_dim
  }

\RequirePackage { fancyhdr }
\pagestyle { fancy }
\fancyhf { }
\renewcommand \headrulewidth { 0pt }
\fancyfoot [ C ]
  { \footnotesize \thepage \c_space_tl of~ \pageref { LastPage } }

% PARAGRAPH STYLE

\nonfrenchspacing
\linespread { 1 }
\RequirePackage [ skip = \c_beery_medium_skip ] { parskip }
\RequirePackage [ raggedrightboxes ] { ragged2e }
\skip_set:Nn \RaggedRightRightskip { \c_zero_dim plus \c_beery_alphabet_dim }
\dim_zero:N \RaggedRightParindent
\dim_set_eq:NN \JustifyingParindent \RaggedRightParindent
\RaggedRight
% \justifying
\int_set:Nn \pretolerance { -1 }
\int_set:Nn \tolerance { 200 }
\dim_zero:N \emergencystretch
\int_set:Nn \widowpenalty { 10000 }
\int_set_eq:NN \clubpenalty \widowpenalty
\int_set_eq:NN \displaywidowpenalty \widowpenalty
% hyphenation
\int_set:Nn \hyphenpenalty { 99 }
\int_set_eq:NN \exhyphenpenalty \hyphenpenalty

% HEADINGS, TABLE OF CONTENTS

\RequirePackage { titlesec , titletoc }
\setcounter { secnumdepth } { 2 }
\setcounter { tocdepth } { 2 }

\titlespacing* \section % section
  { \c_zero_dim } % indent
  {
    \c_beery_big_dim
    plus  \fp_to_dim:n { 1 / 2 * 4 * \dim_to_fp:n { \c_beery_big_dim } }
    minus \fp_to_dim:n { 1 / 3 / 4 * \dim_to_fp:n { \c_beery_big_dim } }
  } % before
  { \c_beery_medium_skip } % after
\titlespacing* \subsection
  { \c_zero_dim }
  {
    \fp_to_dim:n { 4 / 3 * \dim_to_fp:n { \c_beery_medium_dim } }
    plus  \fp_to_dim:n { 1 / 2 * 4 * \dim_to_fp:n { \c_beery_medium_dim } }
    minus \fp_to_dim:n { 1 / 3 / 4 * \dim_to_fp:n { \c_beery_medium_dim } }
  }
  { \c_beery_medium_skip }

\titleformat \section % section
  [ block ] % shape
  { \raggedright \large \bfseries } % format
  { \thesection } % label
  { 1em } % the horizontal separation between label and title body
  { } % before code
  { } % after code
\titleformat \subsection
  [ block ]
  { \raggedright \normalsize \bfseries }
  { \thesubsection }
  { 1em }
  { }
  { }

% LISTS, LIST HEADINGS

\RequirePackage { enumitem }
\setlist
  {
      % horizontal spacing
      leftmargin = *
    , labelsep  = 0.5em
      % vertical spacing
    , topsep    = \c_zero_skip
    , partopsep = \c_zero_skip
    , parsep    = \c_beery_small_skip
    , itemsep   = \c_zero_skip
  }
\setlist [ itemize   , 1 ] { label = \textbullet }
\setlist [ itemize   , 2 ] { label = \ScaleTextBullets { 2 } }
\setlist [ itemize   , 3 ] { label = \ScaleTextBullets { 3 } }
\setlist [ itemize   , 4 ] { label = \ScaleTextBullets { 4 } }
\setlist [ enumerate , 1 ] { label = \arabic* . }
\setlist [ enumerate , 2 ] { label = \theenumi   \arabic* . }
\setlist [ enumerate , 3 ] { label = \theenumii  \arabic* . }
\setlist [ enumerate , 4 ] { label = \theenumiii \arabic* . }

% list headings
% https://tex.stackexchange.com/questions/2644/how-to-prevent-a-page-break-before-an-itemize-list
\NewDocumentCommand \KeepNextPar { s }
  {
    \par
    \IfBooleanTF #1
      {
        \int_compare:nNnT \prevgraf = 1
          { \nobreak \@afterheading }
      }
      { \nobreak \@afterheading }
  }
\NewDocumentCommand \listheading { m }
  {
    \par
    #1
    \par
    \int_compare:nNnT \prevgraf = 1
      { \nobreak \@afterheading }
    \vspace { \skip_eval:n { \c_beery_small_skip - \parskip } }
  }

% TABLES

\RequirePackage { tabularray }
\UseTblrLibrary { booktabs , siunitx }

% FOOTNOTES

\RequirePackage [ bottom ] { footmisc }
\renewcommand \footnoterule { }
% \setlength { \skip \footins } { \c_beery_big_skip }
\dim_set:Nn \footnotesep { \f@linespread \footnotesep }
\coffin_new:N \l__beery_footnote_coffin
% 1.2 = baselineskip-size-ratio
% \f@linespread must not be empty here
\dim_const:Nn \c_beery_footnote_baselineheight_dim
  {
    \fp_to_dim:n
      {
        ( 1.2 * \f@linespread - 1 )
        * \dim_to_fp:n { \l_fontscale_footnotesize_size_dim }
      }
  }
\RenewDocumentCommand \@makefntext { +m }
  {
    \vcoffin_set:Nnn \l__beery_footnote_coffin { \textwidth }
      {
        \list { \@thefnmark . }
          {
            \dim_set:Nn \leftmargin
              {
                \fp_to_dim:n
                  {
                    ( 1 - \l_fontscale_footnotesize_scale_fp ) / 2
                    * \dim_to_fp:n { \textwidth }
                  }
              }
            \dim_set_eq:NN \rightmargin \leftmargin
            \dim_set:Nn \labelsep { 0.5em }
            \skip_zero:N \topsep
            \skip_zero:N \partopsep
          }
        \item #1 \endlist
      }
    \coffin_typeset:Nnnnn \l__beery_footnote_coffin { l } { b }
      { \c_zero_dim } { - \c_beery_footnote_baselineheight_dim }
  }

% REFERENCES

\AddToHook { shipout / lastpage } { \label { LastPage } }
\RequirePackage { xurl }
\RequirePackage { hyperref }
\hypersetup { bookmarksnumbered , hidelinks , linktoc = page }