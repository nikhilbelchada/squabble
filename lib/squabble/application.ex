defmodule Squabble.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    topologies = [
      squabble: [
        strategy: Elixir.Cluster.Strategy.Epmd,
        config: [
          hosts: get_cluster_hosts()
        ],
      ]
    ]
    children = [
      worker(Squabble.Manager, []),
      {Cluster.Supervisor, [topologies, [name: Squabble.ClusterSupervisor]]},
      {Squabble, [subscriptions: [Squabble.Manager], size: 3, weight: System.get_env("WEIGHT", "1") |> String.to_integer()]},
    ]

    opts = [strategy: :one_for_one, name: Squabble.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_cluster_hosts do
    [:"a@127.0.0.1", :"b@127.0.0.1", :"c@127.0.0.1"]
  end
end
