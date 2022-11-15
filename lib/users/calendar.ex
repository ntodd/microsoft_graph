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

  @doc """
  https://learn.microsoft.com/en-us/graph/api/user-findmeetingtimes?view=graph-rest-1.0&tabs=http

  ## Examples

      # Params are required for this endpoint
      iex> MicrosoftGraph.Users.Calendar.find_meeting_times(client, "user_id")
      {:error, response}

      iex> MicrosoftGraph.Users.Calendar.find_meeting_times(client, "user_id", params: %{
        "attendees": [
              %{
                  "emailAddress": %{
                      "address": "{user-mail}",
                      "name": "Alex Darrow"
                  },
                  "type": "Required"
              }
          ],
          "timeConstraint": %{
              "timeslots": [
                  %{
                      "start": %{
                          "dateTime": "2022-11-02T23:35:18.469Z",
                          "timeZone": "Pacific Standard Time"
                      },
                      "end": %{
                          "dateTime": "2022-11-09T23:35:18.469Z",
                          "timeZone": "Pacific Standard Time"
                      }
                  }
              ]
          },
          "locationConstraint": %{
              "isRequired": "false",
              "suggestLocation": "true",
              "locations": [
                  %{
                      "displayName": "Conf Room 32/1368",
                      "locationEmailAddress": "conf32room1368@imgeek.onmicrosoft.com"
                  }
              ]
          },
          "meetingDuration": "PT1H"
      })
      {:ok, response}

  """
  def find_meeting_times(client, id, options \\ []) do
    Request.post("/v1.0/users/#{URI.encode(id)}/findMeetingTimes", options)
    |> Request.execute(client)
  end

  @doc """
  https://learn.microsoft.com/en-us/graph/api/user-post-events?view=graph-rest-1.0&tabs=http

  ## Examples

      # Params are required for this endpoint
      iex> MicrosoftGraph.Users.Calendar.schedule_meeting(client, "user_id")
      {:error, response}

      iex> MicrosoftGraph.Users.Calendar.schedule_meeting(client, "user_id", params: %{
        "subject": "Let's go for lunch",
        "body": %{
          "contentType": "HTML",
          "content": "Does noon work for you?"
        },
        "start": %{
            "dateTime": "2017-04-15T12:00:00",
            "timeZone": "Pacific Standard Time"
        },
        "end": %{
            "dateTime": "2017-04-15T14:00:00",
            "timeZone": "Pacific Standard Time"
        },
        "location": %{
            "displayName":"Harry's Bar"
        },
        "attendees": [
          %{
            "emailAddress": %{
              "address":"samanthab@contoso.onmicrosoft.com",
              "name": "Samantha Booth"
            },
            "type": "required"
          }
        ],
        "allowNewTimeProposals": true
      })
      {:ok, response}

  """
  def schedule_meeting(client, id, options \\ []) do
    Request.post("/v1.0/users/#{URI.encode(id)}/calendar/events", options)
    |> Request.execute(client)
  end
end
