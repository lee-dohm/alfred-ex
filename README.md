# Alfred

[![Hex Version](https://img.shields.io/hexpm/v/alfred.svg)](https://hex.pm/packages/alfred)
[![API Docs](https://img.shields.io/badge/api-docs-green.svg)](https://hexdocs.pm/alfred/)
[![License](https://img.shields.io/github/license/lee-dohm/alfred.ex.svg)](https://github.com/lee-dohm/alfred.ex/blob/master/LICENSE.md)
[![Ebert](https://ebertapp.io/github/lee-dohm/alfred-ex.svg)](https://ebertapp.io/github/lee-dohm/alfred-ex)

A library for interoperating with [Alfred](http://www.alfredapp.com), intended to make it easy to create tools and workflow extensions for Alfred in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `alfred` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alfred, "~> 0.3.0"}
  ]
end
```

## Development

This project follows the [GitHub "scripts to rule them all" pattern](http://githubengineering.com/scripts-to-rule-them-all/). The contents of the `script` directory are scripts that cover all common tasks:

* `script/bootstrap` &mdash; Installs all prerequisites for a development machine
* `script/test` &mdash; Runs automated tests
* `script/console` &mdash; Opens the development console
* `script/docs` &mdash; Generates developer documentation which can be opened at `doc/index.html`
* `script/publish` &mdash; Publishes a new version to [Hex](https://hex.pm)

## License

[MIT](https://raw.githubusercontent.com/lee-dohm/alfred.ex/master/LICENSE.md)
