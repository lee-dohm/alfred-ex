defmodule Alfred do
  @moduledoc """
  A library for interoperating with [Alfred](http://www.alfredapp.com), intended to make it easy to
  create tools and workflow extensions for Alfred in Elixir.
  """

  @type preferences :: %{localhash: String.t, path: String.t}
  @type theme :: %{background_color: String.t, id: String.t, selection_background_color: String.t, subtext: String.t}
  @type workflow :: %{bundleid: String.t, cache_path: String.t, data_path: String.t, name: String.t, uid: String.t, version: Version.t, version_text: String.t}

  @doc """
  Retrieves the Alfred version build number.
  """
  @spec build :: String.t
  def build do
    System.get_env("alfred_version_build")
  end

  @doc """
  Determines if Alfred is debugging the workflow.
  """
  @spec debugging? :: boolean
  def debugging? do
    case System.get_env("alfred_debug") do
      "1" -> true
      _ -> false
    end
  end

  @doc """
  Retrieves the Alfred preferences information.

  Returns a map with the following keys:

  * `:path`
  * `:localhash`
  """
  @spec preferences_info :: preferences
  def preferences_info do
    %{
      path: System.get_env("alfred_preferences"),
      localhash: System.get_env("alfred_preferences_localhash")
    }
  end

  @doc """
  Retrieves the Alfred theme information.

  Returns a map with the following keys:

  * `:background_color`
  * `:id`
  * `:selection_background_color`
  * `:subtext`
  """
  @spec theme_info :: theme
  def theme_info do
    %{
      background_color: System.get_env("alfred_theme_background"),
      id: System.get_env("alfred_theme"),
      selection_background_color: System.get_env("alfred_theme_selection_background"),
      subtext: System.get_env("alfred_theme_subtext")
    }
  end

  @doc """
  Gets the Alfred version running the workflow.

  Returns a `Version` containing the version information.
  """
  @spec version :: Version.t
  def version do
    Version.parse!(version_text())
  end

  @doc """
  Gets the Alfred version text.
  """
  @spec version_text :: String.t
  def version_text do
    System.get_env("alfred_version")
  end

  @doc """
  Retrieves the Alfred workflow information.

  Returns a map with the following keys:

  * `:bundleid`
  * `:cache_path`
  * `:data_path`
  * `:name`
  * `:uid`
  * `:version`
  * `:version_text`
  """
  @spec workflow_info :: workflow
  def workflow_info do
    version = System.get_env("alfred_workflow_version")

    %{
      bundleid: System.get_env("alfred_workflow_bundleid"),
      cache_path: System.get_env("alfred_workflow_cache"),
      data_path: System.get_env("alfred_workflow_data"),
      name: System.get_env("alfred_workflow_name"),
      uid: System.get_env("alfred_workflow_uid"),
      version: Version.parse!(version),
      version_text: version
    }
  end
end
