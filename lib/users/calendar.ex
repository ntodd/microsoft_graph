defmodule MicrosoftGraph.Users.Calendar do
  @moduledoc """
  https://docs.microsoft.com/en-us/graph/api/resources/calendar?view=graph-rest-1.0
  """
  alias MicrosoftGraph.Request

  @doc """
  https://docs.microsoft.com/en-us/graph/api/calendar-getschedule?view=graph-rest-1.0&tabs=http

  ## Examples

      # Params are required for this endpoint
      iex> MicrosoftGraph.Users.Calendar.get_schedule(client, "user_id")
      {:error, response}

      iex> MicrosoftGraph.Users.Calendar.get_schedule(client, "user_id", params: %{
        schedules: ["user_email"],
        startTime: %{
          dateTime: NaiveDateTime.utc_now(),
          timeZone: "UTC"
        },
        endTime: %{
          dateTime: NaiveDateTime.utc_now() |> NaiveDateTime.add(3600, :second),
          timeZone: "UTC"
        },
        availabilityViewInterval: 15
      })
      {:ok, response}

  """
  def get_schedule(client, id, options \\ []) do
    Request.post("/v1.0/users/#{URI.encode(id)}/calendar/getSchedule", options)
    |> Request.execute(client)
  end
end
