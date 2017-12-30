defmodule Alfred.Workflow do
  @moduledoc """
  Contains Alfred workflow information.

  * `bundleid` &mdash; from environment `alfred_workflow_bundleid`
  * `cache_path` &mdash; from environment `alfred_workflow_cache`
  * `data_path` &mdash; from environment `alfred_workflow_data`
  * `name` &mdash; from environment `alfred_workflow_name`
  * `uid` &mdash; from environment `alfred_workflow_uid`
  * `version` &mdash; the information from `:version_text` parsed into a `Version` struct
  * `version_text` &mdash; from environment `alfred_workflow_version`

  See the [Alfred documentation on script environment variables][script-environment] for more
  information.

  [script-environment]: https://www.alfredapp.com/help/workflows/script-environment-variables/
  """
  defstruct [:bundleid, :cache_path, :data_path, :name, :uid, :version, :version_text]

  @type t :: %__MODULE__{}

  def new do
    version = System.get_env("alfred_workflow_version")

    %__MODULE__{
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
