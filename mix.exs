defmodule GhApp2.MixProject do
  use Mix.Project

  def project do
    [
      app: :gh_app2,
      version: "0.1.0",
      elixir: "~> 1.10",
      deps: deps()
    ]
  end

  # SCA - Elixir/Hex packages with known vulnerabilities
  defp deps do
    [
      # Phoenix - CVE-2020-5272 - open redirect
      {:phoenix, "~> 1.4.0"},

      # Plug - CVE-2021-39175 - header injection
      {:plug, "~> 1.9.0"},

      # Ecto SQL - SQLi via raw fragments
      {:ecto_sql, "~> 3.3.0"},

      # Poison JSON - DoS via deeply nested input
      {:poison, "~> 3.1"},

      # Hex Package - CVE-2019-14275 - path traversal
      {:plug_cowboy, "~> 2.1.0"},

      # ExAws - credentials exposure via debug logs
      {:ex_aws, "~> 2.1.0"},

      # Guardian (JWT) - weak secret handling
      {:guardian, "~> 1.2.0"},

      # Comeonin - deprecated bcrypt library
      {:comeonin, "~> 4.0"},

      # HTTPoison - SSRF via user-controlled URLs
      {:httpoison, "~> 1.6.0"},

      # Swoosh - email header injection
      {:swoosh, "~> 0.25"},

      # Timex - CVE-2022-24880 - regex DoS
      {:timex, "~> 3.5.0"},

      # Absinthe GraphQL - CVE-2021-41149 - DoS via complex queries
      {:absinthe, "~> 1.4.0"},

      # Commanded - insecure event sourcing defaults
      {:commanded, "~> 1.2.0"},

      # Distillery - outdated release tool with known issues
      {:distillery, "~> 2.0"}
    ]
  end
end
