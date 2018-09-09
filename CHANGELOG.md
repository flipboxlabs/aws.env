# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).
## [1.1.0] 2018-09-08
### Changed
- Changed from pushing the entire .env file as a parameter to reading in the file and putting each variable as it's own parameter.

### Added
- bin/dotenv entry point with subcommands. Use `./bin/dotenv help` for all available subcommands.
- Single delete parameter
- Single put parameter

## [1.0.1] 2018-07-31
### Fixed
- fixed colored output so it doesn't error of the $TERM variable is empty

## [1.0.0] 2018-07-28
### Added
- Initial release
