defmodule MicrosoftGraph.Users.AppRoleAssignments do
  alias MicrosoftGraph.Request

  @doc """
  https://docs.microsoft.com/en-us/graph/api/user-list-approleassignments?view=graph-rest-1.0&tabs=http

  ## Examples

      iex> MicrosoftGraph.Users.AppRoleAssignments.list_app_role_assignments(client, "1234...")
      {:ok, response}

      # Filter by resourceId (Application ID)
      iex> MicrosoftGraph.Users.AppRoleAssignments.list_app_role_assignments(client, "1234...", params: %{"$filter" => "resourceId eq \#{application_id}"})
      {:ok, response}

  """
  def list_app_role_assignments(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}/appRoleAssignments", options)
    |> Request.execute(client)
  end
end
