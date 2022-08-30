defmodule MicrosoftGraph.Request do
  @moduledoc """
  Lower-level API to create and execute Microsoft Graph API requests.
  """
  alias MicrosoftGraph.Request

  @type t() :: %Request{
          method: atom(),
          url: URI.t(),
          headers: [{binary(), binary()}],
          params: map(),
          options: [{:cast, atom()}, {:merge_query_params, boolean()}]
        }

  defstruct method: :get,
            url: URI.new(""),
            headers: [],
            params: %{},
            options: []

  @doc """
  Create a GET request.

  See `new/1` for options.
  """
  def get(path, options \\ []) do
    options |> put_path_in_options(path) |> new()
  end

  @doc """
  Create a POST request.

  See `new/1` for options.
  """
  def post(path, options \\ []) do
    options
    |> put_path_in_options(path)
    |> put_method_in_options(:post)
    |> new()
  end

  @doc """
  Create a request. You generally should use the other request constructors like `get/2` and `post/2`.

  Basic request options:

  - `:method` - the request method, defaults to :get.
  - `:url` - the request URL.
  - `:headers` - the request headers.
    The headers are automatically encoded using these rules:
    - atom header names are turned into strings
    - string header names are left as is.
  - `:params` - the request params (querystring for get, post body for post,put,patch).
  - `:cast` - OData cast, defaults to nothing
    Options are:
    - `:user` for `microsoft.graph.user`
    - `:group` for `microsoft.graph.group`

  """
  def new(options \\ []) do
    {method, options} = Keyword.pop(options, :method, :get)
    {url, options} = Keyword.pop(options, :url, "")
    {params, options} = Keyword.pop(options, :params, %{})
    {headers, options} = Keyword.pop(options, :headers, [])

    struct!(Request, %{
      method: method,
      url: url,
      params: MicrosoftGraph.Utils.Map.keys_to_strings(params),
      headers: headers,
      options: options
    })
    |> handle_query_params()
    |> handle_cast_option()
  end

  @doc """
  Executes a given request.

  ## Example

      iex> MicrosoftGraph.Request.execute(%Request{}, %OAuth2.Client{})
      {:ok, response}

      # Bad request
      iex> MicrosoftGraph.Request.execute(%Request{}, %OAuth2.Client{})
      {:error, response}

      # Unsupported method
      iex> MicrosoftGraph.Request.execute(%Request{method: :grab}, %OAuth2.Client{})
      {:error, :unsupported_method}

  """
  def execute(%Request{} = request, client) do
    case request.method do
      :get ->
        OAuth2.Client.get(client, request.url.path, request.headers, params: request.params)

      :get_paginated ->
        get_paginated_results(request, client)

      :post ->
        OAuth2.Client.post(client, request.url.path, request.params, request.headers)

      _ ->
        {:error, :unsupported_method}
    end
    |> case do
      {:ok, response} ->
        {:ok, response}

      {:error, %{body: %{"error" => %{"code" => "InvalidAuthenticationToken"}}}} ->
        {:error, :invalid_authentication_token}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Puts a header into the given request.

  ## Example

      iex> MicrosoftGraph.Request.put_header(%Request{}, "Content-Type", "application/json")
      %Request{}

  """
  def put_header(%Request{} = request, key, value) when is_binary(key) and is_binary(value) do
    %{request | headers: List.keystore(request.headers, key, 0, {key, value})}
  end

  @doc """
  Will make request a paginated request. `execute/2` will follow the `@odata.nextLink` in the response
  if it exists to fetch the next page. Method type will be `:get_paginated`.
  """
  def paginate_results(%Request{} = request) do
    Map.put(request, :method, :get_paginated)
  end

  @doc """
  Puts the advanced query params and headers required for some operations.

  https://docs.microsoft.com/en-us/graph/aad-advanced-queries?tabs=http
  """
  def put_advanced_query_params(%Request{} = request) do
    params = MicrosoftGraph.Utils.Map.deep_merge(%{"$count" => true}, request.params)

    headers =
      MicrosoftGraph.Utils.Keyword.deep_merge([ConsistencyLevel: "eventual"], request.headers)

    request
    |> Map.put(:params, params)
    |> Map.put(:headers, headers)
  end

  defp get_paginated_results(%Request{} = request, client, results \\ []) do
    case OAuth2.Client.get(client, request.url.path, request.headers, params: request.params) do
      {:ok, %{body: %{"@odata.nextLink" => next_link, "value" => page_results}}} ->
        # There is another page, collect users and load next page
        get(next_link, params: request.params, headers: request.headers)
        |> paginate_results()
        |> get_paginated_results(client, List.flatten(results, page_results))

      {:ok, %{body: %{"value" => page_results}}} ->
        # Last or only page
        {:ok, List.flatten(results, page_results)}

      {:error, error} ->
        {:error, error}
    end
  end

  defp handle_query_params(%Request{url: %{query: nil}} = request), do: request

  defp handle_query_params(%Request{url: %{query: query}} = request) do
    # Merge or replace the params with the querystring params from the provided path
    # Defaults to replace, can be merged with `merge_query_params: true` in request options
    if Keyword.get(request.options, :merge_query_params, false) do
      merged_params =
        request.params |> MicrosoftGraph.Utils.Map.deep_merge(URI.decode_query(query))

      request |> Map.put(:params, merged_params)
    else
      request |> Map.put(:params, URI.decode_query(query))
    end
  end

  defp handle_cast_option(%Request{} = request) do
    # If a cast option was provided, we need to add the case to the path
    path =
      case Keyword.get(request.options, :cast) do
        :user ->
          String.trim_trailing(request.url.path, "/") <> "/microsoft.graph.user"

        :group ->
          String.trim_trailing(request.url.path, "/") <> "/microsoft.graph.group"

        nil ->
          request.url.path
      end

    url = request.url |> Map.put(:path, path)
    request |> Map.put(:url, url)
  end

  defp put_path_in_options(options, path) do
    uri = URI.parse(path)
    List.keystore(options, :url, 0, {:url, uri})
  end

  defp put_method_in_options(options, method) do
    List.keystore(options, :method, 0, {:method, method})
  end
end
