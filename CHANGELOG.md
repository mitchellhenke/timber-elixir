# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

  - Fixed an error where `Timber.Integrations.PhoenixInstrumenter` would cause
    an error during blacklist checks if the blacklist had not been set up.

  - Fixed an error where `Timber.Integrations.PhoenixInstrumenter` would fail on render
    events for `conn` structs that did not have a controller or action set. For
    example, when a `conn` did not match listed routes, a `404.html` template
    would be rendered that did not have a controller or action. The render event
    would still be triggered though.

## [2.5.5] - 2017-09-21

### Fixed

  - `Timber.Events.HTTPRepsonseEvent` no longer enforces the `:time_ms` key on
    the struct. This brings it in line with the specification

## [2.5.4] - 2017-09-18

### Fixed

  - Fixed a bug within the installer where HTTP log delivery was being used on platforms that
    should use STDOUT / :console.

### Added

  - Support for blacklisting controller actions with
    `Timber.Integrations.PhoenixInstrumentater`. This will suppress log lines
    from being written for any controller/action pair.

[Unreleased]: https://github.com/timberio/timber-elixir/compare/v2.5.5...HEAD
[2.5.5]: https://github.com/timberio/timber-elixir/compare/v2.5.4...v2.5.5
[2.5.4]: https://github.com/timberio/timber-elixir/compare/v2.5.3...v2.5.4