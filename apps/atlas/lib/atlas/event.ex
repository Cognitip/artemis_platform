defmodule Atlas.Event do
  @moduledoc """
  
  """

  @broadcast_topic "private:atlas:events"

  def get_broadcast_topic, do: @broadcast_topic

  def broadcast({:ok, data} = result, event, user) do
    payload = %{
      data: data,
      user: user
    }

    :ok = AtlasPubSub.broadcast(@broadcast_topic, event, payload)

    result
  end
  def broadcast({:error, _} = result, _event, _user) do
    result
  end
  def broadcast(data, event, user) do
    broadcast({:ok, data}, event, user)
  end
end
