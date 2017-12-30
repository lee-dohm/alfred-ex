defmodule Alfred.Theme do
  @moduledoc """
  Contains Alfred theme information.

  * `background_color` &mdash; from environment `alfred_theme_background`
  * `id` &mdash; from environment `alfred_theme`
  * `selection_background_color` &mdash; from environment `alfred_theme_selection_background`
  * `subtext` &mdash; from environment `alfred_theme_subtext`

  See the [Alfred documentation on script environment variables][script-environment] for more
  information.

  [script-environment]: https://www.alfredapp.com/help/workflows/script-environment-variables/
  """
  defstruct [:id, :background_color, :selection_background_color, :subtext]

  @type t :: %__MODULE__{}

  def new do
    %__MODULE__{
      background_color: System.get_env("alfred_theme_background"),
      id: System.get_env("alfred_theme"),
      selection_background_color: System.get_env("alfred_theme_selection_background"),
      subtext: System.get_env("alfred_theme_subtext")
    }
  end
end
