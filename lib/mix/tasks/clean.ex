defmodule Mix.Tasks.Ns.Clean do
  @moduledoc "Clean all Nerves systems"
  @shortdoc "Clean all Nerves systems"

  use Mix.Task

  @directories_to_clean ["build", "images", "host", "target"]

  @impl Mix.Task
  def run(_args) do
    File.ls!("o")
    |> Enum.each(fn short_name ->
      path = Path.join("o", short_name)

      Mix.Shell.IO.info("Cleaning #{short_name}...")

      Enum.each(@directories_to_clean, fn directory_to_clean ->
        path
        |> Path.join(directory_to_clean)
        |> File.rm_rf()
      end)
    end)
  end
end
