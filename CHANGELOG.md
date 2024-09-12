# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v2.4.0] - 2024-09-10

### Changed
- `\fontscalesetup` no longer issues a warning if the lengths of the font
  baselineskips are not ordered from `\tiny` to `\Huge`.
- Code improvements.

## [v2.3.0] - 2024-09-06

### Changed
- The package commands no longer check if the font baselineskip is less than
  the font size.

## [v2.2.0] - 2024-08-29

### Changed
- Improved the messages issued by this package.

### Added
- `\SetFontBaselineskip`

## [v2.1.0] - 2024-08-12

### Changed
- Documentation improvements.

### Added
- `\CurrentFontSizeCommand`

## [v2.0.0] - 2024-08-02

### Changed
- This update includes many changes that are backwards incompatible.
- The documentation has been completely rewritten.
- Package description changed from "A user interface for setting document font
  sizes" to "A flexible interface for setting font sizes".
- The code no longer uses `\@setfontsize`.
- The font size commands provided by this package now do nothing, except issue
  a warning, if used in math mode.
- The base font size of the musical typographic scale is now set by the new key
  `musical/base`.
- `\PrintFontParameters` renamed to `\PrintFontSizeParameters`.
- `\PrintAllFontParameters` renamed to `\PrintAllFontSizeParameters`.
- `\PrintSampleText` uses a `+m`- instead of an `O`-type argument.
- `\PrintFontSizeCommand` prints `\undefined` instead of `UNDEFINED`.
- `\fontscalesetup` is now removed in `\text_purify:n`.

### Removed
- Keys `typographic-scale=modular` and `modular`.
- Key `ignore-order` (no support for using `\tiny` to `\Huge` in the wrong
  order).
- Key `reset` (very rarely used).
- Public `prop` variables for each font size command from `\tiny` to `\Huge`.
  (They are redundant with the other public variables and programmers will very
  likely prefer using their own `prop` variables.)

### Added
- `\fontscalesetup` now has an optional starred argument which first resets the
  keys to their initial values.
- Key `musical/base` (explained earlier).
- The package commands now issue a user-friendly error message if the font size
  is a zero or negative length.
- The package commands now issue an error if the font baselineskip is less than
  the font size.
- The package commands that would produce a low-level error if used in math
  mode now issue a user-friendly error message instead.

### Fixed
- Now correctly checks that the package requires `LaTeX2e` version 2023-11-01
  or newer.
- The keys `<font size command>` no longer incorrectly treat a `/` within a
  brace group as the delimiter.

## [v1.3.0] - 2024-05-17

### Added
- `\fontscalesetup` now provides error checking for the keys `modular/ratio`,
  `musical/ratio`, and `musical/notes`.
- It is now documented that `\fontscalesetup` uses `\normalsize` after it
  finishes processing the package keys.

### Changed
- The code now regularly uses `V`- and `v`-type arguments to get the value of a
  variable.
- The code now uses private `expl3` wrappers around the `LaTeX2e` commands
  `\@setfontsize`, `\fontsize`, and `\selectfont`.

## [v1.2.2] - 2024-04-29

### Changed
- Improved package messages when issuing errors and warnings.
- Code improvements.

### Fixed
- The documentation no longer incorrectly compares `\ScaleFont` with
  `\scalefont` from the `scalefnt` package.
- The internal function for the key `reset=preamble` now correctly initializes
  to `\prg_do_nothing:`.

## [v1.2.1] - 2024-04-21

### Changed
- Improved the error message for `\SetFontStep*` when the current font step is
  undefined.
- Documentation improvements.

## [v1.2.0] - 2024-04-15

### Added
- It is now documented that the keys and commands provided by this package take
  as a value or argument a dimen, skip, floating point, or integer expression
  instead of simply a size, skip, number, or integer.
- This package now includes a CHANGELOG file.

### Changed
- Documentation improvements.

### Fixed
- The key `reset=preamble` and `\SetFontStep` no longer rely on undocumented
  `expl3` features.
- Corrected typo in the documentation.

## [v1.1.1] - 2024-04-07

### Changed
- Improved performance, especially when using a musical typographic scale.
- Small documentation improvements.

## [v1.1.0] - 2024-03-31

### Added
 - `\SetFontStep`, `\SetFontScale`, `\SetFontSize`, `\ScaleFont`, and
 `\SetFontSizeBaselineskip` are now set up to work with `\text_purify:n`.

## [v1.0.3] - 2024-03-26

### Changed
- Code improvements, particularly to document commands defined with optional
  arguments.

## [v1.0.2] - 2024-03-22

### Changed
- Performance and code improvements.

### Fixed
- Fixed issue where the key `reset=preamble` relied on an unsupported `V`-type
  `bool` argument.

## [v1.0.1] - 2024-03-08

### Added
- Added the `.tex` sources for the documentation.
- Added the CTAN link to the `.sty` and README files.

## [v1.0.0] - 2024-03-06

### Added
- First official release to CTAN.