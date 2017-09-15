defmodule Alfred.Test do
  use ESpec
  doctest Alfred

  before do
    {:shared, original_env: System.get_env()}
  end

  finally do
    System.put_env(shared.original_env)
  end

  describe "environment variables" do
    it "sets debugging to true when alfred_debug is equal to 1" do
      System.put_env("alfred_debug", "1")

      expect Alfred.debugging?() |> to(be_true())
    end

    it "sets debugging to false when alfred_debug is anything other than 1" do
      System.put_env("alfred_debug", "blahblahblah")

      expect Alfred.debugging?() |> to(be_false())
    end

    it "sets preferences info" do
      System.put_env("alfred_preferences", "something-interesting")
      System.put_env("alfred_preferences_localhash", "somehash")

      expect Alfred.preferences_info().path |> to(eq "something-interesting")
      expect Alfred.preferences_info().localhash |> to(eq "somehash")
    end

    it "sets theme info" do
      System.put_env("alfred_theme", "alfred.theme.custom.72EAAF2D-63D3-4398-958B-118E7AC63990")
      System.put_env("alfred_theme_background", "rgba(255,255,255,1.0)")
      System.put_env("alfred_theme_selection_background", "rgba(255,255,255,1.0)")
      System.put_env("alfred_theme_subtext", "0")

      expect Alfred.theme_info().id |> to(eq "alfred.theme.custom.72EAAF2D-63D3-4398-958B-118E7AC63990")
      expect Alfred.theme_info().background_color |> to(eq "rgba(255,255,255,1.0)")
      expect Alfred.theme_info().selection_background_color |> to(eq "rgba(255,255,255,1.0)")
      expect Alfred.theme_info().subtext |> to(eq "0")
    end

    it "sets the version number" do
      System.put_env("alfred_version", "1.2.3")

      expect Alfred.version().major |> to(eq 1)
      expect Alfred.version().minor |> to(eq 2)
      expect Alfred.version().patch |> to(eq 3)
    end

    it "sets the version text" do
      System.put_env("alfred_version", "1.2.3")

      expect Alfred.version_text() |> to(eq "1.2.3")
    end

    it "sets the build number" do
      System.put_env("alfred_version_build", "456")

      expect Alfred.build() |> to(eq "456")
    end

    it "sets the workflow info" do
      System.put_env("alfred_workflow_bundleid", "com.lee-dohm.alfred")
      System.put_env("alfred_workflow_cache", "some-path")
      System.put_env("alfred_workflow_data", "some-other-path")
      System.put_env("alfred_workflow_name", "thingy")
      System.put_env("alfred_workflow_uid", "user.workflow.FBD12E54-39DE-4177-8907-402AD2CE37C2")
      System.put_env("alfred_workflow_version", "7.8.9")

      expect Alfred.workflow_info().bundleid |> to(eq "com.lee-dohm.alfred")
      expect Alfred.workflow_info().cache_path |> to(eq "some-path")
      expect Alfred.workflow_info().data_path |> to(eq "some-other-path")
      expect Alfred.workflow_info().name |> to(eq "thingy")
      expect Alfred.workflow_info().uid |> to(eq "user.workflow.FBD12E54-39DE-4177-8907-402AD2CE37C2")
      expect Alfred.workflow_info().version.major |> to(eq 7)
      expect Alfred.workflow_info().version.minor |> to(eq 8)
      expect Alfred.workflow_info().version.patch |> to(eq 9)
      expect Alfred.workflow_info().version_text |> to(eq "7.8.9")
    end
  end
end
