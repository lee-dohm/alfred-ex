defmodule Alfred.ResultList.Spec do
  use ESpec
  doctest Alfred.ResultList

  alias Alfred.Result
  alias Alfred.ResultList
  import Spec.Helpers

  describe "construction" do
    it "can create an empty list" do
      list = ResultList.new

      expect list.items |> to(have_length 0)
      expect list.variables |> to(have_length 0)
    end

    it "can create a list when given only a single item" do
      list = ResultList.new(Result.new("title", "subtitle"))

      expect list.items |> to(have_length 1)
      expect list.variables |> to(have_length 0)
    end

    it "can create a list of Result items" do
      item = Result.new("title", "subtitle")
      list = ResultList.new([item, item, item])

      expect list.items |> to(have_length 3)
      expect list.variables |> to(have_length 0)
    end

    it "can create a list with variables" do
      item = Result.new("title", "subtitle")
      variables = %{"foo": "bar", "bar": "baz", "baz": "quux"}
      list = ResultList.new([item, item, item], variables)

      expect list.items |> to(have_length 3)
      expect list.variables |> to(have_length 3)
    end
  end

  describe "JSON serialization" do
    it "works" do
      item = Result.new("title", "subtitle")
      variables = %{"foo": "bar", "bar": "baz", "baz": "quux"}
      list = ResultList.new([item, item, item], variables)
      {:ok, json} = ResultList.to_json(list)

      expect json |> to(eq fixture("results-with-variables.txt"))
    end

    it "does not emit the variables key when no variables are present" do
      item = Result.new("title", "subtitle")
      list = ResultList.new([item, item, item])
      {:ok, json} = ResultList.to_json(list)

      expect json |> to(eq fixture("multiple-results.txt"))
    end
  end
end
