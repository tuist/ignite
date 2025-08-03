defmodule Sidekick.DestinationType do
  @moduledoc false

  use Protobuf, enum: true, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :SIMULATOR, 0
  field :DEVICE, 1
end

defmodule Sidekick.Empty do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3
end

defmodule Sidekick.XcodeVersionResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :version, 1, type: :string
  field :build, 2, type: :string
end

defmodule Sidekick.Destination do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :name, 2, type: :string
  field :platform, 3, type: :string
  field :os_version, 4, type: :string, json_name: "osVersion"
  field :device_type, 5, type: :string, json_name: "deviceType"
  field :type, 6, type: Sidekick.DestinationType, enum: true
  field :state, 7, type: :string
  field :is_available, 8, type: :bool, json_name: "isAvailable"
end

defmodule Sidekick.ListDestinationsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :destinations, 1, repeated: true, type: Sidekick.Destination
end

defmodule Sidekick.Simulator do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :name, 2, type: :string
  field :device_type, 3, type: :string, json_name: "deviceType"
  field :runtime, 4, type: :string
  field :state, 5, type: :string
end

defmodule Sidekick.ListSimulatorsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :simulators, 1, repeated: true, type: Sidekick.Simulator
end

defmodule Sidekick.BootSimulatorRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :identifier, 1, type: :string
end

defmodule Sidekick.ShutdownSimulatorRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :identifier, 1, type: :string
end

defmodule Sidekick.Device do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :id, 1, type: :string
  field :name, 2, type: :string
  field :model, 3, type: :string
  field :ios_version, 4, type: :string, json_name: "iosVersion"
  field :connected, 5, type: :bool
end

defmodule Sidekick.ListDevicesResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :devices, 1, repeated: true, type: Sidekick.Device
end

defmodule Sidekick.CompileProjectRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :project_path, 1, type: :string, json_name: "projectPath"
  field :scheme, 2, type: :string
  field :configuration, 3, type: :string
  field :destination, 4, type: :string
end

defmodule Sidekick.CompileProjectResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :output, 2, type: :string
  field :error, 3, type: :string
  field :exit_code, 4, type: :int32, json_name: "exitCode"
end

defmodule Sidekick.RunTestsRequest do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :project_path, 1, type: :string, json_name: "projectPath"
  field :scheme, 2, type: :string
  field :configuration, 3, type: :string
  field :destination, 4, type: :string
end

defmodule Sidekick.RunTestsResponse do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.15.0", syntax: :proto3

  field :success, 1, type: :bool
  field :output, 2, type: :string
  field :error, 3, type: :string
  field :exit_code, 4, type: :int32, json_name: "exitCode"
  field :tests_run, 5, type: :int32, json_name: "testsRun"
  field :tests_passed, 6, type: :int32, json_name: "testsPassed"
  field :tests_failed, 7, type: :int32, json_name: "testsFailed"
end

defmodule Sidekick.Sidekick.Service do
  @moduledoc false

  use GRPC.Service, name: "sidekick.Sidekick", protoc_gen_elixir_version: "0.15.0"

  rpc :HealthCheck, Sidekick.Empty, Sidekick.Empty

  rpc :GetXcodeVersion, Sidekick.Empty, Sidekick.XcodeVersionResponse

  rpc :ListDestinations, Sidekick.Empty, Sidekick.ListDestinationsResponse

  rpc :ListSimulators, Sidekick.Empty, Sidekick.ListSimulatorsResponse

  rpc :BootSimulator, Sidekick.BootSimulatorRequest, Sidekick.Empty

  rpc :ShutdownSimulator, Sidekick.ShutdownSimulatorRequest, Sidekick.Empty

  rpc :ListDevices, Sidekick.Empty, Sidekick.ListDevicesResponse

  rpc :CompileProject, Sidekick.CompileProjectRequest, Sidekick.CompileProjectResponse

  rpc :RunTests, Sidekick.RunTestsRequest, Sidekick.RunTestsResponse
end

defmodule Sidekick.Sidekick.Stub do
  @moduledoc false

  use GRPC.Stub, service: Sidekick.Sidekick.Service
end
