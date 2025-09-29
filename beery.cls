% Note: This class is designed ONLY for 'fontscale.tex'.

% LOADING THE CLASS

\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass{beery}{2025-09-28}{0.0.0}{}

\prop_gput:Nnn \g_msg_module_type_prop { beery } { Class }

\msg_new:nnn { beery } { l3kernel }
  {
    The~ beery~ class~ could~ not~ load. \\
    This~ class~ requires~
    L3~ programming~ layer~ version~ 2023-11-01~ or~ newer.
  }
\msg_new:nnn { beery } { luatex }
  {
    The~ beery~ class~ could~ not~ load. \\
    This~ class~ requires~ LuaTeX.
  }

\IfExplAtLeastTF { 2023-11-01 } { } { \msg_critical:nn { beery } { l3kernel } }
\sys_if_engine_luatex:F { \msg_critical:nn { beery } { luatex } }

\LoadClass { article }

% MESSAGES

\msg_new:nnn { beery } { math-mode-invalid }
  { '\iow_char:N \\#1'~ invalid~ in~ math~ mode~ \msg_line_context:. }

\RequirePackage { fontscale }
\fontscalesetup { musical }
\RequirePackage { siunitx }
\sisetup { list-final-separator = { ,~ and~ } , mode = math }
\RequirePackage { mathtools }
\RequirePackage { xcolor }

% FONT SELECTION

\RequirePackage { lmodern }
\RequirePackage { scaletextbullet }
\settextbulletfactor { 0.4 }

% SOME VARIABLES

\fp_const:Nn \c_beery_golden_ratio_fp { 1.6180 3398 8749 8948 }
\tl_const:Nn \c_beery_alphabet_tl { abcdefghijklmnopqrstuvwxyz }
\tl_const:Nn \c_beery_digits_tl { 0123456789 }
\tl_const:Nn \c_beery_pangram_tl
  { The~ quick~ brown~ fox~ jumps~ over~ the~ lazy~ dog. }

\bool_new:N \l__beery_syntax_bool
\bool_new:N \l__beery_arg_bool

\tl_new:N \l__beery_print_key_tl
\tl_new:N \l__beery_print_cs_tl
\tl_new:N \l__beery_print_meta_tl

% Scratch variable
\box_new:N \l__beery_tmp_box

% CUSTOM MACROS

\cs_generate_variant:Nn \tl_replace_all:Nnn { NeV }
\prg_generate_conditional_variant:Nnn \str_if_eq:nn { e } { TF }

\cs_new_protected:Npn \__beery_print_langle: { \ensuremath { \langle } }
\cs_new_protected:Npn \__beery_print_rangle: { \ensuremath { \rangle } }

\cs_new:Npn \alphabet { \c_beery_alphabet_tl }
\cs_new:Npn \digits { \c_beery_digits_tl }
\cs_new:Npn \pangram { \c_beery_pangram_tl }

