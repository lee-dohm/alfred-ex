defmodule Alfred.ResultTest do
  use ExUnit.Case, async: true

  doctest Alfred.Result

  alias Alfred.Result

  import Test.Helpers

  describe "basic results" do
    test "happy path" do
      result = Result.new("title", "subtitle")

      assert %Result{} = result
      assert result.title == "title"
      assert result.subtitle == "subtitle"
    end

    test "title is required" do
      assert_raise ArgumentError, fn ->
        Result.new(nil, "subtitle")
      end
    end

    test "title cannot be blank" do
      assert_raise ArgumentError, fn ->
        Result.new("     ", "subtitle")
      end
    end

    test "subtitle is required" do
      assert_raise ArgumentError, fn ->
        Result.new("title", nil)
      end
    end

    test "subtitle cannot be blank" do
      assert_raise ArgumentError, fn ->
        Result.new("title", "     ")
      end
    end

    test "sets uid via options" do
      result = Result.new("title", "subtitle", uid: "uid")

      assert result.uid == "uid"
    end

    test "sets arg via options" do
      result = Result.new("title", "subtitle", arg: "arg")

      assert result.arg == "arg"
    end

    test "sets valid via options" do
      result = Result.new("title", "subtitle", valid: false)

      refute result.valid
    end

    test "requires valid to be a boolean value" do
      assert_raise ArgumentError, fn ->
        Result.new("title", "subtitle", valid: 5)
      end
    end

    test "requires uid to be a string value" do
      assert_raise ArgumentError, fn ->
        Result.new("title", "subtitle", uid: 5)
      end
    end
  end

  describe "URL results" do
    test "happy path" do
      result = Result.new_url("title", "http://example.com")

      assert %Result{} = result
      assert result.title == "title"
      assert result.subtitle == "http://example.com"
      assert result.arg == "http://example.com"
      assert result.uid == "http://example.com"
      assert result.autocomplete == "title"
      assert result.quicklookurl == "http://example.com"
    end
  end

  describe "JSON conversion" do
    test "hanldes a single result" do
      result = Result.new("title", "subtitle")
      {:ok, json} = Result.to_json(result)

      assert json == fixture("single-result.txt")
    end

    test "handles a list of results" do
      result = Result.new("title", "subtitle")
      {:ok, json} = Result.to_json([result, result, result])

      assert json == fixture("multiple-results.txt")
    end

    test "emits only keys with values that are not nil" do
      result = Result.new("title", "subtitle", uid: "foo", autocomplete: nil)
      {:ok, json} = Result.to_json(result)

      assert json == fixture("result-with-uid.txt")
    end
  end
end
