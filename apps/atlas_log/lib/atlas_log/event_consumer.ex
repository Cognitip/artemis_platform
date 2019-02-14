defmodule AtlasLog.EventConsumer do
  use GenServer

  import AtlasPubSub
  
  alias AtlasLog.CreateEventLog

  @topic "private:atlas:events"

  def start_link() do
    initial_state = %{}
    options = []

    GenServer.start_link(__MODULE__, initial_state, options)
  end

  # Callbacks

  def init(state) do
    :ok = subscribe(@topic)

    {:ok, state}
  end

  def handle_info(%{event: event, payload: payload}, state) do
    {:ok, _} = CreateEventLog.call(event, payload)

    {:noreply, state}
  end
  def handle_info(_, state) do
    {:noreply, state}
  end
end
