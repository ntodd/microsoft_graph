defmodule MicrosoftGraphTest do
  use ExUnit.Case
  doctest MicrosoftGraph

  test "valid client exists" do
    assert MicrosoftGraph.Client.client("foo", "bar", "baz") == %OAuth2.Client{
             authorize_url: "/oauth/authorize",
             client_id: "foo",
             client_secret: "bar",
             headers: [],
             params: %{},
             redirect_uri: "",
             ref: nil,
             request_opts: [
               {:ssl_options,
                [
                  versions: [:"tlsv1.2"],
                  verify: :verify_peer,
                  cacertfile: :certifi.cacertfile()
                ]}
             ],
             serializers: %{"application/json" => Jason},
             site: "https://graph.microsoft.com",
             strategy: OAuth2.Strategy.ClientCredentials,
             token: nil,
             token_method: :post,
             token_url: "https://login.microsoftonline.com/baz/oauth2/v2.0/token"
           }
  end
end
