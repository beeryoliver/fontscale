% Loading the class

\NeedsTeXFormat{LaTeX2e}[2023-11-01]
\ProvidesExplClass{beerydoc}{2026-08-23}{0.0.0}{}
\prop_gput:Nnn \g_msg_module_type_prop { beerydoc } { Class }

\msg_new:nnn { beerydoc } { l3kernel }
  {
    The~ beerydoc~ class~ could~ not~ load. \\
    This~ class~ requires~
    L3~ programming~ layer~ version~ 2023-11-01~ or~ newer.
  }
\msg_new:nnn { beerydoc } { luatex }
  { The~ beerydoc~ class~ could~ not~ load. \\ This~ class~ requires~ LuaTeX. }

\IfExplAtLeastTF { 2023-11-01 } { }
  { \msg_critical:nn { beerydoc } { l3kernel } }
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
\RenewDocumentCommand \printfontsizecommand { }
  {
    \mode_if_math:TF
      {
        \msg_error:nnn { beerydoc } { math-mode-invalid }
          { printfontsizecommand }
      }
      { \__beerydoc_fontscale_print_name: }
  }
\cs_new_protected:Npn \__beerydoc_fontscale_print_name:
  {
    \exp_args:Ne \cs
      {
        \dim_case:nnF { \l_fontscale_size_dim }
          {
            { \l_fontscale_tiny_size_dim         } { tiny         }
            { \l_fontscale_scriptsize_size_dim   } { scriptsize   }
            { \l_fontscale_footnotesize_size_dim } { footnotesize }
            { \l_fontscale_small_size_dim        } { small        }
            { \l_fontscale_normalsize_size_dim   } { normalsize   }
            { \l_fontscale_large_size_dim        } { large        }
            { \l_fontscale_Large_size_dim        } { Large        }
            { \l_fontscale_LARGE_size_dim        } { LARGE        }
            { \l_fontscale_huge_size_dim         } { huge         }
            { \l_fontscale_Huge_size_dim         } { Huge         }
          }
          { undefined }
      }
  }

\RequirePackage { siunitx }
\sisetup { list-final-separator = { ,~ and~ } , mode = math }
\RequirePackage { mathtools }
\DeclarePairedDelimiter \abs { \lvert } { \rvert }
\cs_set_eq:NN \muskipeval \muskip_eval:n
\RequirePackage { xcolor }

% Font selection

\RequirePackage { lmodern }
\RequirePackage { scaletextbullet }
\settextbulletfactor { 0.4 }

% Some variables

\fp_const:Nn \c_beerydoc_golden_ratio_fp { 1.6180 3398 8749 8948 }
\tl_const:Nn \c_beerydoc_alphabet_lowercase_tl { abcdefghijklmnopqrstuvwxyz }
\tl_const:Nn \c_beerydoc_alphabet_uppercase_tl { ABCDEFGHIJKLMNOPQRSTUVWXYZ }
\str_const:Nn \c_beerydoc_digits_str { 0123456789 }
\tl_const:Nn \c_beerydoc_pangram_tl
  { The~ quick~ brown~ fox~ jumps~ over~ the~ lazy~ dog. }

\hbox_set:Nn \l_tmpa_box { \c_beerydoc_alphabet_lowercase_tl }
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
\skip_set_eq:NN \bigskipamount   \c_beerydoc_big_skip
\skip_set_eq:NN \medskipamount   \c_beerydoc_med_skip
\skip_set_eq:NN \smallskipamount \c_beerydoc_small_skip
\skip_log:N \c_beerydoc_big_skip
\skip_log:N \c_beerydoc_med_skip
\skip_log:N \c_beerydoc_small_skip

