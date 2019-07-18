defmodule Rumbl.InfoSys.Supervisor do
    use Supervisor 

    def start_link(_) do
        Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_opts) do
        children = [
            Supervisor.child_spec({Rumbl.InfoSys, []}, restart: :temporary)
        ]

        Supervisor.init children, strategy: :simple_one_for_one
    end
end