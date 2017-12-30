defmodule Alfred do
  @moduledoc """
  A library for interoperating with [Alfred](http://www.alfredapp.com), intended to make it easy to
  create tools and workflow extensions for Alfred in Elixir.

  This module contains functions to access the
  [Alfred Script Environment variables][script-environment].

  [script-environment]: https://www.alfredapp.com/help/workflows/script-environment-variables/
  """

  alias Alfred.Preferences
  alias Alfred.Theme
  alias Alfred.Workflow

  @doc """
  Retrieves the Alfred version build number.

  From the environment variable `alfred_version_build`.
  """
  @spec build :: String.t
  def build do
    System.get_env("alfred_version_build")
  end

  @doc """
  Determines if Alfred is debugging the workflow.

  From the environment variable `alfred_debug`.
  """
  @spec debugging? :: boolean
  def debugging? do
    case System.get_env("alfred_debug") do
      "1" -> true
      _ -> false
    end
  end

  @doc """
  Retrieves the Alfred preferences information as `Alfred.Preferences`.
  """
  @spec preferences_info :: Preferences.t
  def preferences_info, do: Preferences.new()

  @doc """
  Retrieves the Alfred theme information as `Alfred.Theme`.
  """
  @spec theme_info :: Theme.t
  def theme_info, do: Theme.new()

  @doc """
  Gets the Alfred version running the workflow.

  Returns a `Version` containing the version information parsed from environment `alfred_version`.
  """
  @spec version :: Version.t
  def version do
    Version.parse!(version_text())
  end

  @doc """
  Gets the Alfred version text.

  From the environment `alfred_version`.
  """
  @spec version_text :: String.t
  def version_text do
    System.get_env("alfred_version")
  end

  @doc """
  Retrieves the Alfred workflow information as `Alfred.Workflow`.
  """
  @spec workflow_info :: Workflow.t
  def workflow_info, do: Workflow.new()
end
