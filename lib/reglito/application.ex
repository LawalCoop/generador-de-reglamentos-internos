defmodule Reglito.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReglitoWeb.Telemetry,
      ChromicPDF,
      {DNSCluster, query: Application.get_env(:reglito, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Reglito.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Reglito.Finch},
      # Start a worker by calling: Reglito.Worker.start_link(arg)
      # {Reglito.Worker, arg},
      # Start to serve requests, typically the last entry
      ReglitoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Reglito.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReglitoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
