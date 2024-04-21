# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

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