\NewDocumentCommand \key { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { key } }
      { \__beery_print_key_value:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_key_value:n #1
  {
    \tl_if_in:nnTF {#1} { = }
      { \__beery_print_key_value:w #1 \q_stop }
      { \__beery_print_key:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_key_value:w #1 = #2 \q_stop
  {
    \tl_if_blank:nTF {#1}
      { \__beery_print_value:n {#2} }
      {
        \__beery_print_key:n {#1}
        \__beery_print_key_value_equal:
        \__beery_print_value:n {#2}
      }
  }
\cs_new_protected:Npn \__beery_print_key:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \tl_set:Nn \l__beery_print_key_tl {#1}
      \tl_trim_spaces:N \l__beery_print_key_tl
      \tl_replace_all:Nnn \l__beery_print_key_tl { / }
        { \__beery_print_key_value_slash: }
      \ttfamily
      \l__beery_print_key_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beery_print_key_value_slash: { \slash }
\cs_new_protected:Npn \__beery_print_key_value_equal:
  {
    \bool_if:NTF \l__beery_syntax_bool
      { ~=~ }
      { \ensuremath { \, = \, } \allowbreak }
  }
\cs_new_protected:Npn \__beery_print_value:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \ttfamily
      \tl_trim_spaces:n {#1} \@
    \group_end:
  }

\NewDocumentCommand \choices { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { choices } }
      { \__beery_print_key_value_choices:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_key_value_choices:n #1
  { \clist_use:nn {#1} { \__beery_print_key_value_choices_separator: } }
\cs_new_protected:Npn \__beery_print_key_value_choices_separator:
  { \ensuremath { \, \vert \, } }

\NewDocumentCommand \cs { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { cs } }
      { \__beery_print_cs:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_cs:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \tl_set:Nn \l__beery_print_cs_tl {#1}
      \tl_replace_all:NeV \l__beery_print_cs_tl
        { \char_generate:nn { `_ } { 8 } } \c_underscore_str
      \ttfamily
      \c_backslash_str \l__beery_print_cs_tl \@
    \group_end:
  }

\NewDocumentCommand \meta { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { meta } }
      { \__beery_print_meta:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_meta:n #1
  {
    \group_begin:
      \bool_if:NTF \l__beery_syntax_bool
        { \bool_if:NF \l__beery_arg_bool { ~ } }
        { \bool_if:NF \l__beery_arg_bool { \allowbreak } }
      \tl_set:Nn \l__beery_print_meta_tl {#1}
      \__beery_print_meta_replace_subscript:
      \__beery_print_meta_replace_expr:
      \ttfamily \slshape
      \__beery_print_langle:
      \l__beery_print_meta_tl
      \__beery_print_rangle:
    \group_end:
  }
\cs_new_protected:Npn \__beery_print_meta_replace_subscript:
  {
    \tl_map_inline:nn { {8} {11} {12} {13} }
      {
        \tl_replace_all:Nen \l__beery_print_meta_tl
          { \char_generate:nn { `_ } {##1} }
          { \__beery_print_meta_subscript:n }
      }
  }
\cs_new_protected:Npn \__beery_print_meta_subscript:n #1
  { \ensuremath { \sb {#1} } }
\cs_new_protected:Npn \__beery_print_meta_replace_expr:
  {
    \tl_map_inline:nn
      {
        { { fp~ expr } { floating~ point~ expression } }
        { { int~ expr } { integer~ expression } }
        { { dim~ expr } { dimen~ expression } }
        { { skip~ expr } { skip~ expression } }
        { { muskip~ expr } { muskip~ expression } }
      }
      { \__beery_print_meta_replace_expr:nn ##1 }
  }
\cs_new_protected:Npn \__beery_print_meta_replace_expr:nn #1#2
  {
    \tl_if_in:NnT \l__beery_print_meta_tl {#1}
      {
        \cs_set_protected:Npn \__beery_print_meta_replace_expr:w
          ##1 #1 ##2 \q_stop
          {
            \tl_if_empty:nT {##1}
              {
                \tl_map_break:n
                  { \tl_replace_once:Nnn \l__beery_print_meta_tl {#1} {#2} }
              }
          }
        \exp_after:wN \__beery_print_meta_replace_expr:w
          \l__beery_print_meta_tl \q_stop
      }
  }

\NewDocumentCommand \marg { s >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { marg } }
      {
        \IfBooleanTF #1
          { \__beery_print_m_arg:n {#2} }
          { \__beery_print_m_arg_meta:n {#2} }
      }
  }
\cs_new_protected:Npn \__beery_print_m_arg:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \ttfamily
      \bool_if:NTF \l__beery_syntax_bool { ~ } { \allowbreak }
      \c_left_brace_str #1 \c_right_brace_str
    \group_end:
  }
\cs_new_protected:Npn \__beery_print_m_arg_meta:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \ttfamily
      \bool_if:NTF \l__beery_syntax_bool { ~ } { \allowbreak }
      \c_left_brace_str \__beery_print_meta:n {#1} \c_right_brace_str
    \group_end:
  }

\NewDocumentCommand \oarg { s >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { oarg } }
      {
        \IfBooleanTF #1
          { \__beery_print_o_arg:n {#2} }
          { \__beery_print_o_arg_meta:n {#2} }
      }
  }
\cs_new_protected:Npn \__beery_print_o_arg:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \ttfamily
      \bool_if:NTF \l__beery_syntax_bool { ~ } { \allowbreak }
      [ #1 ]
    \group_end:
  }
\cs_new_protected:Npn \__beery_print_o_arg_meta:n #1
  {
    \group_begin:
      \bool_set_true:N \l__beery_arg_bool
      \ttfamily
      \bool_if:NTF \l__beery_syntax_bool { ~ } { \allowbreak }
      [ \__beery_print_meta:n {#1} ]
    \group_end:
  }

\NewDocumentCommand \sarg { }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { sarg } }
      { \__beery_print_s_arg: }
  }
\cs_new_protected:Npn \__beery_print_s_arg:
  {
    \bool_if:NT \l__beery_syntax_bool { ~ }
    \__beery_print_langle: \texttt {*} \__beery_print_rangle:
  }

\NewDocumentCommand \cls { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { cls } }
      { \__beery_print_cls:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_cls:n #1 { \textsf { #1 \@ } }

\NewDocumentCommand \env { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { env } }
      { \__beery_print_env:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_env:n #1 { \texttt { #1 \@ } }

\NewDocumentCommand \pkg { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { pkg } }
      { \__beery_print_pkg:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_pkg:n #1 { \textsf { #1 \@ } }

\NewDocumentCommand \latin { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { latin } }
      { \__beery_print_latin:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_latin:n #1 { \textit {#1} }

\NewDocumentCommand \honorific { >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { honorific } }
      { \__beery_print_honorific:n {#1} }
  }
\cs_new_protected:Npn \__beery_print_honorific:n #1
  { \group_begin: #1 \@ \group_end: }

\NewDocumentCommand \allcaps { O { 50 } >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { allcaps } }
      { \__beery_text_all_caps:nn {#1} {#2} }
  }
\cs_new_protected:Npn \__beery_text_all_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \text_uppercase:n {#2} } }

\NewDocumentCommand \allsmallcaps { s O { 50 } >{ \TrimSpaces } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { allsmallcaps } }
      {
        \IfBooleanTF #1
          { \__beery_text_lowercase_small_caps:nn {#2} {#3} }
          { \__beery_text_small_caps:nn {#2} {#3} }
      }
  }
\cs_new_protected:Npn \__beery_text_small_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \scshape #2 } }
\cs_new_protected:Npn \__beery_text_lowercase_small_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \scshape \text_lowercase:n {#2} } }
\RenewDocumentCommand \slash { } { / \allowbreak }

% CUSTOM ENVIRONMENTS

\RequirePackage { tcolorbox }
\NewTColorBox { syntax } { }
  {
      size    = minimal
    , left    = 2pt
    , right   = 2pt
    , top     = 2pt
    , bottom  = 2pt
    , colback = black!4!white
    , code    = \__beery_syntax_code:
  }
\cs_new_protected:Npn \__beery_syntax_code:
  {
    \bool_set_true:N \l__beery_syntax_bool
    \ttfamily
    \obeylines
  }
\NewDocumentEnvironment { function } { m }
  {
    \par
    \begin { minipage } [ b ] { \textwidth }
      \setlength \parskip { \medskipamount }
  }
  {
    \end { minipage }
    \par
  }
\NewEnvironmentCopy { variable } { function }

% ENVIRONMENTS

\RequirePackage { multicol }
\RequirePackage { csquotes }

% PAGE STYLE

\hbox_set:Nn \l__beery_tmp_box { \c_beery_alphabet_tl }
\dim_const:Nn \c_beery_alphabet_dim { \box_wd:N \l__beery_tmp_box }
\dim_log:N \c_beery_alphabet_dim

\dim_const:Nn \c_beery_big_dim { \l_fontscale_normalsize_baselineskip_skip }
\dim_const:Nn \c_beery_medium_dim { \c_beery_big_dim / 2 }
\dim_const:Nn \c_beery_small_dim  { \c_beery_big_dim / 4 }
\dim_log:N \c_beery_big_dim
\dim_log:N \c_beery_medium_dim
\dim_log:N \c_beery_small_dim

\skip_const:Nn \c_beery_big_skip
  {
    \c_beery_big_dim
    plus  \dim_eval:n { \c_beery_big_dim / 2 }
    minus \dim_eval:n { \c_beery_big_dim / 3 }
  }
\skip_const:Nn \c_beery_medium_skip { \c_beery_big_skip / 2 }
\skip_const:Nn \c_beery_small_skip  { \c_beery_big_skip / 4 }
\setlength \bigskipamount   { \skip_use:N \c_beery_big_skip    }
\setlength \medskipamount   { \skip_use:N \c_beery_medium_skip }
\setlength \smallskipamount { \skip_use:N \c_beery_small_skip  }
\skip_log:N \c_beery_big_skip
\skip_log:N \c_beery_medium_skip
\skip_log:N \c_beery_small_skip

% \flushbottom
\raggedbottom
\vbadness = 100
% \maxdepth = 0pt

\setlength \topskip { \dim_use:N \l_fontscale_normalsize_size_dim }
\setlength \splittopskip { \topskip }

\RequirePackage { geometry }
\dim_const:Nn \c_beery_textwidth_dim
  { \fp_to_dim:n { \c_e_fp * \dim_to_fp:n { \c_beery_alphabet_dim } } }
\dim_const:Nn \c_beery_textheight_dim
  {
    \fp_to_dim:n
      { \c_beery_golden_ratio_fp * \dim_to_fp:n { \c_beery_textwidth_dim } }
  }
\dim_const:Nn \c_beery_footskip_dim
  { \c_beery_big_dim + \l_fontscale_footnotesize_baselineskip_skip }
\geometry
  {
      a4paper
    , textwidth = \dim_use:N \c_beery_textwidth_dim
    , textheight = \dim_use:N \c_beery_textheight_dim
    , heightrounded
    , centering
    , headheight = \skip_use:N \l_fontscale_footnotesize_baselineskip_skip
    , headsep = \dim_use:N \c_beery_big_dim
    , footskip = \dim_use:N \c_beery_footskip_dim
  }

\RequirePackage { fancyhdr }
\pagestyle { fancy }
\fancyhf { }
\cs_set:Npn \headrulewidth { 0pt }
\fancyfoot [ C ]
  { \footnotesize \thepage \c_space_tl of~ \pageref { LastPage } }

% PARAGRAPH STYLE

% \frenchspacing
\nonfrenchspacing
% \linespread { 1 }
\RequirePackage [ skip = \skip_use:N \c_beery_medium_skip ] { parskip }
\RequirePackage [ raggedrightboxes ] { ragged2e }
\setlength \RaggedRightRightskip { 0pt plus \dim_use:N \c_beery_alphabet_dim }
\setlength \RaggedRightParindent { 0pt }
\setlength \JustifyingParindent { \RaggedRightParindent }
\RaggedRight
% \justifying
\RequirePackage { microtype }
\microtypesetup { protrusion = false , expansion = false }
\pretolerance = -1
\tolerance = 200
\setlength \emergencystretch { 0pt }
\widowpenalty = 10000
\clubpenalty = \widowpenalty
\displaywidowpenalty = \widowpenalty
% hyphenation
\hyphenpenalty = 50
\exhyphenpenalty = \hyphenpenalty

% HEADINGS, TABLE OF CONTENTS

\RequirePackage { titlesec , titletoc }
\setcounter { secnumdepth } { 2 }
\setcounter { tocdepth } { 2 }

\titlespacing* \section % section
  { 0pt } % indent
  {
    \skip_eval:n
      {
        \c_beery_big_dim
        plus  \dim_eval:n { \c_beery_big_dim / 2 * 4 }
        minus \dim_eval:n { \c_beery_big_dim / 3 / 4 }
      }
  } % before
  { \skip_use:N \c_beery_medium_skip } % after
\titlespacing* \subsection
  { 0pt }
  {
    \skip_eval:n
      {
        \dim_eval:n { \c_beery_medium_dim * 4 / 3 }
        plus  \dim_eval:n { \c_beery_medium_dim / 2 * 4 }
        minus \dim_eval:n { \c_beery_medium_dim / 3 / 4 }
      }
  }
  { \skip_use:N \c_beery_medium_skip }
\titlespacing* \subsubsection
  { 0pt }
  {
    \skip_eval:n
      {
        \dim_eval:n { \c_beery_medium_dim * 4 / 3 }
        plus  \dim_eval:n { \c_beery_medium_dim / 2 * 4 }
        minus \dim_eval:n { \c_beery_medium_dim / 3 / 4 }
      }
  }
  { \skip_use:N \c_beery_medium_skip }

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
\titleformat \subsubsection
  [ block ]
  { \raggedright \normalsize \bfseries }
  { \thesubsubsection }
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
    , topsep    = 0pt
    , partopsep = 0pt
    , parsep    = \skip_use:N \c_beery_small_skip
    , itemsep   = 0pt
  }
\setlist [ itemize   , 1 ] { label = \textbullet }
\setlist [ itemize   , 2 ] { label = \scaletextbullets {2} }
\setlist [ itemize   , 3 ] { label = \scaletextbullets {3} }
\setlist [ itemize   , 4 ] { label = \scaletextbullets {4} }
\setlist [ enumerate , 1 ] { label = \arabic* . }
\setlist [ enumerate , 2 ] { label = \theenumi   \arabic* . }
\setlist [ enumerate , 3 ] { label = \theenumii  \arabic* . }
\setlist [ enumerate , 4 ] { label = \theenumiii \arabic* . }

% list headings
% https://tex.stackexchange.com/questions/2644/how-to-prevent-a-page-break-before-an-itemize-list
\NewDocumentCommand \keepnextpar { s }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { keepnextpar } }
      {
        \IfBooleanTF #1
          { \__beery_keep_next_par_if_single_line: }
          { \__beery_keep_next_par: }
      }
  }
\cs_new_protected:Npn \__beery_keep_next_par: { \nobreak \@afterheading }
\cs_new_protected:Npn \__beery_keep_next_par_if_single_line:
  {
    \int_compare:nNnT \prevgraf = 1
      { \nobreak \@afterheading }
  }

\NewDocumentCommand \listheading { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beery } { math-mode-invalid } { listheading } }
      { \__beery_list_heading:n {#1} }
  }
\cs_new_protected:Npn \__beery_list_heading:n #1
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

% VERBATIM

\RequirePackage { fancyvrb }
\hook_gput_code:nnn { begindocument } { beery } { \DefineShortVerb { \| } }

% FOOTNOTES

\RequirePackage [ bottom ] { footmisc }
\cs_set_protected:Npn \footnoterule { }
% \setlength { \skip \footins } { \c_beery_big_skip }
\setlength \footnotesep { \f@linespread \footnotesep }
\coffin_new:N \l__beery_footnote_coffin
\dim_const:Nn \c_beery_footnote_baselineheight_dim
  {
    \f@linespread \l_fontscale_footnotesize_baselineskip_skip
    - \l_fontscale_footnotesize_size_dim
  }
\cs_set_protected:Npn \@makefntext #1
  {
    \vcoffin_set:Nnn \l__beery_footnote_coffin { \textwidth }
      {
        \list { \@thefnmark . }
          {
            \setlength \leftmargin
              {
                \fp_to_dim:n
                  {
                    (
                      1 - \dim_to_fp:n { \l_fontscale_footnotesize_size_dim } /
                      \dim_to_fp:n { \l_fontscale_normalsize_size_dim }
                    )
                    / 2 * \dim_to_fp:n { \textwidth }
                  }
              }
            \setlength \rightmargin { \leftmargin }
            \setlength \labelsep { 0.5em }
            \setlength \topsep { 0pt }
            \setlength \partopsep { 0pt }
          }
        \item #1 \endlist
      }
    \coffin_typeset:Nnnnn \l__beery_footnote_coffin { l } { b } { \c_zero_dim }
      { - \c_beery_footnote_baselineheight_dim }
  }

% REFERENCES

\hook_gput_code:nnn { shipout / lastpage } { beery } { \label { LastPage } }
\RequirePackage { xurl }
\RequirePackage { hyperref }
\hypersetup { bookmarksnumbered , hidelinks , linktoc = page }
\cs_new:Npn \__beery_pdfstring_print_cs:n #1
  { \textbackslash \tl_to_str:e { \tl_trim_spaces:n {#1} } }
\cs_new:Npn \__beery_pdfstring_print_key_value:n #1
  {
    \exp_args:Ne \__beery_pdfstring_print_key_value_aux:n
      { \tl_trim_spaces:n {#1} }
  }
\cs_new:Npn \__beery_pdfstring_print_key_value_aux:n #1
  {
    \str_if_eq:enTF { \tl_head:n {#1} } { = }
      { \tl_to_str:e { \tl_range:nnn {#1} { 2 } { -1 } } }
      { \tl_to_str:n {#1} }
  }
\cs_new:Npn \__beery_pdfstring_meta:n #1
  { < \tl_to_str:e { \tl_trim_spaces:n {#1} } > }
\pdfstringdefDisableCommands
  {
    \cs_set_eq:NN \key  \__beery_pdfstring_print_key_value:n
    \cs_set_eq:NN \cs   \__beery_pdfstring_print_cs:n
    \cs_set_eq:NN \meta \__beery_pdfstring_print_meta:n
    \cs_set_eq:NN \__beery_print_meta:n \__beery_pdfstring_print_meta:n
  }