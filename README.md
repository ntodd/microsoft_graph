# Microsoft Graph API Client for Elixir

[![CI](https://github.com/ntodd/microsoft_graph/actions/workflows/build.yml/badge.svg)](https://github.com/ntodd/microsoft_graph/actions/workflows/build.yml)

**Work in progress** - do not use unless you want things to break

Documentation can be found at <https://hexdocs.pm/microsoft_graph>.

## Installation

```elixir
# mix.exs

def deps do
  [
    {:microsoft_graph, "~> 0.2.0"}
  ]
end
```

You should also configure an OAuth2 adapter in your application config or Tesla
will attempt to use httpc with **insecure defaults**. Modern Phoenix
applications come with [Finch](https://github.com/sneako/finch) pre-configured, so it is a good option.

```elixir
# config.exs

config :oauth2, adapter: {Tesla.Adapter.Finch, name: MyApp.Finch}
```
