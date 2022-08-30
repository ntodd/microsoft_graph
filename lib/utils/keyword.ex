defmodule MicrosoftGraph.Utils.Keyword do
  @moduledoc false

  @doc """
  Deeply merges right into left.

  ## Examples

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: 1], [b: 2])
      [a: 1, b: 2]

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: %{b: 1}], [a: %{c: 3}])
      [a: %{b: 1, c: 3}]

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: %{b: %{c: 1}}], [a: %{b: %{d: 2}}])
      [a: %{b: %{c: 1, d: 2}}]

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: 1], [a: %{b: 2}])
      [a: %{b:  2}]

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: %{b: 1}], [a: 2])
      [a: 2]

      iex> MicrosoftGraph.Utils.Keyword.deep_merge([a: 1], [a: 2])
      [a: 2]

  """
  def deep_merge(left, right) do
    Keyword.merge(left, right, &deep_resolve/3)
  end

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, %{} = left, %{} = right) do
    MicrosoftGraph.Utils.Map.deep_merge(left, right)
  end

  defp deep_resolve(_key, left, right) when is_list(left) and is_list(right) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end
end
