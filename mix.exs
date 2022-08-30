defmodule MicrosoftGraph.MixProject do
  use Mix.Project

  def project do
    [
      app: :microsoft_graph,
      name: "Microsoft Graph API Client",
      description: "Microsoft Graph API client",
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauth2, "~> 2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Nate Todd"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ntodd/microsoft_graph"}
    ]
  end
end
