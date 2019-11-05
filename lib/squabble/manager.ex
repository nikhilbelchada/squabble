defmodule Squabble.Manager do
  @behaviour Squabble.Leader

  use GenServer

  @initial_state %{is_leader: false}
  @log_label "[Cluster Manager]"

  def start_link do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  # Squabble
  @impl true
  def leader_selected(_term), do: IO.puts "I am a leader"
  @impl true
  def node_down, do: IO.puts "I am down"
end
