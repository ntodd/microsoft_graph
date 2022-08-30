defmodule MicrosoftGraph.Users.Group do
  alias MicrosoftGraph.Request

  def list_groups(client, options \\ []) do
    Request.get("/v1.0/groups", options)
    |> Request.paginate_results()
    |> Request.execute(client)
  end

  def get_group(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}", options)
    |> Request.execute(client)
  end

  def list_members(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}/members", options)
    |> Request.put_advanced_query_params()
    |> Request.paginate_results()
    |> Request.execute(client)
  end

  def list_transitive_members(client, id, options \\ []) do
    Request.get("/v1.0/groups/#{id}/transitiveMembers", options)
    |> Request.put_advanced_query_params()
    |> Request.paginate_results()
    |> Request.execute(client)
  end
end
