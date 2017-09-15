defmodule Alfred.Result.Test do
  use ESpec
  doctest Alfred.Result

  alias Alfred.Result

  describe "constructing a basic result" do
    it "works" do
      result = Result.new("title", "subtitle")

      expect result |> to(be_struct Result)
      expect result.title |> to(eq "title")
      expect result.subtitle |> to(eq "subtitle")
    end

    it "requires a title" do
      expect fn -> Result.new(nil, "subtitle") end |> to(raise_exception ArgumentError)
    end

    it "requires title to not be blank" do
      expect fn -> Result.new("    ", "subtitle") end |> to(raise_exception ArgumentError)
    end

    it "requires a subtitle" do
      expect fn -> Result.new("title", nil) end |> to(raise_exception ArgumentError)
    end

    it "requires subtitle to not be blank" do
      expect fn -> Result.new("title", "    ") end |> to(raise_exception ArgumentError)
    end

    it "sets uid via options" do
      result = Result.new("title", "subtitle", uid: "uid")

      expect result |> to(be_struct Result)
      expect result.uid |> to(eq "uid")
    end

    it "sets arg via options" do
      result = Result.new("title", "subtitle", arg: "arg")

      expect result |> to(be_struct Result)
      expect result.arg |> to(eq "arg")
    end

    it "sets valid via options" do
      result = Result.new("title", "subtitle", valid: false)

      expect result |> to(be_struct Result)
      expect result.valid |> to(be_false())
    end

    it "requires valid to be a boolean value" do
      expect fn -> Result.new("title", "subtitle", valid: 5) end |> to(raise_exception ArgumentError)
    end

    it "requires uid to be a string value" do
      expect fn -> Result.new("title", "subtitle", uid: 5) end |> to(raise_exception ArgumentError)
    end
  end

  describe "constructing a URL result" do
    it "works" do
      result = Result.new_url("title", "http://www.example.com")

      expect result |> to(be_struct Result)
      expect result.title |> to(eq "title")
      expect result.subtitle |> to(eq "http://www.example.com")
      expect result.arg |> to(eq "http://www.example.com")
      expect result.uid |> to(eq "http://www.example.com")
      expect result.autocomplete |> to(eq "title")
      expect result.quicklookurl |> to(eq "http://www.example.com")
    end
  end

  describe "converting to JSON" do
    it "formats a single result properly" do
      result = Result.new("title", "subtitle")
      {:ok, json} = Result.to_json(result)

      expect json |> to(eq "{\"items\":[{\"title\":\"title\",\"subtitle\":\"subtitle\"}]}")
    end

    it "formats a list of results properly" do
      result = Result.new("title", "subtitle")
      {:ok, json} = Result.to_json([result, result, result])

      expect json |> to(eq "{\"items\":[{\"title\":\"title\",\"subtitle\":\"subtitle\"},{\"title\":\"title\",\"subtitle\":\"subtitle\"},{\"title\":\"title\",\"subtitle\":\"subtitle\"}]}")
    end
  end
end
