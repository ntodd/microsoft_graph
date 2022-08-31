defmodule MicrosoftGraph.Utils.Map do
  @moduledoc false

  @doc """
  Deeply merges right into left.

  ## Examples

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: 1}, %{b: 2})
      %{a: 1, b: 2}

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: %{b: 1}}, %{a: %{c: 3}})
      %{a: %{b: 1, c: 3}}

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: %{b: %{c: 1}}}, %{a: %{b: %{d: 2}}})
      %{a: %{b: %{c: 1, d: 2}}}

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: 1}, %{a: %{b: 2}})
      %{a: %{b:  2}}

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: %{b: 1}}, %{a: 2})
      %{a: 2}

      iex> MicrosoftGraph.Utils.Map.deep_merge(%{a: 1}, %{a: 2})
      %{a: 2}

  """
  def deep_merge(left, right) do
    Map.merge(left, right, &deep_resolve/3)
  end

  @doc """
  Recursively convert any string keys in map to atom keys.

  ## Examples:

      iex> MicrosoftGraph.Utils.Map.keys_to_atoms(%{a: 1, b: 2})
      %{a: 1, b: 2}

      iex> MicrosoftGraph.Utils.Map.keys_to_atoms(%{"a" => 1, "b" => 2})
      %{a: 1, b: 2}

      iex> MicrosoftGraph.Utils.Map.keys_to_atoms(%{"a" => 1, b: 2})
      %{a: 1, b: 2}

      iex> MicrosoftGraph.Utils.Map.keys_to_atoms(%{"a" => 1, b: %{"d" => 4, c: 3}})
      %{a: 1, b: %{c: 3, d: 4}}

  """
  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map,
        into: %{},
        do: {if(is_binary(key), do: String.to_existing_atom(key), else: key), keys_to_atoms(val)}
  end

  def keys_to_atoms(value), do: value

  @doc """
  Recursively convert any atom keys in map to string keys.

  ## Examples:

    iex> MicrosoftGraph.Utils.Map.keys_to_strings(%{"a" => 1, "b" => 2})
    %{"a" => 1, "b" => 2}

    iex> MicrosoftGraph.Utils.Map.keys_to_strings(%{a: 1, b: 2})
    %{"a" => 1, "b" => 2}

    iex> MicrosoftGraph.Utils.Map.keys_to_strings(%{"a" => 1, b: 2})
    %{"a" => 1, "b" => 2}

    iex> MicrosoftGraph.Utils.Map.keys_to_strings(%{"a" => 1, b: %{"d" => 4, c: 3}})
    %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}

  """
  def keys_to_strings(atom_key_map) when is_map(atom_key_map) do
    for {key, val} <- atom_key_map,
        into: %{},
        do: {if(is_atom(key), do: Atom.to_string(key), else: key), keys_to_strings(val)}
  end

  def keys_to_strings(value), do: value

  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, %{} = left, %{} = right) do
    deep_merge(left, right)
  end

  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right) do
    right
  end
end
