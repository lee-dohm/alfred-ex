defmodule Alfred.ResultList.Spec do
  use ESpec
  doctest Alfred.ResultList

  alias Alfred.Result
  alias Alfred.ResultList
  import Spec.Helpers

  describe "construction" do
    it "creates an empty list" do
      list = ResultList.new

      expect list.items |> to(have_length 0)
      expect list.variables |> to(have_length 0)
    end

    it "creates a list when given only a single item" do
      list = ResultList.new(Result.new("title", "subtitle"))

      expect list.items |> to(have_length 1)
      expect list.variables |> to(have_length 0)
    end

    it "creates a list of Result items" do
      item = Result.new("title", "subtitle")
      list = ResultList.new([item, item, item])

      expect list.items |> to(have_length 3)
      expect list.variables |> to(have_length 0)
    end

    it "creates a list with variables" do
      item = Result.new("title", "subtitle")
      variables = %{"foo": "bar", "bar": "baz", "baz": "quux"}
      list = ResultList.new([item, item, item], variables)

      expect list.items |> to(have_length 3)
      expect list.variables |> to(have_length 3)
    end

    it "creates a list with a rerun value" do
      item = Result.new("title", "subtitle")
      variables = %{foo: "bar"}
      list = ResultList.new([item, item, item], variables, rerun: 3.0)

      expect list.items |> to(have_length 3)
      expect list.variables |> to(have_length 1)
      expect list.rerun |> to(eq 3.0)
    end

    it "throws an error if the rerun value is not a number" do
      item = Result.new("title", "subtitle")

      expect fn -> ResultList.new([item], %{}, rerun: "foo") end |> to(raise_exception ArgumentError)
    end

    it "throws an error if the rerun value is less than 1.0 or greater than 5.0" do
      item = Result.new("title", "subtitle")

      expect fn -> ResultList.new([item], %{}, rerun: -1.0) end |> to(raise_exception ArgumentError)
      expect fn -> ResultList.new([item], %{}, rerun: 10.0) end |> to(raise_exception ArgumentError)
    end
  end

  describe "JSON serialization" do
    it "works" do
      item = Result.new("title", "subtitle")
      variables = %{"foo": "bar", "bar": "baz", "baz": "quux"}
      list = ResultList.new([item, item, item], variables, rerun: 3.0)
      {:ok, json} = ResultList.to_json(list)

      expect json |> to(eq fixture("results-with-variables-and-rerun.txt"))
    end

    it "does not emit the variables key when no variables are present" do
      item = Result.new("title", "subtitle")
      list = ResultList.new([item, item, item])
      {:ok, json} = ResultList.to_json(list)

      expect json |> to(eq fixture("multiple-results.txt"))
    end

    it "does not emit the rerun key when no rerun is present" do
      item = Result.new("title", "subtitle")
      variables = %{"foo": "bar", "bar": "baz", "baz": "quux"}
      list = ResultList.new([item, item, item], variables)
      {:ok, json} = ResultList.to_json(list)

      expect json |> to(eq fixture("results-with-variables.txt"))
    end
  end
end
