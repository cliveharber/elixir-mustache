defmodule Mustache.Mixfile do
  use Mix.Project

  def project do
    [ app: :mustache,
      version: "0.0.1",
      elixir: "~> 1.0.0-rc2",
      deps: deps(Mix.env) ]
  end

  def application do
    []
  end

  defp deps(:spec) do
    [{:yamler, github: "voluntas/yamler"}]
     ++ deps(:test)
  end

  defp deps(_) do
    []
  end
end
