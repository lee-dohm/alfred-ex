defmodule Alfred.Result do
  @moduledoc """
  Represents a result to be displayed in an Alfred search list.

  Every result is required to have a title and a subtitle. Beyond this, there are many optional
  attributes that are helpful in various scenarios:

  * `:arg` *(recommended)* &mdash; Text that is passed to connected output actions in workflows
  * `:autocomplete` *(recommended)* &mdash; Text which is populated into Alfred's search field if
    the user autocompletes the result
  * `:quicklookurl` &mdash; URL which will be visible if the user uses the Quick Look feature
  * `:uid` &mdash; Used to track an item across invocations so that Alfred can do its frecency sorting
  * `:valid` &mdash; When `false` it means that the result cannot be selected

  **See:** [Script Filter JSON Format](https://www.alfredapp.com/help/workflows/inputs/script-filter/json/)
  """

  alias Alfred.ResultList

  @type t :: %__MODULE__{arg: String.t, autocomplete: String.t, quicklookurl: String.t,
                         title: String.t, subtitle: String.t, uid: String.t, valid: boolean}

  defstruct [:title, :subtitle, :arg, :autocomplete, :quicklookurl, :uid, :valid]

  @doc """
  Creates a new generic result.

  ## Examples

  Basic result:

  ```
  iex> Alfred.Result.new("title", "subtitle")
  %Alfred.Result{subtitle: "subtitle", title: "title"}
  ```

  Result with some optional attributes:

  ```
  iex> Alfred.Result.new("title", "subtitle", arg: "output", valid: false, uid: "test")
  %Alfred.Result{arg: "output", subtitle: "subtitle", title: "title", uid: "test", valid: false}
  ```
  """
  @spec new(String.t, String.t, Keyword.t) :: t
  def new(title, subtitle, options \\ [])

  def new(nil, _, _), do: raise ArgumentError, "Result title is required"
  def new(_, nil, _), do: raise ArgumentError, "Result subtitle is required"

  def new(title, subtitle, options) do
    ensure_not_blank(title, :title)
    ensure_not_blank(subtitle, :subtitle)

    add_options(%__MODULE__{title: title, subtitle: subtitle}, options)
  end

  @doc """
  Creates a new URL result.

  ## Examples

  Basic URL result:

      iex> Alfred.Result.new_url("title", "http://www.example.com")
      %Alfred.Result{arg: "http://www.example.com", autocomplete: "title",
      quicklookurl: "http://www.example.com", subtitle: "http://www.example.com", title: "title",
      uid: "http://www.example.com", valid: nil}
  """
  @spec new_url(String.t, String.t) :: t
  def new_url(title, url), do: new(title, url, arg: url, autocomplete: title, quicklookurl: url, uid: url)

  @doc """
  Converts the results to the [expected JSON output format](https://www.alfredapp.com/help/workflows/inputs/script-filter/json/).
  """
  @spec to_json(t) :: String.t
  def to_json(results) do
    results
    |> ResultList.new
    |> ResultList.to_json
  end

  defp add_options(struct, []), do: struct
  defp add_options(struct, [{:uid, value} | rest]), do: add_options(add_uid_option(struct, value), rest)
  defp add_options(struct, [{:valid, value} | rest]), do: add_options(add_valid_option(struct, value), rest)
  defp add_options(struct, [{key, value} | rest]), do: add_options(Map.put(struct, key, value), rest)

  defp add_uid_option(struct, value) when is_binary(value), do: Map.put(struct, :uid, value)
  defp add_uid_option(_, _), do: raise ArgumentError, "uid must be a string value"

  defp add_valid_option(struct, true), do: struct
  defp add_valid_option(struct, false), do: Map.put(struct, :valid, false)
  defp add_valid_option(_, _), do: raise ArgumentError, "valid must be either true or false"

  defp ensure_not_blank(text, arg_name) do
    case String.trim(text) do
      "" -> raise ArgumentError, "#{arg_name} cannot be blank"
      _ -> nil
    end
  end
end
