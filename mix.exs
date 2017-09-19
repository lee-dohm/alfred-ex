defmodule Alfred.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("VERSION.md"))

  def project do
    [
      name: "Alfred",
      source_url: "https://github.com/lee-dohm/alfred-ex",
      app: :alfred,
      version: @version,
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: "Library for integrating with Alfred: http://www.alfredapp.com",
      deps: deps(),
      docs: docs(),
      package: package(),
      preferred_cli_env: [espec: :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def deps do
    [
      {:poison, "~> 3.1"},
      {:cmark, "> 0.0.0", only: :dev},
      {:ex_doc, "> 0.0.0", only: :dev, runtime: false},
      {:espec, "~> 1.4.6", only: :test}
    ]
  end

  def docs do
    [
      extras: ["README.md", "LICENSE.md", "CHANGELOG.md", "CODE_OF_CONDUCT.md"],
      main: "Alfred"
    ]
  end

  def package do
    [
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*",
        "CHANGELOG*",
        "CODE_OF_CONDUCT*",
        "VERSION*"
      ],
      licenses: ["MIT"],
      maintainers: ["Lee Dohm"],
      links: %{"GitHub" => "https://github.com/lee-dohm/alfred-ex"}
    ]
  end
end
