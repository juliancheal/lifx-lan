# Generated code ahoy!
module LIFX
  module LAN
    module Protocol
      TYPE_ID_TO_CLASS = {
        # 1 => Device::SetSite,
        # 2 => Device::GetPanGateway,
        # 3 => Device::StatePanGateway,
        2 => Device::GetService,
        3 => Device::StateService,
        4 => Device::GetTime,
        5 => Device::SetTime,
        6 => Device::StateTime,
        # 7 => Device::GetResetSwitch,
        # 8 => Device::StateResetSwitch,
        # 12 => Device::GetMeshInfo,
        # 13 => Device::StateMeshInfo,
        # 14 => Device::GetMeshFirmware,
        # 15 => Device::StateMeshFirmware,
        12 => Device::GetHostInfo,
        13 => Device::StateHostInfo,
        14 => Device::GetHostFirmware,
        15 => Device::StateHostFirmware,
        16 => Device::GetWifiInfo,
        17 => Device::StateWifiInfo,
        18 => Device::GetWifiFirmware,
        19 => Device::StateWifiFirmware,
        20 => Device::GetPower,
        21 => Device::SetPower,
        22 => Device::StatePower,
        23 => Device::GetLabel,
        24 => Device::SetLabel,
        25 => Device::StateLabel,
        26 => Device::GetTags,
        27 => Device::SetTags,
        28 => Device::StateTags,
        29 => Device::GetTagLabels,
        30 => Device::SetTagLabels,
        31 => Device::StateTagLabels,
        32 => Device::GetVersion,
        33 => Device::StateVersion,
        34 => Device::GetInfo,
        35 => Device::StateInfo,
        # 36 => Device::GetMcuRailVoltage,
        # 37 => Device::StateMcuRailVoltage,
        # 38 => Device::Reboot,
        38 => Device::SetReboot,
        43 => Device::StateReboot,
        45 => Device::Acknowledgement,
        46 => Device::SetFactoryReset,
        47 => Device::StateFactoryReset,
        48 => Device::GetLocation,
        49 => Device::SetLocation,
        50 => Device::StateLocation,
        51 => Device::GetGroup,
        52 => Device::SetGroup,
        53 => Device::StateGroup,
        54 => Device::GetOwner,
        55 => Device::SetOwner,
        56 => Device::StateOwner,
        58 => Device::EchoRequest,
        59 => Device::EchoResponse,

        101 => Light::Get,
        # 102 => Light::Set,
        102 => Light::SetColor,
        103 => Light::SetWaveform,
        # 104 => Light::SetDimAbsolute,
        # 105 => Light::SetDimRelative,
        # 106 => Light::SetRgbw,
        107 => Light::State,
        # 108 => Light::GetRailVoltage,
        # 109 => Light::StateRailVoltage,
        110 => Light::GetTemperature,
        111 => Light::StateTemperature,
        116 => Light::GetPower,
        117 => Light::SetPower,
        118 => Light::StatePower,

        201 => Wan::ConnectPlain,
        202 => Wan::ConnectKey,
        203 => Wan::StateConnect,
        204 => Wan::Sub,
        205 => Wan::Unsub,
        206 => Wan::StateSub,

        301 => Wifi::Get,
        302 => Wifi::Set,
        303 => Wifi::State,
        # 304 => Wifi::GetAccessPoint,
        304 => Wifi::GetAccessPoints,
        305 => Wifi::SetAccessPoint,
        # 306 => Wifi::StateAccessPoint,
        306 => Wifi::StateAccessPoints,
        307 => Wifi::GetAccessPoint,
        308 => Wifi::StateAccessPoint,

        401 => Sensor::GetAmbientLight,
        402 => Sensor::StateAmbientLight,
        403 => Sensor::GetDimmerVoltage,
        404 => Sensor::StateDimmerVoltage,

        510 => MultiZone::SetExtendedColorZones,
        511 => MultiZone::GetExtendedColorZones,
        512 => MultiZone::StateExtendedColorZones,
        501 => MultiZone::SetColorZones,
        502 => MultiZone::GetColorZones,
        503 => MultiZone::StateZone,
        506 => MultiZone::StateMultiZone,

        701 => Tile::GetDeviceChain,
        702 => Tile::StateDeviceChain,
        703 => Tile::SetUserPosition,
        707 => Tile::GetTileState64,
        711 => Tile::StateTileState64,
        715 => Tile::SetTileState64,
      }.freeze

      CLASS_TO_TYPE_ID = TYPE_ID_TO_CLASS.invert.freeze
    end
  end
end
