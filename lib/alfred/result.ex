defmodule Alfred.Result do
  @moduledoc """
  Represents a result to be displayed in an Alfred search list.

  **See:** [Script Filter JSON Format](https://www.alfredapp.com/help/workflows/inputs/script-filter/json/)
  """
  defstruct [:title, :subtitle]

  def new(title, subtitle, options \\ [])

  def new(nil, _, _), do: raise ArgumentError, "Result title is required"
  def new(_, nil, _), do: raise ArgumentError, "Result subtitle is required"

  def new(title, subtitle, options) do
    ensure_not_blank(title, :title)
    ensure_not_blank(subtitle, :subtitle)

    %__MODULE__{title: title, subtitle: subtitle}
    |> add_options(options)
  end

  defp add_options(struct, []), do: struct
  defp add_options(struct, [{:valid, value} | rest]), do: add_options(add_valid_option(struct, value), rest)
  defp add_options(struct, [{key, value} | rest]), do: add_options(Map.put(struct, key, value), rest)

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
