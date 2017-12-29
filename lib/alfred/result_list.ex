defmodule Alfred.ResultList do
  @moduledoc """
  Represents a list of `Alfred.Result` items.

  Since a result list can contain other information such as variables, it is useful sometimes to
  create an explicit list for results.
  """
  alias Alfred.Result

  @type t :: %__MODULE__{items: [Result.t], variables: %{optional(String.t) => String.t}, rerun: float | nil}

  defstruct items: [], rerun: nil, variables: %{}

  @doc """
  Creates a new list from a single `Result`.

  ## Examples

      iex> Alfred.ResultList.new(Alfred.Result.new("title", "subtitle"))
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"}]}
  """
  @spec new(Result.t) :: t
  def new(item) when is_map(item), do: new([item])

  @doc """
  Creates a new result list.

  ## Options

  * `:rerun` &mdash; Instructs Alfred to rerun the script every given number of seconds, must be
  between 1.0 and 5.0 inclusive
  * `:variables` &mdash; A `Map` of variables to return with the result list

  ## Examples

  Creating a list of items:

      iex> result = Alfred.Result.new("title", "subtitle")
      iex> Alfred.ResultList.new([result, result, result])
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"}]}

  Creating a list of items and including variables:

      iex> result = Alfred.Result.new("title", "subtitle")
      iex> Alfred.ResultList.new([result, result, result], variables: %{foo: "bar"})
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"}],
       variables: %{foo: "bar"}}

  Creating a list of items with variables and a rerun value:

      iex> result = Alfred.Result.new("title", "subtitle")
      iex> Alfred.ResultList.new([result, result, result], variables: %{foo: "bar"}, rerun: 3.0)
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"}],
       rerun: 3.0,
       variables: %{foo: "bar"}}
  """
  @spec new([Result.t], Keyword.t) :: t
  def new(items \\ [], options \\ []) when is_list(items) do
    variables = variables_option(options)
    rerun = rerun_option(options)

    %__MODULE__{items: items, variables: variables, rerun: rerun}
  end

  @doc """
  Converts the given list to the expected output format.

  See the Alfred documentation on [the JSON output format.][json-output]

  [json-output]: https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
  """
  @spec to_json(t) :: String.t
  def to_json(list) do
    list
    |> convert_result_list
    |> Poison.encode
  end

  defp convert_items(items) do
    Enum.map(items, fn(item) -> convert_item(item) end)
  end

  defp convert_result_list(list) do
    %{}
    |> insert_items(list)
    |> insert_variables(list)
    |> insert_rerun(list)
  end

  defp convert_item(struct) do
    Enum.reduce(Map.keys(struct), %{}, fn(key, map) ->
      case Map.get(struct, key) do
        nil -> map
        value -> Map.put(map, key, value)
      end
    end)
  end

  defp insert_items(map, %{items: items}) do
    Map.put(map, :items, convert_items(items))
  end

  defp insert_rerun(map, %{rerun: rerun}) do
    case rerun do
      nil -> map
      _ -> Map.put(map, :rerun, rerun)
    end
  end

  defp insert_variables(map, %{variables: variables}) do
    case Enum.count(variables) do
      0 -> map
      _ -> Map.put(map, :variables, variables)
    end
  end

  defp rerun_option(options) do
    options
    |> Keyword.get(:rerun)
    |> validate_rerun_option
  end

  defp validate_rerun_option(nil), do: nil

  defp validate_rerun_option(rerun) when not is_number(rerun) do
    raise ArgumentError, ":rerun must be a number or nil"
  end

  defp validate_rerun_option(rerun) when rerun < 1.0 or rerun > 5.0 do
    raise ArgumentError, ":rerun must be between 1.0 and 5.0 inclusive"
  end

  defp validate_rerun_option(rerun), do: rerun

  defp variables_option(options), do: Keyword.get(options, :variables, %{})
end
