defmodule Alfred.ResultList do
  @moduledoc """
  Represents a list of `Alfred.Result` items.

  Since a result list can contain other information such as variables, it is useful sometimes to
  create an explicit list for results.
  """
  alias Alfred.Result

  @type t :: %__MODULE__{items: [Result.t], variables: %{optional(String.t) => String.t}}

  defstruct items: [], variables: %{}

  @doc """
  Creates a new list from a single `Result`.

  ## Examples

      iex> Alfred.ResultList.new(Alfred.Result.new("title", "subtitle"))
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"}]}
  """
  def new(item) when is_map(item), do: new([item])

  @doc """
  Creates a new list.

  ## Examples

  Creating a list of items.

      iex> result = Alfred.Result.new("title", "subtitle")
      iex> Alfred.ResultList.new([result, result, result])
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"}]}

  Creating a list of items and including variables.

      iex> result = Alfred.Result.new("title", "subtitle")
      iex> Alfred.ResultList.new([result, result, result], %{foo: "bar"})
      %Alfred.ResultList{items: [%Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"},
        %Alfred.Result{subtitle: "subtitle", title: "title"}],
       variables: %{foo: "bar"}}
  """
  def new(items \\ [], variables \\ %{}) do
    %__MODULE__{items: items, variables: variables}
  end

  @doc """
  Converts the given list to the
  [expected JSON output format](https://www.alfredapp.com/help/workflows/inputs/script-filter/json/).
  """
  def to_json(list) do
    list
    |> convert_result_list
    |> Poison.encode
  end

  defp convert_result_list(list) do
    case Enum.count(list.variables) do
      0 -> %{items: convert_items(list.items)}
      _ -> %{items: convert_items(list.items), variables: list.variables}
    end
  end

  defp convert_items(items) do
    Enum.map(items, fn(item) -> convert_item(item) end)
  end

  defp convert_item(struct) do
    Enum.reduce(Map.keys(struct), %{}, fn(key, map) ->
      case Map.get(struct, key) do
        nil -> map
        value -> Map.put(map, key, value)
      end
    end)
  end
end
