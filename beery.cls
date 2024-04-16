% Note: This documentclass is designed ONLY for the document 'fontscale-manual'. Compiled using LuaLaTeX.

% The 2023-06-01 LaTeX kernel update added the 'shipout' hook.
\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesExplClass
  {beery}
  {2024-04-15}
  {}
  {}

\RequirePackage { fix-cm }
\LoadClass { article }
\RequirePackage { fontscale }
\RequirePackage [ list-final-separator = { ,~ and~ } ] { siunitx }
\RequirePackage { mathtools }
\RequirePackage [ shortcuts , allowbreakbefore ] { extdash }
\RequirePackage { csquotes }

% CUSTOM MACROS

\NewDocumentCommand \Key { m o o }
  {
    \group_begin:
      \ttfamily
      \bool_case:nF
        {
          {
            \bool_lazy_and_p:nn
              { \tl_if_novalue_p:n {#2} }
              { \tl_if_novalue_p:n {#3} }
          }
          {#1}
          {
            \bool_lazy_and_p:nn
              { ! \tl_if_novalue_p:n {#2} }
              {   \tl_if_novalue_p:n {#3} }
          }
          { #1~ =~ #2 }
          {
            \bool_lazy_and_p:nn
              { ! \tl_if_novalue_p:n {#2} }
              { ! \tl_if_novalue_p:n {#3} }
          }
          { #1~ =~ #2 \hspace* { \fill } \makebox { initial~ =~ #3 } }
        }
        { \errmessage { invalid } }
    \group_end:
  }
\NewDocumentCommand \cmd { m } { \texttt { \token_to_str:N #1 } \@ }
\NewDocumentCommand \cs { m } { \texttt { \token_to_str:c {#1} } \@ }
\NewDocumentCommand \marg { m }
  { \allowbreak \texttt { \c_left_brace_str #1 \c_right_brace_str } }
\NewDocumentCommand \oarg { m } { \allowbreak \texttt { [ #1 ] } }
\NewDocumentCommand \meta { m } { \texttt { \textlangle #1 \textrangle } }
\NewDocumentCommand \cls { m } { \textsf {#1} }
\NewDocumentCommand \env { m } { \texttt {#1} }
\NewDocumentCommand \pkg { m } { \textsf {#1} }
\NewDocumentCommand \filex { m } { \texttt {#1} \@ }
\NewDocumentCommand \latin { m } { \textit {#1} }

% PAGE STYLE

\hbox_set:Nn \l_tmpa_box { abcdefghijklmnopqrstuvwxyz }
\dim_const:Nn \c_beery_alphabet_dim { \box_wd:N \l_tmpa_box }

\dim_const:Nn \c_beery_big_dim
  { \fp_to_dim:n { \l_fontscale_normalsize_size_dim * 10 / 7 } }
\dim_const:Nn \c_beery_medium_dim { \c_beery_big_dim / 2 }
\dim_const:Nn \c_beery_small_dim  { \c_beery_big_dim / 4 }
\skip_const:Nn \c_beery_big_skip
  {
    \c_beery_big_dim
    plus  \dim_eval:n { \c_beery_big_dim / 2 }
    minus \dim_eval:n { \c_beery_big_dim / 3 }
  }
\skip_const:Nn \c_beery_medium_skip { \c_beery_big_skip / 2 }
\skip_const:Nn \c_beery_small_skip  { \c_beery_big_skip / 4 }
\skip_set_eq:NN \bigskipamount   \c_beery_big_skip
\skip_set_eq:NN \medskipamount   \c_beery_medium_skip
\skip_set_eq:NN \smallskipamount \c_beery_small_skip

\flushbottom
\int_set:Nn \vbadness { 100 }

\skip_set:Nn \topskip { \l_fontscale_normalsize_size_dim }
\skip_set_eq:NN \splittopskip \topskip
\RequirePackage
  [
      letterpaper
    , textwidth = \dim_eval:n { \fp_use:N \c_e_fp \c_beery_alphabet_dim }
    , textheight =
        \dim_eval:n { \fp_eval:n { \c_e_fp * 1.6180 } \c_beery_alphabet_dim }
    , heightrounded
    , centering
    , headheight = \l_fontscale_footnotesize_baselineskip_skip
    , headsep = \c_beery_big_dim
    , footskip =
        \dim_eval:n
          { \c_beery_big_dim + \l_fontscale_footnotesize_baselineskip_skip }
  ]
  { geometry }

\RequirePackage { fancyhdr }
\pagestyle { fancy }
\fancyhf { }
\cs_set:Npn \headrulewidth { 0pt }
\fancyfoot [ C ]
  { \footnotesize \thepage \c_space_tl of~ \pageref { LastPage } }

% PARAGRAPH STYLE

\nonfrenchspacing
\linespread { \fp_eval:n { 25 / 21 } }
\RequirePackage [ skip = \c_beery_medium_skip ] { parskip }
\RequirePackage [ raggedrightboxes ] { ragged2e }
\skip_set:Nn \RaggedRightRightskip { 0pt plus 0.5 \linewidth }
\RaggedRight
\int_set:Nn \widowpenalty { 10000 }
\int_set_eq:NN \clubpenalty \widowpenalty
\int_set_eq:NN \displaywidowpenalty \widowpenalty

% HEADINGS, TABLE OF CONTENTS

\RequirePackage { titlesec , titletoc }
\setcounter { secnumdepth } { 2 }
\setcounter { tocdepth } { 2 }

\titlespacing* \section % section
  { 0pt } % indent
  {
    \fp_eval:n { 4 / 3 } \c_beery_medium_dim
    plus  \fp_eval:n { 1 / 2 * 4 } \c_beery_medium_dim
    minus \fp_eval:n { 1 / 3 / 4 } \c_beery_medium_dim
  } % before
  { \c_beery_medium_skip } % after
\titlespacing* \subsection
  { 0pt }
  {
    \fp_eval:n { 4 / 3 } \c_beery_medium_dim
    plus  \fp_eval:n { 1 / 2 * 4 } \c_beery_medium_dim
    minus \fp_eval:n { 1 / 3 / 4 } \c_beery_medium_dim
  }
  { \c_beery_medium_skip }

\titleformat \section % section
  [ block ] % shape
  { \raggedright \large \bfseries } % format
  { \thesection . } % label
  { 0.5em } % the horizontal separation between label and title body
  { } % before code
  { } % after code
\titleformat \subsection
  [ block ]
  { \raggedright \normalsize \bfseries }
  { \thesubsection . }
  { 0.5em }
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
    , topsep    = 0pt
    , partopsep = 0pt
    , parsep    = \c_beery_small_skip
    , itemsep   = 0pt
  }
\setlist [ itemize   , 1 ] { label = \textbullet }
\setlist [ enumerate , 1 ] { label = \arabic* . }

% list headings
% https://tex.stackexchange.com/questions/2644/how-to-prevent-a-page-break-before-an-itemize-list
\NewDocumentCommand \KeepNextPar { s }
  {
    \par
    \bool_if:NTF #1
      { \int_compare:nNnT { \prevgraf } = { 1 } { \nobreak \@afterheading } }
      { \nobreak \@afterheading }
  }
\NewDocumentCommand \listheading { m }
  {
    \par
    #1
    \par
    \int_compare:nNnT { \prevgraf } = { 1 } { \nobreak \@afterheading }
    \vspace { \skip_eval:n { \c_beery_small_skip - \parskip } }
  }

% TABLES

\renewcommand \bottomfraction { 1 }
\renewcommand \topfraction { 1 }
\skip_set:Nn \textfloatsep
  {
    \c_beery_big_dim plus \c_beery_big_dim minus
    \dim_eval:n { \c_beery_big_dim / 3 }
  }

\RequirePackage { tabularray }
\UseTblrLibrary { booktabs , siunitx }

% FOOTNOTES

\RequirePackage [ bottom ] { footmisc }
\renewcommand \footnoterule { }
\setlength { \skip \footins } { \c_beery_big_skip }
\dim_set:Nn \footnotesep { \f@linespread \footnotesep }
\coffin_new:N \l__beery_footnote_coffin
% 1.2 = baselineskip-size-ratio
\dim_const:Nn \c_beery_footnote_baselineheight_dim
  { \fp_eval:n { 1.2 * \f@linespread - 1 } \l_fontscale_footnotesize_size_dim }
\RenewDocumentCommand \@makefntext { +m }
  {
    \vcoffin_set:Nnn \l__beery_footnote_coffin { \textwidth }
      {
        \list { \@thefnmark . }
          {
            \dim_set:Nn \leftmargin
              {
                \fp_eval:n { ( 1 - \l_fontscale_footnotesize_scale_fp ) / 2 }
                \textwidth
              }
            \dim_set_eq:NN \rightmargin \leftmargin
            \dim_set:Nn \labelsep { 0.5em }
            \skip_zero:N \topsep
            \skip_zero:N \partopsep
          }
        \item #1 \endlist
      }
    \coffin_typeset:Nnnnn \l__beery_footnote_coffin { l } { b }
      { 0pt } { - \c_beery_footnote_baselineheight_dim }
  }

% REFERENCES

\AddToHook { shipout / lastpage } { \label { LastPage } }
\RequirePackage { xurl }
\RequirePackage [ bookmarksnumbered , hidelinks , linktoc = page ] { hyperref }