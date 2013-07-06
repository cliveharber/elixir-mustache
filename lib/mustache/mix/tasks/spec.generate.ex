defmodule Mix.Tasks.Spec.Generate do
  use Mix.Task

  @spec_path Path.expand("../../../../spec", __DIR__)

  @template """
  ExUnit.start
  <%= Enum.map specs, fn({ name, tests }) -> %>
    defmodule Mustache.Spec.<%= name %>Test do
      use ExUnit.Case, async: true
      <%= Enum.map tests, fn(test) -> %>
        test "<%= test["name"] %>" do
          template = <%= inspect(test["template"]) %>
          data = <%= inspect(test["data"]) %>
          expected = <%= inspect(test["expected"]) %>

          assert Mustache.render(template, data) == expected
        end
      <% end %>
    end
  <% end %>
  """

  def run(_) do
    specs = extract_specs()
    content = EEx.eval_string(@template, [specs: specs])

    Path.join(@spec_path, "spec.exs") |> File.write(content)
  end

  def extract_specs do
    Path.wildcard(Path.join([@spec_path, "spec", "specs", "*.yml"]))
      |> Enum.reject(fn(x) -> Path.basename(x) =~ %r/^~/ end)
      |> Enum.map(extract_tests_from_file(&1))
  end

  def extract_tests_from_file(filename) do
    { :ok, [contents] } = :yaml.load_file(filename)

    { String.capitalize(Path.basename(filename, "yml")), contents["tests"] }
  end
end
