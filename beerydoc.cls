% Loading the class

\NeedsTeXFormat{LaTeX2e}[2025-11-01]
\ProvidesExplClass{beerydoc}{2025-12-27}{0.0.0}{}
\prop_gput:Nnn \g_msg_module_type_prop { beerydoc } { Class }

\msg_new:nnn { beerydoc } { l3kernel }
  {
    The~ beerydoc~ class~ could~ not~ load. \\
    This~ class~ requires~
    L3~ programming~ layer~ version~ 2024-12-09~ or~ newer.
  }
\msg_new:nnn { beerydoc } { luatex }
  { The~ beerydoc~ class~ could~ not~ load. \\ This~ class~ requires~ LuaTeX. }

\IfExplAtLeastF { 2024-12-09 } { \msg_critical:nn { beerydoc } { l3kernel } }
\sys_if_engine_luatex:F { \msg_critical:nn { beerydoc } { luatex } }

\LoadClass { article }

\keys_define:nn { beerydoc }
  {
      showframe .code:n = { \PassOptionsToPackage { showframe } { geometry } }
    , showframe .value_forbidden:n = true
    , showframe .usage:n = load
  }
\ProcessKeyOptions

\RequirePackage { fontscale }
\fontscalesetup { musical }
\RequirePackage { siunitx }
\sisetup { list-final-separator = { ,~ and~ } , mode = math }
\RequirePackage { mathtools }
\DeclarePairedDelimiter\abs{\lvert}{\rvert}
\cs_set_eq:NN \muskipeval \muskip_eval:n
\RequirePackage { xcolor }

% Font selection

\RequirePackage { lmodern }
\RequirePackage { scaletextbullet }
\settextbulletfactor { 0.4 }

% Some variables

\fp_const:Nn \c_beerydoc_golden_ratio_fp { 1.6180 3398 8749 8948 }
\tl_const:Nn \c_beerydoc_alphabet_tl { abcdefghijklmnopqrstuvwxyz }
\str_const:Nn \c_beerydoc_digits_str { 0123456789 }
\tl_const:Nn \c_beerydoc_pangram_tl
  { The~ quick~ brown~ fox~ jumps~ over~ the~ lazy~ dog. }

\hbox_set:Nn \l_tmpa_box { \c_beerydoc_alphabet_tl }
\dim_const:Nn \c_beerydoc_alphabet_dim { \box_wd:N \l_tmpa_box }

\dim_const:Nn \c_beerydoc_big_dim { \l_fontscale_normalsize_baselineskip_skip }
\dim_const:Nn \c_beerydoc_med_dim   { \c_beerydoc_big_dim / 2 }
\dim_const:Nn \c_beerydoc_small_dim { \c_beerydoc_big_dim / 4 }
\dim_log:N \c_beerydoc_big_dim
\dim_log:N \c_beerydoc_med_dim
\dim_log:N \c_beerydoc_small_dim

\skip_const:Nn \c_beerydoc_big_skip
  {
    \c_beerydoc_big_dim
    plus  \dim_eval:n { \c_beerydoc_big_dim / 2 }
    minus \dim_eval:n { \c_beerydoc_big_dim / 3 }
  }
\skip_const:Nn \c_beerydoc_med_skip   { \c_beerydoc_big_skip / 2 }
\skip_const:Nn \c_beerydoc_small_skip { \c_beerydoc_big_skip / 4 }
\setlength \bigskipamount   { \skip_use:N \c_beerydoc_big_skip   }
\setlength \medskipamount   { \skip_use:N \c_beerydoc_med_skip   }
\setlength \smallskipamount { \skip_use:N \c_beerydoc_small_skip }
\skip_log:N \c_beerydoc_big_skip
\skip_log:N \c_beerydoc_med_skip
\skip_log:N \c_beerydoc_small_skip

\tl_const:Ne \c__beerydoc_math_subscript_tl { \char_generate:nn { `_ } { 8 } }
\group_begin:
  \char_set_catcode_active:N |
  \tl_const:Nn \c__beerydoc_active_vert_tl { | }
  \char_set_active_eq:NN _ \scan_stop:
  \tl_const:Ne \c__beerydoc_active_underscore_tl
    { \char_generate:nn { `_ } { 13 } }
