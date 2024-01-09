## [Unreleased]

## [0.6.0] - 2023-12-22

### Added

- Implement after actions (#53).
- Zeitwerk autoloading and reloading by [@alex-rogachev](https://github.com/alex-rogachev) (#54).
- Support the `environment`, `binding`, `timeout`, and `max_clients` options when using `rage s` (#52).
- Add CORS middleware (#49).

### Fixed

- Prevent `block` and `sleep` channels from conflicting (#51).

## [0.5.2] - 2023-12-11

### Added

- Add env class (#43).

### Changed

- Schedule request Fibers in a separate middleware (#48).

## [0.5.1] - 2023-12-01

### Fixed

- Fix logging inside detached fibers (#41).
- Allow to configure the logger as `nil` (#42).

## [0.5.0] - 2023-11-25

### Added

- Add sessions for compatibility with `Sidekiq::Web` (#35).
- Add logger (#33).

### Fixed

- Fixes for `FiberScheduler#io_wait` and `FiberScheduler#io_read` (#32).
- Correctly handle exceptions in inner fibers (#34).
- Fixes for `FiberScheduler#kernel_sleep` (#36).

### Changed

- Use config namespaces (#25).
- Update `Fiber.await` signature (#36).

## [0.4.0] - 2023-10-31

### Added

- Expose the `params` object (#23).
- Support header authentication with `authenticate_with_http_token` (#21).
- Add the `resources` route helper (#20).
- Add the `namespace` route helper by [@arikarim](https://github.com/arikarim) (#17).
- Add the `mount` and `match` route helpers by [@arikarim](https://github.com/arikarim) (#18) (#14).
- Allow to access request headers by [@arikarim](https://github.com/arikarim) (#15).
- Support custom ports when starting the app with `rage s`.

## [0.3.0] - 2023-10-08

### Added

- CLI `routes` task by [@arikarim](https://github.com/arikarim) (#9).
- CLI `console` task (#12).
- `:if` and `:unless` options in `before_action` (#10).
- Allow to set response headers (#11).
- Block version of `before_action` by [@heysyam99](https://github.com/heysyam99) (#8).

## [0.2.0] - 2023-09-27

### Added

- Gem configuration by env.
- Add `skip_before_action`.
- Add `rescue_from`.
- Add `Fiber.await`.
- Support the `defaults` route option.

### Fixed

- Ignore trailing slashes in the URLs.
- Support constraints in routes with optional params.
- Make the `root` routes helper work correctly with scopes.
- Convert objects to string when rendering text.

## [0.1.0] - 2023-09-15

- Initial release
  - Add console utility to generate new apps and start up the server.
  - Implement base API controller:
    - support `before_action` with the `only` and `except` options;
    - support `render` with the `json`, `plain` and `status` options;
    - support the `head` method;
  - Implement router:
    - support the `root`, `get`, `post`, `patch`, `put`, `delete` methods;
    - support the `scope` method with the `path` and `module` options;
    - support `host` constraint;

