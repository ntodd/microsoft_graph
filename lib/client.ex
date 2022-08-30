defmodule MicrosoftGraph.Client do
  @moduledoc """
  Client for the Microsoft Graph API.

  ## Usage

      client = MicrosoftGraph.Client.client("client_id", "client_secret", "tenant_id")
      |> MicrosoftGraph.Client.get_token!(scope: "https://graph.microsoft.com/.default")

      MicrosoftGraph.Users.User.list_users(client)
      # {:ok, response}

      MicrosoftGraph.Users.Photo.get_user_photo(client, "user_id")
      # {:ok, response}

  """

  @doc """
  Create a new Microsoft Graph API client.

  ## Examples:

      iex> Microsoft.client("client_id", "client_secret", "tenant_id")
      %OAuth2.Client{}

      # Use an existing Ueberauth config
      iex> Microsoft.client(Application.get_env(:ueberauth, Ueberauth.Strategy.Microsoft.OAuth))
      %OAuth2.Client{}

  """
  def client(config) when is_list(config) do
    client(
      Keyword.get(config, :client_id),
      Keyword.get(config, :client_secret),
      Keyword.get(config, :tenant_id)
    )
  end

  def client(client_id, client_secret, tenant_id) do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.ClientCredentials,
      site: "https://graph.microsoft.com",
      client_id: client_id,
      client_secret: client_secret,
      token_url: "https://login.microsoftonline.com/#{tenant_id}/oauth2/v2.0/token",
      request_opts: [
        ssl_options: [
          versions: [:"tlsv1.2"],
          verify: :verify_peer,
          cacertfile: :certifi.cacertfile()
        ]
      ]
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  @doc """
  Default scope string helper
  """
  def default_scope(), do: "https://graph.microsoft.com/.default"

  @doc """
  Gets a token and puts the correct json header for the API
  """
  def get_token!(client, params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client, params, headers, opts)
    |> OAuth2.Client.put_header(
      "content-type",
      "application/json;odata.metadata=minimal;odata.streaming=true;IEEE754Compatible=false"
    )
  end
end
