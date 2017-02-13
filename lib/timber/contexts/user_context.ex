defmodule Timber.Contexts.UserContext do
  @moduledoc """
  The User context tracks the currently authenticated user.

  You will want to add this context at the time you authenticate the user.

  This allows you to find all log lines generated by a specific user.
  """

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    email: String.t
  }

  @type m :: %{
    id: String.t,
    name: String.t,
    email: String.t
  }

  defstruct [:id, :name, :email]
end
