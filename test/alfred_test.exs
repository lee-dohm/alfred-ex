defmodule AlfredTest do
  use ExUnit.Case, async: true

  doctest Alfred

  setup do
    original_env = System.get_env()

    on_exit fn ->
      System.put_env(original_env)
    end

    [original_env: original_env]
  end

  describe "environment variables" do
    test "debugging is true when alfred_debug is equal to 1" do
      System.put_env("alfred_debug", "1")

      assert Alfred.debugging?()
    end

    test "debugging is false when alfred_debug is set to anything other than 1" do
      System.put_env("alfred_debug", "blah blah blah")

      refute Alfred.debugging?()
    end

    test "preferences info" do
      System.put_env("alfred_preferences", "something-interesting")
      System.put_env("alfred_preferences_localhash", "somehash")

      assert Alfred.preferences_info() == %{path: "something-interesting", localhash: "somehash"}
    end

    test "theme info" do
      System.put_env("alfred_theme", "alfred.theme.custom.72EAAF2D-63D3-4398-958B-118E7AC63990")
      System.put_env("alfred_theme_background", "rgba(255,255,255,1.0)")
      System.put_env("alfred_theme_selection_background", "rgba(255,255,255,1.0)")
      System.put_env("alfred_theme_subtext", "0")

      info = Alfred.theme_info()

      assert info.id == "alfred.theme.custom.72EAAF2D-63D3-4398-958B-118E7AC63990"
      assert info.background_color == "rgba(255,255,255,1.0)"
      assert info.selection_background_color == "rgba(255,255,255,1.0)"
      assert info.subtext == "0"
    end

    test "version number" do
      System.put_env("alfred_version", "1.2.3")

      version = Alfred.version()

      assert %Version{} = version
      assert version.major == 1
      assert version.minor == 2
      assert version.patch == 3
    end

    test "version text" do
      System.put_env("alfred_version", "1.2.3")

      assert Alfred.version_text() == "1.2.3"
    end

    test "build number" do
      System.put_env("alfred_version_build", "456")

      assert Alfred.build() == "456"
    end

    test "workflow info" do
      System.put_env("alfred_workflow_bundleid", "com.lee-dohm.alfred")
      System.put_env("alfred_workflow_cache", "some-path")
      System.put_env("alfred_workflow_data", "some-other-path")
      System.put_env("alfred_workflow_name", "thingy")
      System.put_env("alfred_workflow_uid", "user.workflow.FBD12E54-39DE-4177-8907-402AD2CE37C2")
      System.put_env("alfred_workflow_version", "7.8.9")

      info = Alfred.workflow_info()

      assert info.bundleid == "com.lee-dohm.alfred"
      assert info.cache_path == "some-path"
      assert info.data_path == "some-other-path"
      assert info.name == "thingy"
      assert info.uid == "user.workflow.FBD12E54-39DE-4177-8907-402AD2CE37C2"
      assert %Version{} = info.version
      assert info.version.major == 7
      assert info.version.minor == 8
      assert info.version.patch == 9
      assert info.version_text == "7.8.9"
    end
  end
end
