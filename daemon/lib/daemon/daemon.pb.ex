defmodule Daemon.DestinationType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:SIMULATOR, 0)
  field(:DEVICE, 1)
end

defmodule Daemon.Empty do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Daemon.XcodeVersionResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:version, 1, type: :string)
  field(:build, 2, type: :string)
end

defmodule Daemon.Destination do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:id, 1, type: :string)
  field(:name, 2, type: :string)
  field(:platform, 3, type: :string)
  field(:os_version, 4, type: :string, json_name: "osVersion")
  field(:device_type, 5, type: :string, json_name: "deviceType")
  field(:type, 6, type: Daemon.DestinationType, enum: true)
  field(:state, 7, type: :string)
  field(:is_available, 8, type: :bool, json_name: "isAvailable")
end

defmodule Daemon.ListDestinationsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:destinations, 1, repeated: true, type: Daemon.Destination)
end

defmodule Daemon.Simulator do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:id, 1, type: :string)
  field(:name, 2, type: :string)
  field(:device_type, 3, type: :string, json_name: "deviceType")
  field(:runtime, 4, type: :string)
  field(:state, 5, type: :string)
end

defmodule Daemon.ListSimulatorsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:simulators, 1, repeated: true, type: Daemon.Simulator)
end

defmodule Daemon.BootSimulatorRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:identifier, 1, type: :string)
end

defmodule Daemon.ShutdownSimulatorRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:identifier, 1, type: :string)
end

defmodule Daemon.Device do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:id, 1, type: :string)
  field(:name, 2, type: :string)
  field(:model, 3, type: :string)
  field(:ios_version, 4, type: :string, json_name: "iosVersion")
  field(:connected, 5, type: :bool)
end

defmodule Daemon.ListDevicesResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:devices, 1, repeated: true, type: Daemon.Device)
end

defmodule Daemon.CompileProjectRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:project_path, 1, type: :string, json_name: "projectPath")
  field(:scheme, 2, type: :string)
  field(:configuration, 3, type: :string)
  field(:destination, 4, type: :string)
end

defmodule Daemon.CompileProjectResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:success, 1, type: :bool)
  field(:output, 2, type: :string)
  field(:error, 3, type: :string)
  field(:exit_code, 4, type: :int32, json_name: "exitCode")
end

defmodule Daemon.RunTestsRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:project_path, 1, type: :string, json_name: "projectPath")
  field(:scheme, 2, type: :string)
  field(:configuration, 3, type: :string)
  field(:destination, 4, type: :string)
end

defmodule Daemon.RunTestsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field(:success, 1, type: :bool)
  field(:output, 2, type: :string)
  field(:error, 3, type: :string)
  field(:exit_code, 4, type: :int32, json_name: "exitCode")
  field(:tests_run, 5, type: :int32, json_name: "testsRun")
  field(:tests_passed, 6, type: :int32, json_name: "testsPassed")
  field(:tests_failed, 7, type: :int32, json_name: "testsFailed")
end

defmodule Daemon.Daemon.Service do
  @moduledoc false

  use GRPC.Service, name: "sidekick.Daemon", protoc_gen_elixir_version: "0.15.0"

  rpc :HealthCheck, Daemon.Empty, Daemon.Empty

  rpc :GetXcodeVersion, Daemon.Empty, Daemon.XcodeVersionResponse

  rpc :ListDestinations, Daemon.Empty, Daemon.ListDestinationsResponse

  rpc :ListSimulators, Daemon.Empty, Daemon.ListSimulatorsResponse

  rpc :BootSimulator, Daemon.BootSimulatorRequest, Daemon.Empty

  rpc :ShutdownSimulator, Daemon.ShutdownSimulatorRequest, Daemon.Empty

  rpc :ListDevices, Daemon.Empty, Daemon.ListDevicesResponse

  rpc :CompileProject, Daemon.CompileProjectRequest, Daemon.CompileProjectResponse

  rpc :RunTests, Daemon.RunTestsRequest, Daemon.RunTestsResponse
end

defmodule Daemon.Daemon.Stub do
  @moduledoc false

  use GRPC.Stub, service: Daemon.Daemon.Service
end
