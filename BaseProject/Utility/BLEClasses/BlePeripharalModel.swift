

//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import UIKit
import CoreBluetooth

class BlePeripharalModel: NSObject {
    public var peripharal : CBPeripheral!
    public var macAddress : String! = ""
    public var deviceName : String! = ""
    public var deviceImage : Data? = nil
    public var isConnectable : Bool! = false
    public var isDeviceProcessed : Bool! = false
    public var timestamp : Int! = 0
    public var arrRssi : [Double]! = []
    public var avgRSSI : Int! = -100
    public var isTrackingEnabled : Bool! = false

    init( _ peripharal : CBPeripheral , _ macAddress : String , _ deviceName : String , _ deviceImage : Data?, _ isDeviceProcessed : Bool , _ isConnectable : Bool , _ timestamp : Int , _ arrRssi : [Double], _ avgRSSI : Int , _ isTrackingEnabled : Bool) {
        super.init()
        self.peripharal = peripharal
        self.macAddress = macAddress
        self.deviceName = deviceName
        self.deviceImage = deviceImage
        self.isConnectable = isConnectable
        self.isDeviceProcessed = isDeviceProcessed
        self.timestamp = timestamp
        self.arrRssi = arrRssi
        self.avgRSSI = avgRSSI
        self.isTrackingEnabled = isTrackingEnabled
    }
}
