defmodule Spec.Helpers do
  def fixture_path do
    Path.expand("fixtures", __DIR__)
  end

  def fixture_path(filename) do
    case Path.extname(filename) do
      "" -> Path.join(fixture_path(), filename <> ".exs")
      _ -> Path.join(fixture_path(), filename)
    end
  end

  def fixture(filename) do
    path = fixture_path(filename)

    case Path.extname(path) do
      ".exs" ->
        {result, _} = Code.eval_file(path)
        result
      _ ->
        path
        |> File.read!
        |> String.trim
    end
  end
end

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    {:shared, hello: :world, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
