# Change log

## [v0.4.0] - 2016-08-07

### Added
* Add #auto_spin to automatically displaying spinning animation

### Changed
* Change #start to setup timer and reset done state

## [v0.3.0] - 2016-07-14

### Added
* Add #run to automatically execute job with spinning animation by @Thermatix
* Add #update to allow for dynamic label name replacement

### Fixed
* Fixed cursor hiding for success and error calls by @m-o-e
* Fix #join call to define actual error
* Fix #stop to print only once when finished

## [v0.2.0] - 2016-03-13

### Added
* Add new spinner formats by @rlqualls
* Add ability to specify custom frames through :frames option
* Add :clear option for removing spinner output when done
* Add #success and #error calls for stopping spinner
* Add :done, :success, :error completion events
* Add :success_mark & :error_mark to allow changing markers
* Add :interval for automatic spinning duration
* Add #start, #join and #kill for automatic spinner animation

### Changed
* Change message formatting, use :spinner token to customize message
* Change format for definining spinner formats and intervals

## [v0.1.0] - 2014-11-15

* Initial implementation and release

[v0.4.0]: https://github.com/peter-murach/tty-spinner/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/peter-murach/tty-spinner/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/peter-murach/tty-spinner/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/peter-murach/tty-spinner/compare/v0.1.0
