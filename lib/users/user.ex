defmodule MicrosoftGraph.Users.User do
  alias MicrosoftGraph.Request

  @moduledoc """
  https://docs.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0
  """

  @doc """
  https://docs.microsoft.com/en-us/graph/api/user-list?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.User.list_users(client)
      {:ok, response}

      # Filter results
      iex> MicrosoftGraph.Users.User.list_users(client, params: %{"$filter" => "userType eq 'Member' and accountEnabled eq true"})
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

  """
  def get_user(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}", options)
    |> Request.execute(client)
  end
end
