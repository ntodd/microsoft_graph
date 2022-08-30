defmodule MicrosoftGraph.Groups.Group do
  @moduledoc """
  https://docs.microsoft.com/en-us/graph/api/resources/groups-overview?view=graph-rest-1.0
  """
  alias MicrosoftGraph.Request

  @doc """
  List all groups.

  https://docs.microsoft.com/en-us/graph/api/group-list?view=graph-rest-1.0&tabs=http
  """
  def list_groups(client, options \\ []) do
    Request.get("/v1.0/groups", options)
    |> Request.paginate_results()
    |> Request.execute(client)
  end

  @doc """
  Get a group by its id.

  https://docs.microsoft.com/en-us/graph/api/group-get?view=graph-rest-1.0&tabs=http
  """
  def get_group(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}", options)
    |> Request.execute(client)
  end

  @doc """
  List all members of a group. To get all members recursively, use `list_transitive_members/3`.

  https://docs.microsoft.com/en-us/graph/api/group-list-members?view=graph-rest-1.0&tabs=http
  """
  def list_members(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}/members", options)
    |> Request.put_advanced_query_params()
    |> Request.paginate_results()
    |> Request.execute(client)
  end

  @doc """
  List all members of a group and all child groups.

  https://docs.microsoft.com/en-us/graph/api/group-list-transitivemembers?view=graph-rest-1.0&tabs=http
  """
  def list_transitive_members(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}/transitiveMembers", options)
    |> Request.put_advanced_query_params()
    |> Request.paginate_results()
    |> Request.execute(client)
  end
end
