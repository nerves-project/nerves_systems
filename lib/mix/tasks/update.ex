defmodule Mix.Tasks.Ns.Update do
  @moduledoc "Update all Nerves systems"
  @shortdoc "Update all Nerves systems"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    File.ls!("src")
    |> Enum.each(fn short_name ->
      Mix.Shell.IO.info("Updating #{short_name}...")
      Mix.Shell.IO.cmd("git -C src/#{short_name} pull --ff-only")
    end)
  end
end