\group_end:

\tl_new:N \l__beerydoc_key_tl
\tl_new:N \l__beerydoc_value_tl
\tl_new:N \l__beerydoc_cs_tl
\tl_new:N \l__beerydoc_meta_tl
\tl_new:N \l__beerydoc_hook_tl

\bool_new:N \l__beerydoc_syntax_bool

% Custom macros

\cs_generate_variant:Nn \tl_replace_once:Nnn { No }
\cs_generate_variant:Nn \tl_replace_all:Nnn { No }
\prg_generate_conditional_variant:Nnn \str_if_eq:nn { ne , e }
  { p , T , F , TF }

\cs_new_protected:Npn \__beerydoc_langle: { \ensuremath { \langle } }
\cs_new_protected:Npn \__beerydoc_rangle: { \ensuremath { \rangle } }

\cs_new:Npe \alphabet { \c_beerydoc_alphabet_tl }
\cs_new:Npe \digits { \c_beerydoc_digits_str }
\cs_new:Npe \pangram { \c_beerydoc_pangram_tl }

\NewDocumentCommand \key { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { key } }
      { \__beerydoc_key_value:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_key_value:n #1
  {
    \tl_if_in:nnTF {#1} { = }
      { \__beerydoc_key_value:w #1 \q_stop }
      { \__beerydoc_key:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_key_value:w #1 = #2 \q_stop
  {
    \tl_if_blank:nTF {#1}
      { \__beerydoc_value:n {#2} }
      {
        \__beerydoc_key:n {#1}
        \__beerydoc_key_value_equal:
        \__beerydoc_value:n {#2}
      }
  }
\cs_new_protected:Npn \__beerydoc_key:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_key_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_key_tl { / } { \__beerydoc_key_slash: }
      \ttfamily
      \l__beerydoc_key_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_key_slash: { / \allowbreak }
\cs_new_protected:Npn \__beerydoc_key_value_equal:
  {
    \bool_if:NTF \l__beerydoc_syntax_bool
      { ~=~ } { \ensuremath { \, = \, } \allowbreak }
  }
\cs_new_protected:Npn \__beerydoc_value:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_value_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_value_tl { ~ } { \textvisiblespace }
      \cs_set_eq:NN \choices \__beerydoc_value_choices:n
      \ttfamily
      \l__beerydoc_value_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_value_choices:n #1
  { \clist_use:nn {#1} { \__beerydoc_value_choices_separator: } }
\cs_new_protected:Npn \__beerydoc_value_choices_separator:
  { \ensuremath { \, \vert \, } }

\NewDocumentCommand \cs { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { cs } }
      { \__beerydoc_cs:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_cs:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_cs_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_cs_tl { ~ } { \textvisiblespace }
      \tl_replace_all:NVn \l__beerydoc_cs_tl \c__beerydoc_active_vert_tl { | }
      \__beerydoc_cs_replace_underscore:
      \__beerydoc_cs_hyphenation:
      \ttfamily
      \c_backslash_str \l__beerydoc_cs_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_cs_replace_underscore:
  {
    \tl_map_inline:nn
      {
        \c__beerydoc_math_subscript_tl
        \c_underscore_str
        \c__beerydoc_active_underscore_tl
      }
      { \tl_replace_all:NVn \l__beerydoc_cs_tl ##1 { _ } }
  }
\cs_new_protected:Npn \__beerydoc_cs_hyphenation:
  {
    \tl_if_in:NnT \l__beerydoc_cs_tl { _ }
      {
        \tl_regex_replace_all:NNn \l__beerydoc_cs_tl
          \c__beerydoc_cs_hyphenation_regex { \1 \c{-} \2 }
      }
  }
\regex_const:Nn \c__beerydoc_cs_hyphenation_regex { ([^\\\_]\_+) ([^\_]) }
\cs_new_protected:Npn \__beerydoc_cs:N #1
  { \exp_args:Ne \__beerydoc_cs:n { \cs_to_str:N #1 } }

\NewDocumentCommand \meta { m } { \__beerydoc_meta:n {#1} }
\cs_new_protected:Npn \__beerydoc_meta:n #1
  { \mode_if_math:TF { \text } { \use:n } { \__beerydoc_meta_aux:n {#1} } }
\cs_new_protected:Npn \__beerydoc_meta_aux:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_meta_tl {#1}
      \__beerydoc_meta_replace_underscore:
      \__beerydoc_meta_replace_expr:
      \ttfamily \slshape
      \__beerydoc_langle:
      \l__beerydoc_meta_tl
      \__beerydoc_rangle:
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_meta_replace_underscore:
  {
    \tl_map_inline:nn
      {
        \c__beerydoc_math_subscript_tl
        _
        \c_underscore_str
        \c__beerydoc_active_underscore_tl
      }
      {
        \tl_replace_all:Non \l__beerydoc_meta_tl {##1}
          { \__beerydoc_meta_subscript:n }
      }
  }
\cs_new_protected:Npn \__beerydoc_meta_subscript:n #1
  { \ensuremath { \sb {#1} } }
\cs_new_protected:Npn \__beerydoc_meta_replace_expr:
  {
    \tl_if_in:NnT \l__beerydoc_meta_tl { expr }
      {
        \tl_replace_once:Non \l__beerydoc_meta_tl
          { \c_catcode_active_space_tl expr } { ~expr }
        \__beerydoc_meta_replace_expr:nn
          { fp~ expr } { floating~ point~ expression }
          { int~ expr } { integer~ expression }
          { dim~ expr } { dimen~ expression }
          { skip~ expr } { skip~ expression }
          { muskip~ expr } { muskip~ expression }
          { \q_recursion_tail } { }
        \q_recursion_stop
      }
  }
\cs_new_protected:Npn \__beerydoc_meta_replace_expr:nn #1#2
  {
    \quark_if_recursion_tail_stop:n {#1}
    \tl_if_in:NnT \l__beerydoc_meta_tl {#1}
      {
        \cs_set_protected:Npn \__beerydoc_meta_replace_expr:w
          ##1 #1 ##2 \q_stop
          {
            \tl_if_empty:nT {##1}
              {
                \use_i_delimit_by_q_recursion_stop:nw
                  { \tl_set:Nn \l__beerydoc_meta_tl { #2 ##2 } }
              }
          }
        \exp_after:wN \__beerydoc_meta_replace_expr:w \l__beerydoc_meta_tl
          \q_stop
      }
    \__beerydoc_meta_replace_expr:nn
  }

\NewDocumentCommand \marg { s m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { marg } }
      {
        \IfBooleanTF #1
          { \__beerydoc_m_arg:n {#2} }
          { \__beerydoc_m_arg_meta:n {#2} }
      }
  }
\cs_set_protected:Npn \__beerydoc_tmp:Nn #1#2
  {
    \cs_new_protected:Npn #1 ##1
      {
        \group_begin:
          \ttfamily
          \c_left_brace_str #2 \c_right_brace_str
        \group_end:
      }
  }
\__beerydoc_tmp:Nn \__beerydoc_m_arg:n {#1}
\__beerydoc_tmp:Nn \__beerydoc_m_arg_meta:n { \meta {#1} }

\NewDocumentCommand \oarg { s m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { oarg } }
      {
        \IfBooleanTF #1
          { \__beerydoc_o_arg:n {#2} }
          { \__beerydoc_o_arg_meta:n {#2} }
      }
  }
\cs_set_protected:Npn \__beerydoc_tmp:Nn #1#2
  {
    \cs_new_protected:Npn #1 ##1
      {
        \group_begin:
          \ttfamily
          [ #2 ]
        \group_end:
      }
  }
\__beerydoc_tmp:Nn \__beerydoc_o_arg:n {#1}
\__beerydoc_tmp:Nn \__beerydoc_o_arg_meta:n { \meta {#1} }

\NewDocumentCommand \sarg { }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { sarg } }
      { \__beerydoc_s_arg: }
  }
\cs_new_protected:Npn \__beerydoc_s_arg:
  { \__beerydoc_langle: \texttt {*} \__beerydoc_rangle: }

\cs_set_protected:Npn \__beerydoc_tmp:nN #1#2
  {
    \quark_if_recursion_tail_stop:n {#1}
    \use:e
      {
        \NewDocumentCommand \exp_not:c {#1} { m }
          {
            \exp_not:N \mode_if_math:TF
              { \msg_error:nnn { beerydoc } { math-mode-invalid } {#1} }
              { \exp_not:c { __beerydoc_#1:n } {##1} }
          }
      }
    \cs_new_protected:cpn { __beerydoc_#1:n } ##1
      { \group_begin: #2 ##1 \@ \group_end: }
    \__beerydoc_tmp:nN
  }
\__beerydoc_tmp:nN
  {cls}    \sffamily
  {pkg}    \sffamily
  {env}    \ttfamily
  {socket} \ttfamily
  {plug}   \ttfamily
  { \q_recursion_tail } \scan_stop:
\q_recursion_stop

\NewDocumentCommand \hook { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { hook } }
      { \__beerydoc_hook:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_hook:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_hook_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_hook_tl { / }
        { \__beerydoc_hook_slash: }
      \ttfamily
      \l__beerydoc_hook_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_hook_slash: { / \allowbreak }

\NewDocumentCommand \latin { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { latin } }
      { \__beerydoc_latin:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_latin:n #1
  { \group_begin: \ttfamily #1 \group_end: }

\NewDocumentCommand \honorific { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { honorific } }
      { \__beerydoc_honorific:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_honorific:n #1
  { \group_begin: #1 \@ \group_end: }

\NewDocumentCommand \allcaps { O { 50 } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { allcaps } }
      { \__beerydoc_text_all_caps:nn {#1} {#2} }
  }
\cs_new_protected:Npn \__beerydoc_text_all_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \text_uppercase:n {#2} } }

\NewDocumentCommand \allsmallcaps { s O { 50 } m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { allsmallcaps } }
      {
        \IfBooleanTF #1
          { \__beerydoc_text_lowercase_small_caps:nn {#2} {#3} }
          { \__beerydoc_text_small_caps:nn {#2} {#3} }
      }
  }
\cs_new_protected:Npn \__beerydoc_text_small_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \scshape #2 } }
\cs_new_protected:Npn \__beerydoc_text_lowercase_small_caps:nn #1#2
  { \textls [ \int_eval:n {#1} ] { \scshape \text_lowercase:n {#2} } }

\RenewDocumentCommand \slash { } { / \allowbreak }

% Custom environments

\RequirePackage { tcolorbox }
\NewTColorBox { syntax } { }
  {
      size    = minimal
    , left    = 2pt
    , right   = 2pt
    , top     = 2pt
    , bottom  = 2pt
    , colback = black!5!white
    , code    = \__beerydoc_syntax_code:
  }
\cs_new_protected:Npn \__beerydoc_syntax_code:
  {
    \bool_set_true:N \l__beerydoc_syntax_bool
    \ttfamily
    \raggedright
    % \obeyspaces
    \obeylines
  }
\hook_gput_code:nnn { env/syntax/after } { beerydoc }
  { \noindent \ignorespaces }
\NewDocumentEnvironment { function } { m }
  {
    \noindent
    \begin { minipage } [ b ] { \textwidth }
      \setlength \parskip { \medskipamount }
  }
  { \end { minipage } }
\NewEnvironmentCopy { variable } { function }
\cs_new_protected:Npn \__beerydoc_function_footnote:n #1
  {
    \footnotemark
    \hook_gput_next_code:nn { env/function/after } { \footnotetext {#1} }
  }
\cs_new_protected:Npn \__beerydoc_variable_footnote:n #1
  {
    \footnotemark
    \hook_gput_next_code:nn { env/variable/after } { \footnotetext {#1} }
  }
\hook_gput_code:nnn { env/function/begin } { beerydoc }
  { \cs_set_eq:NN \footnote \__beerydoc_function_footnote:n }
\hook_gput_code:nnn { env/variable/begin } { beerydoc }
  { \cs_set_eq:NN \footnote \__beerydoc_variable_footnote:n }

% Floats

\renewcommand\bottomfraction{0.5} % default = 0.3
\setcounter{bottomnumber}{2} % default = 1
\setcounter{topnumber}{3} % default = 2
\setcounter{totalnumber}{4} % default = 3

% Environments

\RequirePackage { multicol }

% Page style

% \flushbottom
\raggedbottom
\vbadness = 100
% \maxdepth = 0pt

\setlength \topskip { \dim_use:N \l_fontscale_normalsize_size_dim }
\setlength \splittopskip { \topskip }

\RequirePackage { geometry }
\geometry
  {
      a4paper
    , textwidth = 5in
    , textheight =
        \fp_to_dim:n { \c_beerydoc_golden_ratio_fp * \dim_to_fp:n { 5in } }
    , heightrounded
    , centering
    , headheight = \skip_use:N \l_fontscale_footnotesize_baselineskip_skip
    , headsep = \dim_use:N \c_beerydoc_big_dim
    , footskip =
        \dim_eval:n
          { \c_beerydoc_big_dim + \l_fontscale_footnotesize_baselineskip_skip }
  }

\RequirePackage { fancyhdr }
\pagestyle { fancy }
\fancyhf { }
\renewcommand \headrulewidth { 0pt }
\fancyfoot [ C ]
  { \footnotesize \thepage \c_space_tl of~ \pageref { LastPage } }

% Paragraph style

% \frenchspacing
\nonfrenchspacing
% \linespread { 1 }
\RequirePackage [ skip = \skip_use:N \c_beerydoc_med_skip ] { parskip }
% default = 0.5 \baselineskip plus 2pt
\RequirePackage [ raggedrightboxes ] { ragged2e }
\setlength \RaggedRightRightskip
  { 0pt plus \dim_use:N \c_beerydoc_alphabet_dim } % default = 0pt plus 2em
\setlength \JustifyingParindent { 2em } % default = \parindent
\RaggedRight
% \justifying
\RequirePackage { microtype }
\microtypesetup { protrusion = false , expansion = false }
\pretolerance = -1 % default = 100
\tolerance = 200 % default = 200
\setlength \emergencystretch { 0pt } % default = 0
\widowpenalty = 10000
\clubpenalty = \widowpenalty
\displaywidowpenalty = \widowpenalty
% hyphenation
\hyphenpenalty = 50 % default = 50
\exhyphenpenalty = \hyphenpenalty % default = 100
\finalhyphendemerits = 0 % default = 5000

% Headings, Table of contents

\RequirePackage { titlesec , titletoc }
\setcounter { secnumdepth } { 3 }
\setcounter { tocdepth } { 3 }

\titlespacing* \section { 0pt } % section , indent
  {
    \skip_eval:n
      {
        \c_beerydoc_big_dim
        plus  \dim_eval:n { \c_beerydoc_big_dim / 2 * 4 }
        minus \dim_eval:n { \c_beerydoc_big_dim / 3 / 4 }
      }
  } % before
  { \skip_use:N \c_beerydoc_med_skip } % after
\titlespacing* \subsection { 0pt }
  {
    \skip_eval:n
      {
        \dim_eval:n { \c_beerydoc_med_dim * 4 / 3 }
        plus  \dim_eval:n { \c_beerydoc_med_dim / 2 * 4 }
        minus \dim_eval:n { \c_beerydoc_med_dim / 3 / 4 }
      }
  }
  { \skip_use:N \c_beerydoc_med_skip }
\titlespacing* \subsubsection { 0pt }
  {
    \skip_eval:n
      {
        \dim_eval:n { \c_beerydoc_med_dim * 4 / 3 }
        plus  \dim_eval:n { \c_beerydoc_med_dim / 2 * 4 }
        minus \dim_eval:n { \c_beerydoc_med_dim / 3 / 4 }
      }
  }
  { \skip_use:N \c_beerydoc_med_skip }

\titleformat \section [ block ] % section , shape
  { \raggedright \large \bfseries } % format
  { \thesection } { 1em } % label , length between label and title body
  { } { } % before code , after code
\titleformat \subsection [ block ]
  { \raggedright \normalsize \bfseries }
  { \thesubsection } { 1em }
  { } { }
\titleformat \subsubsection [ block ]
  { \raggedright \normalsize \bfseries }
  { \thesubsubsection } { 1em }
  { } { }

% Lists, List headings

\RequirePackage { enumitem }
\setlist
  {
      % horizontal spacing
      leftmargin = *
    , labelsep  = 0.5em
      % vertical spacing
    , topsep    = 0pt
    , partopsep = 0pt
    , parsep    = \skip_use:N \c_beerydoc_small_skip
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
% https://tex.stackexchange.com/questions/2644
\NewDocumentCommand \keepnextpar { s }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { keepnextpar } }
      {
        \IfBooleanTF #1
          { \__beerydoc_keep_next_par_if_single_line: }
          { \__beerydoc_keep_next_par: }
      }
  }
\cs_new_protected:Npn \__beerydoc_keep_next_par: { \nobreak \@afterheading }
\cs_new_protected:Npn \__beerydoc_keep_next_par_if_single_line:
  { \int_compare:nNnT \prevgraf = 1 { \__beerydoc_keep_next_par: } }

\NewDocumentCommand \listheading { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { listheading } }
      { \__beerydoc_list_heading:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_list_heading:n #1
  {
    \par
    #1
    \par
    \__beerydoc_keep_next_par_if_single_line:
    \vspace { \skip_eval:n { \c_beerydoc_small_skip - \parskip } }
  }

% Tables

\RequirePackage { tabularray }
\UseTblrLibrary { booktabs , siunitx }

% Verbatim

\RequirePackage { fancyvrb }
\hook_gput_code:nnn { begindocument } { beerydoc } { \DefineShortVerb { \| } }

% Quotes

\RequirePackage { csquotes }
\RenewDocumentEnvironment { quote } { }
  {
    \list { }
      {
        \setlength \leftmargin { 1.5em }
        \setlength \rightmargin { \leftmargin }
      }
    \item \relax
  }
  { \endlist }

% Footnotes

\RequirePackage [ bottomfloats , ragged ] { footmisc }
% \setlength { \skip \footins } { \c_beerydoc_big_skip }
\setlength \footnotesep { \f@linespread \footnotesep }
\box_new:N \l__beerydoc_footnote_box
\coffin_new:N \l__beerydoc_footnote_coffin
\cs_set_protected:Npn \@makefntext #1
  {
    \hbox_set:Nn \l__beerydoc_footnote_box { \@thefnmark . }
    \vcoffin_set:Nnn \l__beerydoc_footnote_coffin { \textwidth }
      {
        \list { \@thefnmark . }
          {
            \setlength \leftmargin
              { \dim_eval:n { \box_wd:N \l__beerydoc_footnote_box + 0.5em } }
            % \setlength \rightmargin { \leftmargin }
            \setlength \labelsep { 0.5em }
            \setlength \topsep { 0pt }
            \setlength \partopsep { 0pt }
          }
        \item \relax #1 \endlist
      }
    \coffin_typeset:Nnnnn \l__beerydoc_footnote_coffin { l } { b }
      { \c_zero_dim } { \c_zero_dim }
  }

% References

\hook_gput_code:nnn { shipout / lastpage } { beerydoc } { \label { LastPage } }
\RequirePackage { xurl }
\RequirePackage { hyperref }
\hypersetup { bookmarksnumbered , hidelinks , linktoc = page }

\cs_new:Npn \__beerydoc_pdfstring_key_value:n #1
  {
    \str_if_eq:enTF { \str_head:n {#1} } { = }
      { \str_range:nnn {#1} { 2 } { -1 } }
      { \tl_to_str:n {#1} }
  }
\cs_new:Npn \__beerydoc_pdfstring_cs:n #1 { \textbackslash \tl_to_str:n {#1} }
\cs_new:Npn \__beerydoc_pdfstring_meta:n #1 { < \tl_to_str:n {#1} > }
% \tl_to_str:n works only when its argument is given in braces.
\cs_new:Npn \__beerydoc_pdfstring_tl_to_str:n #1 { \tl_to_str:n {#1} }
\pdfstringdefDisableCommands
  {
    \cs_set_eq:NN \key  \__beerydoc_pdfstring_key_value:n
    \cs_set_eq:NN \cs   \__beerydoc_pdfstring_cs:n
    \cs_set_eq:NN \meta \__beerydoc_pdfstring_meta:n
    \tl_map_inline:nn { \cls \pkg \env \hook \socket \plug }
      { \cs_set_eq:NN #1 \__beerydoc_pdfstring_tl_to_str:n }
  }

% Messages

\msg_new:nnn { beerydoc } { math-mode-invalid }
  { '\iow_char:N \\ #1'~ invalid~ in~ math~ mode~ \msg_line_context:. }
