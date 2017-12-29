defmodule Alfred.ResultListTest do
  use ExUnit.Case, async: true

  doctest Alfred.ResultList

  alias Alfred.Result
  alias Alfred.ResultList

  import Test.Helpers

  setup do
    result = Result.new("title", "subtitle")

    {
      :ok,
      result: result,
      result_list: [result, result, result],
      variables: %{"foo": "bar", "bar": "baz", "baz": "quux"}
    }
  end

  describe "construction" do
    test "creates an empty list" do
      list = ResultList.new

      assert length(list.items) == 0
      assert list.variables == %{}
    end

    test "creates a list when given a single item", %{result: result} do
      list = ResultList.new(result)

      assert list.items == [result]
    end

    test "raises an error when given a single item that isn't a Result" do
      assert_raise ArgumentError, fn ->
        ResultList.new(5)
      end
    end

    test "creates a list of result items", %{result_list: result_list} do
      list = ResultList.new(result_list)

      assert list.items == result_list
    end

    test "creates a list with variables", %{result_list: result_list, variables: variables} do
      list = ResultList.new(result_list, variables: variables)

      assert list.variables |> Map.keys |> Enum.count == 3
      assert list.variables.foo == "bar"
      assert list.variables.bar == "baz"
      assert list.variables.baz == "quux"
    end

    test "creates a list with a rerun value", %{result_list: result_list} do
      list = ResultList.new(result_list, rerun: 3.0)

      assert list.rerun == 3.0
    end

    test "raises an error if rerun is not a number", %{result_list: result_list} do
      assert_raise ArgumentError, fn ->
        ResultList.new(result_list, rerun: "foo")
      end
    end

    test "raises an error if rerun is less than 1.0 or greater than 5.0", %{result_list: result_list} do
      assert_raise ArgumentError, fn ->
        ResultList.new(result_list, rerun: 0.5)
      end

      assert_raise ArgumentError, fn ->
        ResultList.new(result_list, rerun: 5.5)
      end
    end
  end

  describe "JSON serialization" do
    test "happy path", %{result_list: result_list, variables: variables} do
      list = ResultList.new(result_list, variables: variables, rerun: 3.0)
      {:ok, json} = ResultList.to_json(list)

      assert json == fixture("results-with-variables-and-rerun.txt")
    end

    test "does not emit the variables key when no variables are present", %{result_list: result_list} do
      list = ResultList.new(result_list)
      {:ok, json} = ResultList.to_json(list)

      assert json == fixture("multiple-results.txt")
    end

    test "does not emit the rerun key when no rerun is present", %{result_list: result_list, variables: variables} do
      list = ResultList.new(result_list, variables: variables)
      {:ok, json} = ResultList.to_json(list)

      assert json == fixture("results-with-variables.txt")
    end
  end
end