\tl_const:Ne \c__beerydoc_math_subscript_underscore_tl
  { \char_generate:nn { `_ } { 8 } }
\group_begin:
  \char_set_catcode_active:N |
  \tl_const:Nn \c__beerydoc_active_vert_tl { | }
  \char_set_active_eq:NN _ \scan_stop:
  \tl_const:Ne \c__beerydoc_active_underscore_tl
    { \char_generate:nn { `_ } { 13 } }
  \char_set_active_eq:NN : \scan_stop:
  \tl_const:Ne \c__beerydoc_active_colon_tl { \char_generate:nn { `: } { 13 } }
  \char_set_active_eq:nN { `\^^I } \scan_stop:
  \tl_const:Ne \c__beerydoc_active_tab_tl
    { \char_generate:nn { `\^^I } { 13 } }
\group_end:

\tl_new:N \l__beerydoc_key_tl
\tl_new:N \l__beerydoc_value_tl
\seq_new:N \l__beerydoc_value_seq
\tl_new:N \l__beerydoc_cs_tl
\tl_new:N \l__beerydoc_meta_tl
\tl_new:N \l__beerydoc_hook_tl
\tl_new:N \l__beerydoc_socket_tl

\coffin_new:N \l__beerydoc_code_coffin
\bool_new:N   \l__beerydoc_code_bool

\tl_new:N     \l__beerydoc_code_names_tl
\seq_new:N    \l__beerydoc_code_names_seq
\coffin_new:N \l__beerydoc_code_names_coffin
\dim_new:N    \l__beerydoc_code_names_dim
\bool_new:N   \l__beerydoc_code_names_long_bool

\coffin_new:N \l__beerydoc_code_descr_coffin
\dim_new:N    \l__beerydoc_code_descr_yoffset_dim

\bool_new:N   \l__beerydoc_syntax_bool
\box_new:N    \g__beerydoc_syntax_box
\coffin_new:N \l__beerydoc_syntax_coffin
\dim_new:N    \l__beerydoc_syntax_yoffset_dim

\box_new:N    \l__beerydoc_footnote_box
\coffin_new:N \l__beerydoc_footnote_coffin

\quark_new:N \q__beerydoc_stop

\tl_new:N \l__beerydoc_tmp_tl
\seq_new:N \l__beerydoc_tmp_seq

% Custom macros

\cs_new_protected:Npn \__beerydoc_langle: { \ensuremath { \langle } }
\cs_new_protected:Npn \__beerydoc_rangle: { \ensuremath { \rangle } }

\cs_new:Npe \alphabet { \c_beerydoc_alphabet_lowercase_tl }
\cs_new:Npe \digits { \c_beerydoc_digits_str }
\cs_new:Npe \pangram { \c_beerydoc_pangram_tl }

\NewDocumentCommand \key { o m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { key } }
      {
        \IfNoValueTF {#1}
          { \__beerydoc_key_value:n {#2} }
          { \__beerydoc_key_value:nn {#1} {#2} }
      }
  }
\cs_new_protected:Npn \__beerydoc_key_value:n #1
  {
    \tl_if_in:nnTF {#1} { = }
      { \__beerydoc_key_value:w #1 \q__beerydoc_stop }
      { \__beerydoc_key:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_key_value:nn #1#2
  {
    \group_begin:
      \keys_set:nn { beerydoc / key } {#1}
      \__beerydoc_key_value:n {#2}
    \group_end:
  }
\keys_define:nn { beerydoc / key }
  {
      neq .bool_set:N = \l__beerydoc_key_value_neq_bool
    , neq .value_forbidden:n = true
    , neq .default:n = true
  }
\cs_new_protected:Npn \__beerydoc_key_value:w #1 = #2 \q__beerydoc_stop
  {
    \tl_if_blank:nF {#1}
      {
        \__beerydoc_key:n {#1}
        \__beerydoc_key_value_equal:
      }
    \__beerydoc_value_list:n {#2}
  }
\cs_new_protected:Npn \__beerydoc_key:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_key_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_key_tl { / } { \slash }
      \ttfamily
      \l__beerydoc_key_tl \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_key_value_equal:
  {
    \bool_if:NTF \l__beerydoc_syntax_bool
      { ~=~ }
      {
        \bool_if:NTF \l__beerydoc_key_value_neq_bool
          { \ensuremath { \, \neq \, } \allowbreak }
          { \ensuremath { \, = \, } \allowbreak }
      }
  }
\cs_new_protected:Npn \__beerydoc_value_list:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_value_tl {#1}
      \tl_replace_all:NVn \l__beerydoc_value_tl \c__beerydoc_active_vert_tl
        { | }
      \tl_replace_all:NVn \l__beerydoc_value_tl \c_catcode_active_space_tl
        { \textvisiblespace }
      \tl_replace_all:Nnn \l__beerydoc_value_tl { ~ } { \textvisiblespace }
      \seq_set_split:NnV \l__beerydoc_value_seq { | } \l__beerydoc_value_tl
      \ttfamily
      \seq_use:Nn \l__beerydoc_value_seq { \__beerydoc_value_separator: }
      \@
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_value_separator:
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
      \__beerydoc_cs_normalize:
      \__beerydoc_cs_replace_spaces:
      \__beerydoc_cs_hyphenation:
      \ttfamily
      \c_backslash_str \l__beerydoc_cs_tl \@
    \group_end:
  }
\cs_new_protected:Npe \__beerydoc_cs_normalize:
  {
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { \exp_not:V \c__beerydoc_active_vert_tl } { | }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { \exp_not:V \c__beerydoc_active_colon_tl } { \c_colon_str }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { \c__beerydoc_math_subscript_underscore_tl } { \c_underscore_str }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { _ } { \c_underscore_str }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { \exp_not:V \c__beerydoc_active_underscore_tl } { \c_underscore_str }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_cs_tl
      { \exp_not:N \_ } { \c_underscore_str }
  }
\cs_new_protected:Npn \__beerydoc_cs_replace_spaces:
  {
    \tl_replace_all:NVn \l__beerydoc_cs_tl \c_catcode_active_space_tl
      { \textvisiblespace }
    \tl_replace_all:Nnn \l__beerydoc_cs_tl { ~ } { \textvisiblespace }
  }
\cs_new_protected:Npn \__beerydoc_cs_hyphenation:
  {
    \bool_if:NF \l__beerydoc_syntax_bool
      {
        \tl_if_in:NVT \l__beerydoc_cs_tl \c_underscore_str
          {
            \regex_replace_all:NnN \c__beerydoc_cs_hyphenation_regex
              { \1 \c{-} \2 } \l__beerydoc_cs_tl
          }
      }
  }
\regex_const:Nn \c__beerydoc_cs_hyphenation_regex { ([^\_]\_+)([^\_]) }
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
      \ttfamily \slshape
      \__beerydoc_langle:
      \l__beerydoc_meta_tl
      \__beerydoc_rangle:
    \group_end:
  }
\cs_new_protected:Npn \__beerydoc_meta_subscript:n #1
  { \ensuremath { \sb {#1} } }
\cs_new_protected:Npe \__beerydoc_meta_replace_underscore:
  {
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_meta_tl
      { \c__beerydoc_math_subscript_underscore_tl }
      { \__beerydoc_meta_subscript:n }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_meta_tl
      { _ } { \__beerydoc_meta_subscript:n }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_meta_tl
      { \c_underscore_str } { \__beerydoc_meta_subscript:n }
    \tl_replace_all:Nnn \exp_not:N \l__beerydoc_meta_tl
      { \exp_not:V \c__beerydoc_active_underscore_tl }
      { \__beerydoc_meta_subscript:n }
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
\group_begin:
  \cs_set_protected:Npn \__beerydoc_tmp:Nn #1#2
    {
      \cs_new_protected:Npe #1 ##1
        {
          \group_begin:
            \exp_not:N \ttfamily
            \c_left_brace_str #2 \c_right_brace_str
          \group_end:
        }
    }
  \__beerydoc_tmp:Nn \__beerydoc_m_arg:n {#1}
  \__beerydoc_tmp:Nn \__beerydoc_m_arg_meta:n { \meta {#1} }
\group_end:

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
\cs_new_protected:Npn \__beerydoc_o_arg:n #1
  { \group_begin: \ttfamily [ #1 ] \group_end: }
\cs_new_protected:Npn \__beerydoc_o_arg_meta:n #1
  { \group_begin: \ttfamily [ \meta {#1} ] \group_end: }

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
  {cls}  \sffamily
  {pkg}  \sffamily
  {env}  \ttfamily
  {plug} \ttfamily
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
      \tl_replace_all:Nnn \l__beerydoc_hook_tl { / } { \slash }
      \ttfamily
      \l__beerydoc_hook_tl \@
    \group_end:
  }

\NewDocumentCommand \socket { m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { socket } }
      { \__beerydoc_socket:n {#1} }
  }
\cs_new_protected:Npn \__beerydoc_socket:n #1
  {
    \group_begin:
      \tl_set:Nn \l__beerydoc_socket_tl {#1}
      \tl_replace_all:Nnn \l__beerydoc_socket_tl { / } { \slash }
      \ttfamily
      \l__beerydoc_socket_tl \@
    \group_end:
  }

\NewDocumentCommand \charcode { o m }
  {
    \mode_if_math:TF
      { \msg_error:nnn { beerydoc } { math-mode-invalid } { charcode } }
      {
        \bool_lazy_and:nnF
          { \tl_if_single_p:n {#2} }
          { \tl_if_single_token_p:n #2 }
          { \msg_error:nnn { beerydoc } { char-invalid } {#2} }
        \IfNoValueTF {#1}
          { \__beerydoc_charcode:N #2 }
          { \__beerydoc_charcode:Nn #2 {#1} }
      }
  }
\cs_new_protected:Npn \__beerydoc_charcode:N #1
  {
    \texttt
      {
        \int_compare:nNnTF { `#1 } = { 32 }
          { \textvisiblespace }
          { \char_generate:nn { `#1 } { 12 } }
      }
    \__beerydoc_charcode_subscript:n { \char_value_catcode:n { `#1 } }
  }
\cs_new_protected:Npn \__beerydoc_charcode:Nn #1#2
  {
    \texttt
      {
        \int_compare:nNnTF { `#1 } = { 32 }
          { \textvisiblespace }
          { \char_generate:nn { `#1 } { 12 } }
      }
    \__beerydoc_charcode_subscript:n { \int_eval:n {#2} }
  }
\cs_new_eq:NN \__beerydoc_charcode_subscript:n \__beerydoc_meta_subscript:n

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

\RenewDocumentCommand \slash { } { / \penalty \exhyphenpenalty }

% Code and syntax environments

% For the code and syntax environments, I have used ideas from l3doc.
\str_new:N \l__beerydoc_code_input_separator_str
\str_set:Nn \l__beerydoc_code_input_separator_str { , }
\keys_define:nn { beerydoc / code }
  {
      input-separator .code:n =
        {
          \str_set:Nn \l__beerydoc_code_input_separator_str {#1}
          \str_if_empty:NT \l__beerydoc_code_input_separator_str
            { \msg_error:nn { beerydoc } { code-input-separator-invalid } }
          \str_if_in:NnT \l__beerydoc_code_input_separator_str { ~ }
            { \msg_error:nn { beerydoc } { code-input-separator-invalid } }
        }
    , input-separator .value_required:n = true
  }
\NewDocumentEnvironment { code } { o +v }
  {
    \IfNoValueF {#1}
      { \keys_set:nn { beerydoc / code } {#1} }
    \__beerydoc_code_start:nw {#2}
  }
  { \__beerydoc_code_end: }
\cs_new_protected:Npn \__beerydoc_code_start:nw #1
  {
    \__beerydoc_code_typeset_start:
    \__beerydoc_code_init:
    \__beerydoc_code_names:n {#1}
    \__beerydoc_code_descr_start:w
  }
\cs_new_protected:Npn \__beerydoc_code_end:
  {
    \__beerydoc_code_descr_stop:
    \__beerydoc_code_assemble:
    \__beerydoc_code_typeset_stop:
  }
\cs_new_protected:Npn \__beerydoc_code_typeset_start:
  {
    \par
    \vspace { \skip_eval:n { \c_beerydoc_med_skip - \parskip } }
    \noindent
  }
\cs_new_protected:Npn \__beerydoc_code_typeset_stop:
  {
    \par
    \dim_set:Nn \prevdepth { \coffin_dp:N \l__beerydoc_code_coffin }
    \vspace { \skip_eval:n { \c_beerydoc_med_skip - \parskip } }
  }
\cs_new_protected:Npn \__beerydoc_code_init:
  {
    \bool_if:NT \l__beerydoc_code_bool
      { \msg_error:nn { beerydoc } { code-env-not-nestable } }
    \bool_set_true:N \l__beerydoc_code_bool
    \box_gclear:N \g__beerydoc_syntax_box
    \cs_set_eq:NN \footnote \__beerydoc_code_footnote:n
  }
\cs_new_protected:Npn \__beerydoc_code_footnote:n #1
  {
    \footnotemark
    \hook_gput_next_code:nn { env / code / after } { \footnotetext {#1} }
  }
\cs_new_protected:Npn \__beerydoc_code_names:n #1
  {
    \__beerydoc_code_names_set:n {#1}
    \hcoffin_set:Nn \l__beerydoc_code_names_coffin
      {
        \ttfamily \small
        \begin { tblr } [ expand = \expanded ]
          { colspec = { l } , rowsep = 0pt , colsep = 0pt }
          \toprule
          \addlinespace [ 2pt ]
            \expanded { \seq_use:Nn \l__beerydoc_code_names_seq { \\ } }
            \\
          \addlinespace [ 2pt ]
          \bottomrule
        \end { tblr }
      }
    \dim_set:Nn \l__beerydoc_code_names_dim
      { \coffin_wd:N \l__beerydoc_code_names_coffin }
    \bool_set:Nn \l__beerydoc_code_names_long_bool
      { \dim_compare_p:nNn \l__beerydoc_code_names_dim > \marginparwidth }
  }
\cs_new_protected:Npn \__beerydoc_code_names_set:n #1
  {
    \tl_set:Nn \l__beerydoc_code_names_tl {#1}
    \tl_replace_all:NVn \l__beerydoc_code_names_tl
      { \c_catcode_active_space_tl } { \scan_stop: }
    \tl_replace_all:NVn \l__beerydoc_code_names_tl
      { \c__beerydoc_active_tab_tl } { \scan_stop: }
    \tl_replace_all:NVn \l__beerydoc_code_names_tl
      \l__beerydoc_code_input_separator_str { \obeyedline }
    \seq_set_split:NnV \l__beerydoc_code_names_seq
      { \obeyedline } \l__beerydoc_code_names_tl
    \seq_map_variable:NNn \l__beerydoc_code_names_seq \l__beerydoc_tmp_tl
      {
        \tl_set:Ne \l__beerydoc_tmp_tl
          {
            \exp_after:wN \__beerydoc_code_names_set_loop:N
              \l__beerydoc_tmp_tl
              \q_recursion_tail
            \q_recursion_stop
          }
        \tl_if_empty:NF \l__beerydoc_tmp_tl
          {
            \tl_replace_all:Nnn \l__beerydoc_tmp_tl
              { \scan_stop: } { \textvisiblespace }
            \seq_put_right:NV \l__beerydoc_tmp_seq \l__beerydoc_tmp_tl
          }
      }
    \seq_if_empty:NT \l__beerydoc_tmp_seq
      { \msg_error:nn { beerydoc } { code-env-no-items } }
    \seq_set_eq:NN \l__beerydoc_code_names_seq \l__beerydoc_tmp_seq
  }
\cs_new:Npn \__beerydoc_code_names_set_loop:N #1
  {
    \quark_if_recursion_tail_stop:N #1
    \token_if_eq_meaning:NNTF #1 \scan_stop:
      { \__beerydoc_code_names_set_loop:N }
      { \__beerydoc_code_names_set_loop_end:nw {#1} }
  }
\cs_new:Npn \__beerydoc_code_names_set_loop_end:nw #1#2
  \q_recursion_tail \q_recursion_stop
  { \exp_not:n { #1 #2 } }
\cs_new_protected:Npn \__beerydoc_code_descr_start:w
  {
    \vcoffin_set:Nnw \l__beerydoc_code_descr_coffin { \textwidth }
      \noindent \ignorespaces
  }
\cs_new_protected:Npn \__beerydoc_code_descr_stop: { \vcoffin_set_end: }
\cs_new_protected:Npn \__beerydoc_code_assemble:
  {
    \dim_set:Nn \l__beerydoc_code_descr_yoffset_dim
      {
        \l_fontscale_normalsize_baselineskip_skip -
        0.7 \l_fontscale_normalsize_size_dim
      }
    \dim_set:Nn \l__beerydoc_syntax_yoffset_dim { \heavyrulewidth + 2pt }
    \bool_if:NTF \l__beerydoc_code_names_long_bool
      {
        \box_if_empty:NTF \g__beerydoc_syntax_box
          {
            \coffin_set_eq:NN \l__beerydoc_code_coffin
              \l__beerydoc_code_descr_coffin
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { l } { t }
              \l__beerydoc_code_names_coffin { l } { b }
              { - \marginparwidth - \marginparsep }
              { \l__beerydoc_code_descr_yoffset_dim }
          }
          {
            \hcoffin_set:Nn \l__beerydoc_syntax_coffin
              { \box_use:N \g__beerydoc_syntax_box }
            \coffin_set_eq:NN \l__beerydoc_code_coffin
              \l__beerydoc_code_names_coffin
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { r } { t }
              \l__beerydoc_syntax_coffin { l } { t }
              { \marginparsep } { - \l__beerydoc_syntax_yoffset_dim }
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { r } { b }
              \l__beerydoc_code_descr_coffin { r } { t }
              { 0pt } { - \l__beerydoc_code_descr_yoffset_dim }
          }
        \coffin_typeset:Nnnnn \l__beerydoc_code_coffin { l } { T }
          { - \marginparwidth - \marginparsep } { 0pt }
      }
      {
        \box_if_empty:NTF \g__beerydoc_syntax_box
          {
            \coffin_set_eq:NN \l__beerydoc_code_coffin
              \l__beerydoc_code_descr_coffin
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { l } { t }
              \l__beerydoc_code_names_coffin { l } { t }
              { - \l__beerydoc_code_names_dim - \marginparsep }
              { \l__beerydoc_syntax_yoffset_dim }
          }
          {
            \hcoffin_set:Nn \l__beerydoc_syntax_coffin
              { \box_use:N \g__beerydoc_syntax_box }
            \coffin_set_eq:NN \l__beerydoc_code_coffin
              \l__beerydoc_syntax_coffin
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { l } { b }
              \l__beerydoc_code_descr_coffin { l } { t }
              { 0pt }
              {
                - \l__beerydoc_code_descr_yoffset_dim
                - \l__beerydoc_syntax_yoffset_dim
              }
            \coffin_join:NnnNnnnn \l__beerydoc_code_coffin { l } { t }
              \l__beerydoc_code_names_coffin { r } { t }
              { - \marginparsep } { \l__beerydoc_syntax_yoffset_dim }
          }
        \coffin_typeset:Nnnnn \l__beerydoc_code_coffin { l } { T }
          { - \l__beerydoc_code_names_dim - \marginparsep } { 0pt }
      }
  }
\NewDocumentEnvironment { syntax } { } { \__beerydoc_syntax:w }
  { \__beerydoc_syntax_end: }
\cs_new_protected:Npn \__beerydoc_syntax:w
  {
    \__beerydoc_syntax_init:
    \vbox_gset:Nw \g__beerydoc_syntax_box
      \dim_set:Nn \hsize
        {
          \textwidth
          \bool_if:NT \l__beerydoc_code_names_long_bool
            { - \l__beerydoc_code_names_dim + \marginparwidth }
        }
      \skip_zero:N \parskip
      \ttfamily \small
      \raggedright
      \obeyspaces \obeylines
  }
\cs_new_protected:Npn \__beerydoc_syntax_end:
  {
    \vbox_gset_end:
    \ignorespacesafterend
  }
\cs_new_protected:Npn \__beerydoc_syntax_init:
  {
    \bool_if:NF \l__beerydoc_code_bool
      { \msg_error:nn { beerydoc } { syntax-env-misused } }
    \bool_if:NT \l__beerydoc_syntax_bool
      { \msg_error:nn { beerydoc } { syntax-env-not-nestable } }
    \bool_set_true:N \l__beerydoc_syntax_bool
  }

% Floats

\tl_set:Nn \bottomfraction { 0.5 } % default = 0.3
\setcounter { bottomnumber } { 2 } % default = 1
\setcounter { topnumber } { 3 } % default = 2
\setcounter { totalnumber } { 4 } % default = 3

% Environments

\RequirePackage { multicol }

% Page style

% \flushbottom
\raggedbottom
\vbadness = 100
% \maxdepth = 0pt

\skip_set:Nn \topskip { \l_fontscale_normalsize_size_dim }
\skip_set_eq:NN \splittopskip \topskip

\RequirePackage { geometry }
\exp_args:Ne \geometry
  {
      a4paper
    , textwidth = 5in
    , textheight =
        \fp_to_dim:n { \c_beerydoc_golden_ratio_fp * \dim_to_fp:n { 5in } }
    , heightrounded
    , hmarginratio = 2 \c_colon_str 1
    , headheight = \skip_use:N \l_fontscale_footnotesize_baselineskip_skip
    , headsep = \dim_use:N \c_beerydoc_big_dim
    , footskip =
        \dim_eval:n
          { \c_beerydoc_big_dim + \l_fontscale_footnotesize_baselineskip_skip }
  }
\dim_set:Nn \marginparsep { 1em }
\dim_log:N \marginparsep
\dim_set:Nn \marginparwidth { 2in - \marginparsep }
\dim_log:N \marginparwidth

\RequirePackage { fancyhdr }
\pagestyle { fancy }
\fancyhf { }
\tl_set:Nn \headrulewidth { 0pt }
\fancyfoot [ C ] { \thepage \c_space_tl of~ \pageref { LastPage } }

% Paragraph style

\frenchspacing
% \nonfrenchspacing
% \linespread { 1 }
\RequirePackage [ skip = \skip_use:N \c_beerydoc_med_skip ] { parskip }
% default = 0.5 \baselineskip plus 2pt
\RequirePackage [ raggedrightboxes ] { ragged2e }
% default = 0pt plus 2em
\skip_set:Nn \RaggedRightRightskip { 0pt plus \c_beerydoc_alphabet_dim }
\dim_set:Nn \JustifyingParindent { 2em } % default = \parindent
\RaggedRight
% \justifying
\RequirePackage { letterspace }
\pretolerance = -1 % default = 100
\tolerance = 200 % default = 200
\emergencystretch = 0pt % default = 0
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
        \dim_eval:n { \c_beerydoc_big_dim * 4 / 3 }
        plus  \dim_eval:n { \c_beerydoc_big_dim / 2 * 4 }
        minus \dim_eval:n { \c_beerydoc_big_dim / 3 / 4 }
      }
  } % before
  { \skip_use:N \c_beerydoc_med_skip } % after
\titlespacing* \subsection { 0pt }
  {
    \skip_eval:n
      {
        \c_beerydoc_big_dim
        plus  \dim_eval:n { \c_beerydoc_big_dim / 2 * 4 }
        minus \dim_eval:n { \c_beerydoc_big_dim / 3 / 4 }
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
  { \raggedright \Large \bfseries } % format
  { \thesection } { 1em } % label , length between label and title body
  { } { } % before code , after code
\titleformat \subsection [ block ]
  { \raggedright \large \bfseries }
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
      leftmargin = 2em
    , labelsep  = 0.5em
      % vertical spacing
    , topsep    = 0pt
    , partopsep = 0pt
    , parsep    = 0pt
    , itemsep   = 0pt
  }
\setlist [2] { leftmargin = * }
\setlist [3] { leftmargin = * }
\setlist [4] { leftmargin = * }
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
  { #1 \par \__beerydoc_keep_next_par_if_single_line: }

% Tables

\RequirePackage { tabularray }
\UseTblrLibrary { booktabs , siunitx }

% Verbatim

\cs_new_protected:Npn \__beerydoc_active_vert:
  {
    \mode_if_math:TF { \vert }
      {
        \group_begin:
          \char_set_active_eq:nN { `\  } \textvisiblespace
          \char_set_active_eq:nN { `\^^I } \textvisiblespace
          \ttfamily
          \__beerydoc_active_vert:w |
      }
  }
\NewDocumentCommand \__beerydoc_active_vert:w { v } { #1 \@ \group_end: }
\hook_gput_code:nnn { begindocument } { beerydoc }
  {
    \char_set_active_eq:NN | \__beerydoc_active_vert:
    \char_set_catcode_active:N |
  }
\hook_gput_code:nnn { cmd / dospecials / after } { beerydoc } { \do | }

% Quotes

\RequirePackage { csquotes }
\RenewDocumentEnvironment { quote } { }
  {
    \list { }
      {
        \dim_set:Nn \leftmargin { 1.5em }
        \dim_set_eq:NN \rightmargin \leftmargin
      }
    \item \scan_stop:
  }
  { \endlist }

% Footnotes

\RequirePackage [ bottomfloats , ragged ] { footmisc }
% \setlength { \skip \footins } { \c_beerydoc_big_skip }
\dim_set:Nn \footnotesep { \f@linespread \footnotesep }
\cs_set_protected:Npn \@makefntext #1
  {
    \hbox_set:Nn \l__beerydoc_footnote_box { \@thefnmark . }
    \vcoffin_set:Nnn \l__beerydoc_footnote_coffin { \textwidth }
      {
        \list { \@thefnmark . }
          {
            \dim_set:Nn \leftmargin
              { \box_wd:N \l__beerydoc_footnote_box + 0.5em }
            % \dim_set_eq:NN \rightmargin \leftmargin
            \dim_set:Nn \labelsep { 0.5em }
            \skip_zero:N \topsep
            \skip_zero:N \partopsep
          }
        \item \scan_stop: #1 \endlist
      }
    \coffin_typeset:Nnnnn \l__beerydoc_footnote_coffin { l } { b }
      { 0pt } { 0pt }
  }

% References

\hook_gput_code:nnn { shipout / lastpage } { beerydoc } { \label { LastPage } }
\RequirePackage { xurl }
\RequirePackage { hyperref }
\hypersetup { bookmarksnumbered , hidelinks , linktoc = page }

% The argument to \tl_to_str:n must be braced.
\cs_new:Npn \__beerydoc_pdfstring_tl_to_str:n #1 { \tl_to_str:n {#1} }
\cs_new:Npn \__beerydoc_pdfstring_meta:n #1 { < \tl_to_str:n {#1} > }
\cs_new:Npn \__beerydoc_pdfstring_cs:n #1 { \textbackslash \tl_to_str:n {#1} }
\NewExpandableDocumentCommand \__beerydoc_pdfstring_key_value:w { o m }
  {
    \str_if_eq:eeTF { \str_head:n {#2} } { = }
      { \str_range:nnn {#2} { 2 } { -1 } }
      { \tl_to_str:n {#2} }
  }

\pdfstringdefDisableCommands
  {
    \tl_map_inline:nn { \cls \pkg \env \hook \socket \plug }
      { \cs_set_eq:NN #1 \__beerydoc_pdfstring_tl_to_str:n }
    \cs_set_eq:NN \meta \__beerydoc_pdfstring_meta:n
    \cs_set_eq:NN \cs   \__beerydoc_pdfstring_cs:n
    \cs_set_eq:NN \key  \__beerydoc_pdfstring_key_value:w
  }

% Messages

\msg_new:nnn { beerydoc } { math-mode-invalid }
  { '\iow_char:N \\ #1'~ invalid~ in~ math~ mode~ \msg_line_context:. }
\msg_new:nnn { beerydoc } { char-invalid }
  { Invalid~ character~ '#1'~ \msg_line_context:. }
\msg_new:nnn { beerydoc } { code-input-separator-invalid }
  {
    Invalid~ value~ '\l__beerydoc_code_input_separator_str'~
    \msg_line_context:. \\
    The~ value~ of~ the~ key~ 'code / input-separator'~ cannot~ be~ empty~ or~
    contain~ spaces.
  }
\msg_new:nnn { beerydoc } { code-env-no-items }
  {
    The~ argument~ to~ the~ 'code'~ environment~ must~ contain~ at~ least~
    one~ code~ element~ \msg_line_context:.
  }
\msg_new:nnn { beerydoc } { code-env-not-nestable }
  {
    The~ 'code'~ environment~ cannot~ be~ used~ within~ another~
    'code'~ environment~ \msg_line_context:.
  }
\msg_new:nnn { beerydoc } { syntax-env-misused }
  {
    The~ 'syntax' environment~ must~ be~ used~ within~ a~
    'code'~ environment~ \msg_line_context:.
  }
\msg_new:nnn { beerydoc } { syntax-env-not-nestable }
  {
    The~ 'syntax' environment~ cannot~ be~ used~ within~ another~
    'syntax'~ environment~ \msg_line_context:.
  }
