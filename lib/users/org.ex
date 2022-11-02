defmodule MicrosoftGraph.Users.Org do
  alias MicrosoftGraph.Request

  @doc """
  List direct reports for given user.

  https://learn.microsoft.com/en-us/graph/api/user-list-directreports?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.Org.list_direct_reports(client, "user_id")
      {:ok, response}

  """
  def list_direct_reports(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}/directReports", options)
    |> Request.execute(client)
  end

  @doc """
  List direct manager for given user.

  https://learn.microsoft.com/en-us/graph/api/user-list-manager?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.Org.get_manager(client, "user_id")
      {:ok, response}

  """
  def get_manager(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}/manager", options)
    |> Request.execute(client)
  end

  @doc """
  List all managers recursively for given user.

  https://learn.microsoft.com/en-us/graph/api/user-list-manager?view=graph-rest-1.0&tabs=http

  ## Examples

      # At a minimum, `$expand=manager($levels=max;)` is required
      iex> MicrosoftGraph.Users.Org.get_manager(client, "user_id",
        params: %{"$expand" => "manager($levels=max;)"}
      )
      {:ok, response}

      iex> MicrosoftGraph.Users.Org.get_manager(client, "user_id",
        params: %{
          "$expand" => "manager($levels=max;$select=id,displayName)",
          "$select" => "id,displayName",
          "$count" => true
        }
      )
      {:ok, response}

  """
  def get_all_managers(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}", options)
    |> Request.put_advanced_query_params()
    |> Request.execute(client)
  end

  @doc """
  Assign direct manager for given user.

  https://learn.microsoft.com/en-us/graph/api/user-post-manager?view=graph-rest-1.0&tabs=http

  ## Examples

      # $ref is passed in as the @odata.id
      iex> MicrosoftGraph.Users.Org.assign_manager(client, "user_id",
        params: %{
          "@odata.id": "https://graph.microsoft.com/v1.0/users/6ea91a8d-e32e-41a1-b7bd-d2d185eed0e0"
        }
      )
      {:ok, response}

  """
  def assign_manager(client, id, options \\ []) do
    Request.put("/v1.0/users/#{URI.encode(id)}/manager/$ref", options)
    |> Request.execute(client)
  end
end
