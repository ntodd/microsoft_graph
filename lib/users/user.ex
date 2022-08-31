defmodule MicrosoftGraph.Users.User do
  @moduledoc """
  Users API.

  https://docs.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0
  """
  alias MicrosoftGraph.Request

  @doc """
  https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.User.list_users(client)
      {:ok, response}

      # Filter results
      iex> MicrosoftGraph.Users.User.list_users(client,
            params: %{"$filter" => "userType eq 'Member' and accountEnabled eq true"}
          )
      {:ok, response}

  """

  def list_users(client, options \\ []) do
    Request.get("/v1.0/users", options)
    |> Request.paginate_results()
    |> Request.execute(client)
  end

  @doc """
  https://docs.microsoft.com/en-us/graph/api/user-get?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.User.get_user(client, "1234...")
      {:ok, response}

      # With query params
      iex> MicrosoftGraph.Users.User.get_user(client, "1234...",
            params: %{
              "$select" => "displayName,id",
              "$filter" =>
                "identities/any(c:c/issuerAssignedId eq 'j.smith@yahoo.com' and c/issuer eq 'My B2C tenant'"
            }
          )
      {:ok, response}

  """
  def get_user(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}", options)
    |> Request.execute(client)
  end

  @doc """
  Create a user.

  https://docs.microsoft.com/en-us/graph/api/user-post-users?view=graph-rest-1.0&tabs=http

  ## Example:

      iex> MicrosoftGraph.Users.User.create_user(client,
            params: %{
              "accountEnabled" => true,
              "displayName" => "Adele Vance",
              "mailNickname" => "AdeleV",
              "userPrincipalName" => "AdeleV@contoso.onmicrosoft.com",
              "passwordProfile" => %{
                "forceChangePasswordNextSignIn" => true,
                "password" => "password1234"
              }
            }
          )
      {:ok, response}

  """
  def create_user(client, options \\ []) do
    Request.post("/v1.0/users", options)
    |> Request.execute(client)
  end
end
