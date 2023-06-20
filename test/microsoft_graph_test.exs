defmodule MicrosoftGraphTest do
  use ExUnit.Case, async: true
  doctest MicrosoftGraph

  describe "create" do
    test "client with string keys" do
      assert MicrosoftGraph.Client.create("foo", "bar", "baz") == %OAuth2.Client{
               authorize_url: "/oauth/authorize",
               client_id: "foo",
               client_secret: "bar",
               headers: [],
               params: %{},
               redirect_uri: "",
               ref: nil,
               serializers: %{"application/json" => Jason},
               site: "https://graph.microsoft.com",
               strategy: OAuth2.Strategy.ClientCredentials,
               token: nil,
               token_method: :post,
               token_url: "https://login.microsoftonline.com/baz/oauth2/v2.0/token"
             }
    end

    test "client with ueberauth config" do
      simulated_ueberauth_config = [
        client_id: "foo",
        client_secret: "bar",
        tenant_id: "baz"
      ]

      assert MicrosoftGraph.Client.create(simulated_ueberauth_config) == %OAuth2.Client{
               authorize_url: "/oauth/authorize",
               client_id: "foo",
               client_secret: "bar",
               headers: [],
               params: %{},
               redirect_uri: "",
               ref: nil,
               serializers: %{"application/json" => Jason},
               site: "https://graph.microsoft.com",
               strategy: OAuth2.Strategy.ClientCredentials,
               token: nil,
               token_method: :post,
               token_url: "https://login.microsoftonline.com/baz/oauth2/v2.0/token"
             }
    end
  end
end
