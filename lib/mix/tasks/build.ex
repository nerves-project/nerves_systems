defmodule Mix.Tasks.Ns.Build do
  @moduledoc "Build all Nerves systems"
  @shortdoc "Build all Nerves systems"

  use Mix.Task

  @systems Application.compile_env(:nerves_systems, :systems)

  @impl Mix.Task
  def run(_args) do
    systems = Enum.map(@systems, &normalize_system/1)

    Enum.each(systems, &config_buildroot/1)

    systems
    |> Enum.map(&build/1)
    |> Enum.reject(fn result -> result == :ok end)
    |> IO.inspect()
  end

  defp normalize_system({_, _, _} = system), do: system
  defp normalize_system({short_name, url}), do: {short_name, url, []}

  defp config_buildroot({short_name, url, _opts}) do
    dir = Path.join("src", Path.basename(url, ".git"))
    out = Path.join("o", short_name)
    defconfig = Path.join(dir, "nerves_defconfig")

    Mix.Shell.IO.info("Configuring #{dir} to build in #{out}...")

    0 = Mix.Shell.IO.cmd("src/nerves_system_br/create-build.sh #{defconfig} #{out}")
  end

  defp build({short_name, _url, _opts}) do
    out = Path.join("o", short_name)
    Mix.Shell.IO.info("Building #{short_name}...")

    # Unset the Erlang environment variables. These conflict with some package's Makefiles.
    clean_env = %{"ROOTDIR" => nil, "BINDIR" => nil, "EMU" => nil, "PROGNAME" => nil}

    case Mix.Shell.IO.cmd("make", cd: out, env: clean_env) do
      0 -> :ok
      _ -> {:error, "Build for #{out} failed."}
    end
  end
end
