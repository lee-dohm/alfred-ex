# Alfred

A library for interoperating with [Alfred](http://www.alfredapp.com), intended to make it easy to create tools and workflow extensions for Alfred in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `alfred` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:alfred, "~> 0.1.1"}]
end
```

## Development

This project follows the [GitHub "scripts to rule them all" pattern](http://githubengineering.com/scripts-to-rule-them-all/). The contents of the `script` directory are scripts that cover all common tasks:

* `script/bootstrap` &mdash; Installs all prerequisites for a development machine
* `script/test` &mdash; Runs automated tests
* `script/console` &mdash; Opens the development console
* `script/docs` &mdash; Generates developer documentation which can be opened at `doc/index.html`
* `script/publish` &mdash; Publishes a new version to [Hex](https://hex.pm)

## Copyright

Copyright &copy; 2017 by [Lee Dohm](http://www.lee-dohm.com). See [LICENSE](https://raw.githubusercontent.com/lee-dohm/alfred.ex/master/LICENSE.md) for details.
