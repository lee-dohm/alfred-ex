defmodule Alfred.Preferences do
  @moduledoc """
  Contains Alfred preferences information.

  * `localhash` &mdash; From `alfred_preferences_localhash`
  * `path` &mdash; From `alfred_preferences`

  See the [Alfred documentation on script environment variables][script-environment] for more
  information.

  [script-environment]: https://www.alfredapp.com/help/workflows/script-environment-variables/
  """
  defstruct [:localhash, :path]

  @type t :: %__MODULE__{}

  def new do
    %__MODULE__{
      localhash: System.get_env("alfred_preferences_localhash"),
      path: System.get_env("alfred_preferences")
    }
  end
end
