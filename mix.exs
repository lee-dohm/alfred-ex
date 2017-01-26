defmodule Alfred.Mixfile do
  use Mix.Project

  @version String.trim(File.read!("VERSION.md"))

  def project do
    [
      name: "Alfred",
      source_url: "https://github.com/lee-dohm/alfred.ex",
      app: :alfred,
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: "Library for integrating with Alfred: http://www.alfredapp.com",
      deps: deps(),
      docs: docs(),
      package: package()
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
      {:ex_doc, "~> 0.14.5", only: :dev}
    ]
  end

  def docs do
    [
      extras: ["README.md", "LICENSE.md"],
      main: "Alfred"
    ]
  end

  def package do
    [
      files: [
        "lib",
        "priv",
        "mix.exs",
        "README*",
        "readme*",
        "LICENSE*",
        "license*",
        "CHANGELOG*",
        "changelog*",
        "src",
        "VERSION*",
        "version*"
      ],
      licenses: ["MIT"],
      maintainers: ["Lee Dohm"],
      links: %{"GitHub" => "https://github.com/lee-dohm/alfred.ex"}
    ]
  end
end
