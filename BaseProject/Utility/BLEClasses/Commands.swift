//
//  Commands.swift
//
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit
import CoreFoundation

/// Colstants list which are related to BLE Operations
struct Constants {
    // Device Services UUID
    static let kHARDWARE_KEY_SERVICE = "FFE0"
    static let kDeviceName = "deviceName"
    // BLE Lib Key
    static let kPropertyOperationWrite = "write"
    static let kPropertyOperationRead = "read"
    static let kPropertyOperationReadWait = "readWait"
    
    // Timeout Command
    static let kCommandPropertySetTimeout = 10.0
    static let kDisconnectTimeout = 10.0
    static let kLowPriorityTimeout = 2.0
    static let kCBPathDelimiter = "."
    
    static let kName = "name"
    static let kValues = "values"
    static let kTimeoutSettings = "TimeoutSettings"
    
    static let kRssi  = "rssi"
    static let kPeripheralUUIDKey       = "peripheralUUID"
    static let kIsDeviceRemoved         = "isDeviceRemoved"

}


/// List of Ble Commands
struct BleCommands {
    static let kCommand_CamOne = "CamOne"
    static let kCommand_CamTwo = "CamTwo"
    static let kCommand_CamThree = "CamThree"
    static let kCommand_CamFour = "CamFour"
}


/// CommandIDs defined for Bluetooth Protocol
struct CommandID {
  
    static let cam_1_on_off: UInt8 = 0x31
    static let cam_2_on_off: UInt8 = 0x32
    static let cam_3_on_off: UInt8 = 0x33
    static let cam_4_on_off: UInt8 = 0x34
    
}

/// Response CommandIDs defined for Bluetooth Protocol
struct ResponseCommandID {
    static let cam_1_on_off: UInt8 = 0x32
    static let cam_2_on_off: UInt8 = 0x33
    static let cam_3_on_off: UInt8 = 0x34
    static let cam_4_on_off: UInt8 = 0x35
}

/// Charactiristics name
struct CharName {
    static let kChar_device_command = "deviceCommand"
}

/// Erro declaration when any intruption occured
public struct MyError: Error {
    let msg: String
}
func printLog(titleString : String? , messageString : String?) -> Void {
    if let titleValue = titleString , !titleValue.isEmpty {
        debugPrint("\(titleValue) : \(messageString ?? "")")
    } else {
        debugPrint("\(messageString ?? "")")
    }
}
