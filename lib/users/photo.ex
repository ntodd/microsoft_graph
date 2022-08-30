defmodule MicrosoftGraph.Users.Photo do
  alias MicrosoftGraph.Request

  @moduledoc """
  https://docs.microsoft.com/en-us/graph/api/resources/profilephoto?view=graph-rest-1.0
  """

  @doc """
  Returns the actual user photo binary data.

  ## Examples

      iex> Microsoft.Photo.get_photo(client, "user_id")
      {:ok, response}

  """

  def get_user_photo(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}/photo/$value", options)
    |> Request.execute(client)
  end

  @doc """
  Gets the data about a user's profile photo.

  ## Examples

      iex> Microsoft.Photo.get_user_photo_metadata(client, "user_id")
      {:ok, response}

  """
  def get_user_photo_metadata(client, id, options \\ []) do
    Request.get("/v1.0/users/#{URI.encode(id)}/photo", options)
    |> Request.execute(client)
  end
end
