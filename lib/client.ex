defmodule MicrosoftGraph.Client do
  @moduledoc """
  Client for the [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/use-the-api).

  ## Usage

      client = Microsoft.Client.create("client_id", "client_secret", "tenant_id")
      |> MicrosoftGraph.Client.get_token!(scope: "https://graph.microsoft.com/.default")

      MicrosoftGraph.Users.User.list_users(client)
      # {:ok, response}

      MicrosoftGraph.Users.Photo.get_user_photo(client, "user_id")
      # {:ok, response}

  """

  @doc """
  Creates a new `%OAuth2.Client{}` struct configured for the Microsoft Graph API
  with an Ueberauth config.

  ## Example:

      iex> Microsoft.Client.create(Application.get_env(:ueberauth, Ueberauth.Strategy.Microsoft.OAuth))
      %OAuth2.Client{}

  """
  def create(config) when is_list(config) do
    create(
      Keyword.get(config, :client_id),
      Keyword.get(config, :client_secret),
      Keyword.get(config, :tenant_id)
    )
  end

  @doc """
  Creates a new `%OAuth2.Client{}` struct configured for the Microsoft Graph API.
  ## Examples:

      iex> Microsoft.Client.create("client_id", "client_secret", "tenant_id")
      %OAuth2.Client{}

  """
  def create(client_id, client_secret, tenant_id)
      when is_binary(client_id) and is_binary(client_secret) and is_binary(tenant_id) do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.ClientCredentials,
      site: "https://graph.microsoft.com",
      client_id: client_id,
      client_secret: client_secret,
      token_url: "https://login.microsoftonline.com/#{tenant_id}/oauth2/v2.0/token"
    )
    |> OAuth2.Client.put_serializer("application/json", Jason)
  end

  @doc """
  Default scope string helper.

  https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#the-default-scope
  """
  def default_scope(), do: "https://graph.microsoft.com/.default"

  @doc """
  Gets a token and puts the correct json header for the API.

  ## Example

      # Returns a client with a valid access token
      iex> MicrosoftGraph.Client.get_token!(%OAuth2.Client{})
      %OAuth2.Client{}

  """
  def get_token!(client, params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client, params, headers, opts)
    |> OAuth2.Client.put_header(
      "content-type",
      "application/json;odata.metadata=minimal;odata.streaming=true;IEEE754Compatible=false"
    )
  end
end
