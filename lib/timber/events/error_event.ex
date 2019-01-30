defmodule Timber.Events.ErrorEvent do
  @moduledoc ~S"""
  **DEPRECATED**

  This module is deprecated in favor of using `map`s. The next evolution of Timber (2.0)
  no long requires a strict schema and therefore simplifies how users set context:

      Logger.info(fn ->
        message = Exception.message(error)
        event = %{error: %{name: error.__struct__, backtrace: backtrace}
        {message, event: event}
      end)

  Please note, errors can be automatically structured through the
  [`:timber_exceptions`](https://github.com/timberio/timber-elixir-exceptions) library.
  """

  @type stacktrace_entry :: {
          module,
          atom,
          arity,
          [file: IO.chardata(), line: non_neg_integer] | []
        }

  @type backtrace_entry :: %{
          app_name: String.t() | nil,
          function: String.t(),
          file: String.t() | nil,
          line: non_neg_integer | nil
        }

  @type t :: %__MODULE__{
          backtrace: [backtrace_entry] | nil,
          name: String.t(),
          message: String.t() | nil,
          metadata_json: binary | nil
        }

  @enforce_keys [:name]
  defstruct [:backtrace, :name, :message, :metadata_json]

  @max_backtrace_size 20
  @message_byte_limit 8_192
  @metadata_json_byte_limit 8_192
  @name_byte_limit 256

  @doc """
  Convenience methods for building error events, taking care to normalize values
  and ensure they meet the validation requirements of the Timber API.
  """
  def new(name, message, opts \\ []) do
    name =
      name
      |> Timber.Utils.Logger.truncate_bytes(@name_byte_limit)
      |> to_string()

    message =
      message
      |> Timber.Utils.Logger.truncate_bytes(@message_byte_limit)
      |> to_string()

    backtrace =
      case Keyword.get(opts, :backtrace, nil) do
        nil -> nil
        backtrace -> Enum.slice(backtrace, 0..(@max_backtrace_size - 1))
      end

    metadata_json =
      case Keyword.get(opts, :metadata_json, nil) do
        nil ->
          nil

        metadata_json ->
          metadata_json
          |> Timber.Utils.Logger.truncate_bytes(@metadata_json_byte_limit)
          |> to_string()
      end

    struct!(
      __MODULE__,
      name: name,
      message: message,
      backtrace: backtrace,
      metadata_json: metadata_json
    )
  end

  @doc """
  Message to be used when logging.
  """
  @spec message(t) :: IO.chardata()
  def message(%__MODULE__{name: name, message: message}),
    do: [?(, name, ?), ?\s, message]

  #
  # Implementations
  #

  defimpl Timber.Eventable do
    def to_event(event) do
      event = Map.from_struct(event)
      %{error: event}
    end
  end
end
