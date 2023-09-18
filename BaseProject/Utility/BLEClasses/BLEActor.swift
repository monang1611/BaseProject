//
//  BLEActor.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.



import UIKit
import CoreBluetooth

// CBCenterManager Notification
let kBluetoothStateUpdate = "BluetoothStateUpdate"
let kScanResultPeripheralFound = "ScanResultPeripheralFound"
let kPeripheralStateChanged = "PeripheralStateChanged"
let kPeripheralFound = "PeripheralFound"
let kFailedToConnectPeripheral = "FailedToConnectPeripheral"
let kDeviceDisconnected = "DeviceDisconnected"

//BLE Actor
let kDeviceIsReady = "DeviceIsReady"
let kDeviceDidSendNotification = "DeviceDidSendNotification"
let kDeviceDidUpdateProperty = "DeviceDidUpdateProperty"
let kDeviceDidPerformCommand = "DeviceDidPerformCommand"
let kDeviceFailedToPerformCommand = "DeviceFailedToPerformCommand"
let kDeviceWillPerformCommand  = "DeviceWillPerformCommand"
let kNewDeviceFound = "NewDeviceFound"

// CBPeripheralManager Notification
let kPeripheralDidDiscoverServices = "PeripheralDidDiscoverServices"
let kPeripheralDidDiscoverCharacteristicsForService = "PeripheralDidDiscoverCharacteristicsForService"
let kPeripheralDidUpdateValueForCharacteristic = "PeripheralDidUpdateValueForCharacteristic"
let kPeripheralDidWriteValueForCharacteristic = "PeripheralDidWriteValueForCharacteristic"
let kPeripheralFailedToWriteValueForCharacteristic = "PeripheralFailedToWriteValueForCharacteristic"
let kPeripheralDidUpdateRSSI = "PeripheralDidUpdateRSSI"
let kPeripheralUpdateRSSI = "PeripheralUpdateRSSI"
let kPeripheralFailedToDiscoverCharacteristicsForService = "PeripheralFailedToDiscoverCharacteristicsForService"
let kPeripheralFailedToDiscoverServices = "PeripheralFailedToDiscoverServices"
let kPeripheralFailedToUpdateValueForCharacteristic = "PeripheralFailedToUpdateValueForCharacteristic"
let kCheckHeartRateDevice = "CheckHeartRateDevice"

let kServiceMeta = "serviceMeta.plist"
let kCommandMeta = "commandMeta.plist"

enum kValueTransformDirection : Int {
    case In = 0
    case Out
}

extension CBPeripheral {
    func characteristic(withPath path: String)  -> CBCharacteristic? {
        let pathUUIDs: [CBUUID] = CBUUIDsFromNSStrings(strings: path.components(separatedBy: Constants.kCBPathDelimiter))
        if (self.services != nil) {
            for findService : CBService in (self.services)! {
                if pathUUIDs.count == 2  && (findService.characteristics != nil) && findService.uuid == pathUUIDs[0] {
                    for findChar : CBCharacteristic in findService.characteristics! {
                        if findChar.uuid == pathUUIDs[1] {
//                            print("characteristic :: \(findService.uuid.uuidString).\(findChar.uuid.uuidString)")
                            return findChar
                        }
                    }
                }
            }
        }
        return nil
    }
}

extension CBCharacteristic {
    func path() -> String {
        return  (NSStringsFromCBUUIDs(cbUUIDs: [service!.uuid, uuid]) as NSArray).componentsJoined(by: Constants.kCBPathDelimiter)
    }
    
    var stringValue: String? {
        return String.init(data: self.value!, encoding: String.Encoding.utf8)
    }
    
    var dataValue: Data? {
        return value!
    }
    
    func valueWithType(withType type: String) -> Any {
        let selectorStr: String = "\(type)Value"
        let selector: Selector = NSSelectorFromString(selectorStr)
        return perform(selector)
    }
}

// PeripheralActor responsible for discovering Services, Characteristics, Write, Read operations
class PeripheralActor: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    
    init(peripheral aPeripheral: CBPeripheral) {
        super.init()
        self.peripheral = aPeripheral
        self.peripheral?.delegate = self
    }
    
    func discoverServices(_ services: [Any]) {
//        print(#function,"discovering services: \(services) of peripheral: \(String(describing: self.peripheral))")
        self.peripheral?.discoverServices(services as? [CBUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
//            print(#function,"PeripheralFailedToDiscoverServices \(String(describing: error?.localizedDescription))");
            PostNoteWithInfo(kPeripheralFailedToDiscoverServices, peripheral, ["error": error!])
            return
        }
//        print(#function,"didDiscoverServices>> \(String(describing: self.peripheral?.services!))")
//        print(#function,"________________________DID DISCOVER SERVICES________________________")
        PostNoteWithInfo(kPeripheralDidDiscoverServices, peripheral, ["services": peripheral.services!])
    }
    
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {
//        print(#function,"discovering characteristics:\(String(describing: characteristicUUIDs)) of service: \(service) of peripheral: \(String(describing: peripheral))")
        self.peripheral?.discoverCharacteristics(characteristicUUIDs, for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            PostNoteWithInfo(kPeripheralFailedToDiscoverCharacteristicsForService, peripheral, ["error": error!, "service": service])
            return
        }
        PostNoteWithInfo(kPeripheralDidDiscoverCharacteristicsForService, peripheral, ["service": service, "characteristics": service.characteristics!])
    }
    
    func getRSSI() {
        self.peripheral?.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        PostNoteWithInfo(kPeripheralUpdateRSSI, peripheral, ["rssi": RSSI])
        printLog(titleString: "BLEActor", messageString: "didReadRSSI \(peripheral.identifier.uuidString) : \(Int(truncating: RSSI))")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            PostNoteWithInfo(kPeripheralFailedToUpdateValueForCharacteristic, peripheral, ["error": error!, "characteristic": characteristic])
            return
        }
        PostNoteWithInfo(kPeripheralDidUpdateValueForCharacteristic, peripheral, ["characteristic": characteristic, "service": characteristic.service, "value": characteristic.value!])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            PostNoteWithInfo(kPeripheralFailedToWriteValueForCharacteristic, peripheral, ["characteristic": characteristic, "error": error!])
            return
        }
        let userInfo: NSMutableDictionary
        if characteristic.value != nil {
            userInfo = ["characteristic": characteristic, "value": characteristic.value!]
        }else{
            userInfo = ["characteristic": characteristic]
        }
        PostNoteWithInfo(kPeripheralDidWriteValueForCharacteristic, peripheral, userInfo)
    }
    
    @objc func peripheralDidUpdateRSSI(_ peripheral: CBPeripheral, error: Error?) {
        PostNoteBLE(kPeripheralUpdateRSSI, peripheral)
    }
    
    func readValue(forCharacteristicPath path: String) {
        let ch: CBCharacteristic? = self.peripheral?.characteristic(withPath: path.uppercased())
        if nil == ch {
//            print(#function,"WARN: could not find characteristic with path \(path) for peripheral \(String(describing: peripheral))")
            return
        }
//        print(#function,"characteristic \(path) properties: \(String(describing: ch?.properties))")
        if ((ch?.properties.rawValue)! & CBCharacteristicProperties.read.rawValue) == 0 {
//            print(#function,"WARN: characteristic \(path) is not readable")
        }
        self.peripheral?.readValue(for: ch!)
    }
    
    func notifyValue(forCharacteristicPath path: String, isEnable : Bool) {
        let ch: CBCharacteristic? = self.peripheral?.characteristic(withPath: path.uppercased())
        if nil == ch {
            return
        }
        if (CBCharacteristicProperties.notify.rawValue & (ch?.properties.rawValue)!) != 0 {
            if isEnable {
                self.peripheral?.setNotifyValue(true, for: ch!)
            }
            else {
                self.peripheral?.setNotifyValue(false, for: ch!)
            }
        }
        else if (CBCharacteristicProperties.indicate.rawValue & (ch?.properties.rawValue)!) != 0 {
            if isEnable {
                self.peripheral?.setNotifyValue(true, for: ch!)
            }
            else {
                self.peripheral?.setNotifyValue(false, for: ch!)
            }
        }
        else {
//            print(#function,"WARN: characteristic with path \(String(describing: ch)) does not support notifications")
        }
    }
    
    func write(_ data: Data, forCharacteristicPath path: String) {
        let ch: CBCharacteristic? = self.peripheral?.characteristic(withPath: path.uppercased())
        if nil == ch {
//            print(#function,"WARN: could not find characteristic with path \(path) for peripheral \(String(describing: peripheral))")
            return
        }
//        print(#function,"characteristic: \(String(describing: ch?.uuid)), \(path), properties: \(String(describing: ch?.properties))")
        
        if ((ch?.properties.rawValue)! & CBCharacteristicProperties.write.rawValue) != 0  || ((ch?.properties.rawValue)! & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0  {
//            print(#function,"writing value: \(data) into characteristic: \(String(describing: ch?.uuid))")
            if ((ch?.properties.rawValue)! & CBCharacteristicProperties.write.rawValue) == 0 {
//                print(#function,"WARN: this characteristic does not support writes with response")
            }
            if ((ch?.properties.rawValue)! & CBCharacteristicProperties.write.rawValue) != 0 {
                self.peripheral?.writeValue(data, for: ch!, type: CBCharacteristicWriteType.withResponse)
            }else{
                self.peripheral?.writeValue(data, for: ch!, type: CBCharacteristicWriteType.withoutResponse)
            }
            return
        }
        else {
//            print(#function,"WARN: characteristic \(String(describing: ch?.uuid)) does not support writes")
        }
    }
}

// CentralManager responsible for discovering devices, connection operations.
class CentralManagerActor: NSObject,CBCentralManagerDelegate {
    var centralManager: CBCentralManager?
    var serviceUUIDs = [CBUUID]()
    var peripherals = NSMutableArray()
    var dicScannedDeviceTimestamp : [String : Int] = [:]
    var rssiDictionary: [String:[Double]] = [:]
    var arrDeviceList:[BlePeripharalModel]  = []
    
    init(serviceUUIDs aServiceUUIDs:[CBUUID]) {
        super.init()
        printLog(titleString: "ServiceID:", messageString:"\(aServiceUUIDs.map({$0.uuidString}))")
        self.serviceUUIDs = aServiceUUIDs
        self.peripherals = NSMutableArray()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.centralManager?.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }
    
    func add(_ peripheral: CBPeripheral) {
        let idx: Int = (peripherals as NSArray).index(of: peripheral)
        self.peripheralFound(peripharal: peripheral, metaData: nil)
        if NSNotFound == idx {
            self.peripherals.insert(peripheral, at: 0)
        }
        
        if peripheral.state != .connected {
//            print(#function,"trying to connect to peripheral \(peripheral)")
            self.centralManager?.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,CBConnectPeripheralOptionNotifyOnConnectionKey:true])
        }
        else {
//            print(#function,"addPeripheral>>\(peripheral)")
            PostNoteBLE(kPeripheralStateChanged, peripheral)
        }
    }
    
    func peripheralFound(peripharal : CBPeripheral, metaData : NSMutableDictionary?) {
        var deviceActor : BLEActor!
        for actor in appDelegate_.deviceActors {
            if (actor.isActor(peripharal)){
                deviceActor = actor;
                break;
            }
        }
        if (deviceActor == nil) {
            deviceActor = BLEActor(deviceState: metaData ?? [:], servicesMeta: DictFromFile(kServiceMeta), operationsMeta: DictFromFile(kCommandMeta))
            deviceActor.setPeripheral(peripharal)
            appDelegate_.deviceActors.insert(deviceActor, at: 0)
            PostNoteBLE("NewDeviceFound", deviceActor)
        }
        else {
            deviceActor.setPeripheral(peripharal)
        }
        PostNoteBLE(kScanResultPeripheralFound, deviceActor)
    }
    
    func retrievePeripherals() {
//        print(#function,"scanning for peripherals with service UUIDs \(serviceUUIDs)")
        let options: [String: Any] = [ CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber.init(value: true)]
        centralManager?.scanForPeripherals(withServices: serviceUUIDs, options: options)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print(#function,"BT Update state \(central.state.rawValue)")
        PostNoteBLE(kBluetoothStateUpdate, central)
        if #available(iOS 10.0, *) {
            if central.state == CBManagerState.poweredOn  {
                print("bluetooth state on")
            }else if central.state == CBManagerState.poweredOff {
                print("bluetooth state off")
            }
        } else {
        }
    }
    
    func centralManager(_ central: CBCentralManager, didRetrieveConnectedPeripherals peripherals: [CBPeripheral]) {
//        print(#function,"didRetrieveConnectedPeripherals \(peripherals)")
    }
    
    func centralManager(_ central: CBCentralManager, didRetrievePeripherals peripherals: [CBPeripheral]) {
//        print(#function,"didRetrievePeripherals \(peripherals)")
        self.peripherals .forEach { (peripheral) in
            add(peripheral as! CBPeripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
                var deviceName : String! = "Unknown"
                if advertisementData["kCBAdvDataLocalName"] != nil {
                    deviceName = (advertisementData["kCBAdvDataLocalName"] as! String)
                } else {
                    if peripheral.name != nil && peripheral.name != "" {
                        deviceName = peripheral.name ?? "Unknown"
                    }
                }
//                if deviceName != "Unknown" {
                    print(deviceName)
                    print("------------------------------------------------------------------")
                    self.dicScannedDeviceTimestamp[String.init(peripheral.identifier.uuidString)] = Int(Date().timeIntervalSince1970)
                    
                    let idx: Int = (peripherals as NSArray).index(of: peripheral)
                    if NSNotFound == idx {
                        if !self.peripherals.contains(deviceName) {
                            self.peripherals.insert(peripheral, at: 0)
                        }
                    }
                    
                    var intRSSIVal : Int! = -100
                    if RSSI != 127 {
                        intRSSIVal = Int.init(exactly: RSSI)
                    }
                    
                    var macAddressString = ""
                    if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
                        macAddressString = manufacturerData.hexString
                    }
                    
                    let isConnectable = advertisementData["kCBAdvDataIsConnectable"] as? Bool ?? false
                    
                    for objBleDevice in self.arrDeviceList {
                        if objBleDevice.peripharal.identifier.uuidString == peripheral.identifier.uuidString {
                            if let index = appDelegate_.centralManagerActor.arrDeviceList.index(of: objBleDevice) {
                                if self.arrDeviceList.count > index {
                                    self.arrDeviceList[index].timestamp = Int(Date().timeIntervalSince1970)
                                    self.arrDeviceList[index].deviceName = deviceName
                                    self.updateRSSI(index: index, RSSI: intRSSIVal! as NSNumber)
                                }
                            }
                            return
                        }
                    }
                    let objBLEModel : BlePeripharalModel = BlePeripharalModel.init(peripheral, macAddressString, deviceName, nil, false, isConnectable, Int(Date().timeIntervalSince1970), [Double(truncating: RSSI)], intRSSIVal , false)
                    self.arrDeviceList.append(objBLEModel)
                    
                    PostNoteWithInfo(kScanResultPeripheralFound, peripheral, ["advertisementData": advertisementData, "Rssi" : RSSI])
    }
    func updateRSSI(index : Int, RSSI : NSNumber) {
        if self.arrDeviceList.count > index {
            if let listRssi = self.arrDeviceList[index].arrRssi {
                if listRssi.count > 0 {
                    if RSSI != 127 {
                        if self.arrDeviceList.count > index {
                            if self.arrDeviceList[index].arrRssi.count >= 10 {
                                self.arrDeviceList[index].arrRssi.remove(at: 0)
                            }
                            self.arrDeviceList[index].arrRssi.append(Double(truncating: RSSI))
                        }
                    }
                }
            }
            let intAVGRSSI : Int =  Int(round(self.getAveragePeripharalRSSI(peripheralUUID: self.arrDeviceList[index].peripharal.identifier.uuidString)))
            
            if arrDeviceList.count > index {
                self.arrDeviceList[index].avgRSSI = intAVGRSSI
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print(#function,"centralManager >> didConnectPeripheral : \(peripheral)")
        add(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print(#function,"centralManager >> didFailToConnect : \(peripheral) Error : \(error.debugDescription)")
        PostNoteWithInfo(kFailedToConnectPeripheral, peripheral, ["error": error!])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        print(#function,"centralManager >> didDisconnectPeripheral : \(peripheral), Error: \(error.debugDescription)}")
        PostNoteBLE(kPeripheralStateChanged, peripheral)
        //  reconnectionDevice()
    }

    
    func reconnectionDevice() {
        if appDelegate_.deviceActors.count > 0 {
            let deviceActor: BLEActor? = getDefaultActor()
            if deviceActor != nil{
                if !deviceActor!.isConnected(){
                    reconnectWithActor(deviceActor!)
                }
            }
        }
    }
    
    func didEnterBackgroundNotification(_ notification: Notification) {
//        print(#function,"Entered background notification called.")
        centralManager?.stopScan()
    }
    func didEnterForegroundNotification(_ notification: Notification) {
//        print(#function,"Entered foreground notification called.")
        retrievePeripherals()
    }
    
    func getPeripheralRSSIList(peripheralUUID: String) -> [Double] {
        for objBleModel in self.arrDeviceList {
            if objBleModel.peripharal.identifier.uuidString == peripheralUUID {
                if var val  = objBleModel.arrRssi {
                    if val.count >= 10 {
                        val = val.sorted(by: { (obj1, obj2) -> Bool in
                            return obj1 > obj2
                        })
                        val.remove(at: 0)
                        val.removeLast()
                        val.removeLast()
                    }
                    return val
                }
            }
        }
        return []
    }
    
    func getAveragePeripharalRSSI(peripheralUUID : String) -> Double {
        let arrRssiList : [Double] = getPeripheralRSSIList(peripheralUUID: peripheralUUID)
        if arrRssiList.count == 0 {
            return -100
        } else {
            var avgVal : Double = 0
            for val in arrRssiList {
                avgVal = avgVal + val
            }
            return avgVal / Double(arrRssiList.count)
        }
    }
}

// BLEActor responible for managing In/Out commands with hardware device, managing command Queues.
class BLEActor: NSObject {
    
    var peripheralActor: PeripheralActor!
    var state = NSMutableDictionary()
    var propertiesToCharacteristics = NSMutableDictionary()
    var servicesMeta = NSDictionary()
    var commandsMeta = NSDictionary()
    var commandInProgress = NSMutableDictionary()
    var commandTimeoutTimer: Timer?
    var commandsQueue = NSMutableArray()
    var didReadCharacteristicsCounter: Int = 0
    var queue: OperationQueue?
    var isDeviceIsReady: Bool = false
    var batteryLevel: Float = 0.0
    var teamId:Int = 0
    
    override init() {
        super.init()
    }
    init(deviceState aState:NSMutableDictionary, servicesMeta aServicesMeta:NSDictionary, operationsMeta aOperationsMeta:NSDictionary) {
        super.init()
        self.state = aState
        self.servicesMeta = aServicesMeta
        self.commandsMeta = aOperationsMeta
        self.commandsQueue = NSMutableArray()
        self.queue = OperationQueue()
    }
    
    
    func isActor(_ peripheral: CBPeripheral) -> Bool {
        if (self.peripheralActor?.peripheral != nil) {
            return self.peripheralActor?.peripheral == peripheral || self.peripheralActor?.peripheral!.identifier == peripheral.identifier
        }
        let peripheralUUID: String = peripheral.identifier.uuidString
        return ((state[Constants.kPeripheralUUIDKey] as? String) == peripheralUUID)
    }
    
    //To check BLE Actor is connected or not
    func isConnected() -> Bool {
        if (self.peripheralActor?.peripheral != nil) {
            return self.peripheralActor!.peripheral!.state == .connected
        } else {
            return false
        }
        
    }
    
    func descriptionDetail() -> String {
        return "\(super.description). Peripheral Actor: \(String(describing: peripheralActor)), State: \(state)"
    }
    
    func setPeripheral(_ peripheral: CBPeripheral) {
        if (self.peripheralActor != nil) {
            if self.peripheralActor?.peripheral == peripheral {
                return
            }
//            print(#function,"setPeripheral")
            UnregisterFromNotesFromObject(self,peripheralActor!)
        }
//        print(#function,"________________________SET PERIPHERAL________________________")
        peripheralActor = PeripheralActor(peripheral: peripheral)
        
        //        RegisterForNoteWithObject
        
        RegisterForNoteWithObject(selector: #selector(BLEActor.PeripheralStateChanged(_:)),key: kPeripheralStateChanged, observer: self, object: self.peripheralActor?.peripheral! as Any)
        RegisterForNoteWithObject(selector: #selector(BLEActor.PeripheralDidDiscoverServices(_:)),key: kPeripheralDidDiscoverServices, observer: self, object: self.peripheralActor?.peripheral! as Any)
        RegisterForNoteWithObject(selector: #selector(BLEActor.PeripheralDidDiscoverCharacteristicsForService(_:)),key: kPeripheralDidDiscoverCharacteristicsForService, observer: self, object: self.peripheralActor?.peripheral! as Any)
        RegisterForNoteWithObject(selector: #selector(BLEActor.PeripheralDidUpdateValue(forCharacteristic:)),key: kPeripheralDidUpdateValueForCharacteristic, observer: self, object: self.peripheralActor?.peripheral! as Any)
        RegisterForNoteWithObject(selector: #selector(BLEActor.PeripheralDidWriteValueForCharacteristic(_:)),key: kPeripheralDidWriteValueForCharacteristic, observer: self, object: self.peripheralActor?.peripheral! as Any)
        
        self.state[Constants.kPeripheralUUIDKey] =  peripheral.identifier.uuidString
        
        if (peripheral.name != nil) {
            state[Constants.kDeviceName] = peripheral.name
        }
        if peripheral.state == .connected {
            peripheralActor?.discoverServices(CBUUIDsFromNSStrings(strings:Array(self.servicesMeta.allKeys) as! [String]))
        }
    }
    
    @objc func PeripheralDidDiscoverServices(_ note: Notification) {
//        print(#function,"________________________DISCOVER SERVICES________________________")
        let services: [CBService] = NSMutableDictionary.init(dictionary: note.userInfo!)["services"] as! [CBService]
        self.didReadCharacteristicsCounter = 0
//        print(#function,"services array \(services)")
        services.forEach { (s) in
            var UUID: String = NSStringFromCBUUID(s.uuid)
            if (UUID.count) > 15 {
                UUID = String(format:"%@-%@-%@-%@-%@",UUID.substring(from: 0, length: 8),UUID.substring(from: 8, length: 4),UUID.substring(from: 12, length: 4),UUID.substring(from: 16, length: 4),UUID.substring(from: 20, length: 12))
//                print(#function,"service UUID 128bit \(UUID)")
            }
            
            var strUUID = ""
            strUUID = UUID.lowercased()
            let properties: [String: Any] = self.servicesMeta.value(forKey:strUUID) as! [String : Any]
            if !properties.isEmpty {
                self.peripheralActor?.discoverCharacteristics(CBUUIDsFromNSStrings(strings: Array(properties.keys)), for: s)
                didReadCharacteristicsCounter += 1
            }
        }
    }
    
    @objc func PeripheralDidDiscoverCharacteristicsForService(_ note: Notification) {
//        print(#function,"________________________DISCOVER CHARACTERISTICS________________________")
        // MARK: make sure all characteristics are discovered for all peripheral services
        let service: CBService = NSMutableDictionary.init(dictionary: note.userInfo!)["service"] as! CBService
        let characteristics: [CBCharacteristic] = NSMutableDictionary.init(dictionary: note.userInfo!)["characteristics"] as! [CBCharacteristic]
        
        characteristics.forEach { (c) in
//            print(#function,"service UUID: \(service.uuid.uuidString) , characteristics: UUID:\(c.uuid.uuidString) properties: \(c.properties))")
        }
        
        var serviceUUIDStr: String = NSStringFromCBUUID(service.uuid)
        if (serviceUUIDStr.count) > 15 {
            serviceUUIDStr = String(format:"%@-%@-%@-%@-%@",serviceUUIDStr.substring(from: 0, length: 8),serviceUUIDStr.substring(from: 8, length: 4),serviceUUIDStr.substring(from: 12, length: 4),serviceUUIDStr.substring(from: 16, length: 4),serviceUUIDStr.substring(from: 20, length: 12))
//            print(#function,"service UUID 128bit \(serviceUUIDStr)")
        }
        let serviceMeta: [String: NSMutableDictionary] = servicesMeta[serviceUUIDStr.lowercased()] as! [String : NSMutableDictionary]
//        print(#function,"service meta: %@",serviceMeta)
        if serviceMeta.keys.count == 0 {
            return;
        }
        serviceMeta.forEach { (_ characteristicUUIDStr:String, _ meta: NSDictionary) in
            let characteristicPath: String = CharacteristicPathWithArray([serviceUUIDStr, characteristicUUIDStr])
            
            if meta["isObservable"] != nil {
                // FIXME: move to peripheral actor
                let characteristic: CBCharacteristic? = peripheralActor?.peripheral?.characteristic(withPath: characteristicPath)
                if nil != characteristic {
//                    print(#function,"observing characteristic with path \(characteristicPath), properties: \(String(describing: characteristic?.properties))")
                    if (CBCharacteristicProperties.notify.rawValue & (characteristic?.properties.rawValue)!) != 0 {
                        peripheralActor?.peripheral?.setNotifyValue(true, for: characteristic!)
                    }
                    else {
//                        print(#function,"WARN: characteristic with path \(characteristicPath) does not support notifications")
                    }
                }
                else {
//                    print(#function,"WARN: could not find characteristic with path \(characteristicPath) to observe")
                }
            }
        }
        
        didReadCharacteristicsCounter -= 1
        if didReadCharacteristicsCounter == 0 {
//            print(#function,"________________________DID DISCOVER CHARACTERISTICS________________________")
//            print(#function,"________________________DEVICE IS READY_________________________")
            self.isDeviceIsReady = true
            PostNoteWithInfo(kDeviceIsReady, self, state)
        }
    }
    
    
    func propertyMeta(for characteristic: CBCharacteristic) -> [AnyHashable: Any]? {
        var characteristicPath: String = characteristic.path()
        let components: [String] = characteristicPath.components(separatedBy:Constants.kCBPathDelimiter)
        if components.count > 1 {
            var serviceUUIDStr: String = components[0]
            var charactStr: String = components[1]
            if (serviceUUIDStr.count) > 15 {
                serviceUUIDStr = "\((serviceUUIDStr as NSString).substring(with: NSRange(location: 0, length: 8)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 8, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 12, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 16, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 20, length: 12)))"
//                print(#function,"service UUID 128bit \(serviceUUIDStr)")
            }
            if (charactStr.count) > 15 {
                charactStr = "\((charactStr as NSString).substring(with: NSRange(location: 0, length: 8)))-\((charactStr as NSString).substring(with: NSRange(location: 8, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 12, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 16, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 20, length: 12)))"
//                print(#function,"service UUID 128bit \(charactStr)")
            }
            characteristicPath = "\(serviceUUIDStr).\(charactStr)"
        }
        let propertyMetaValue = servicesMeta.value(forKeyPath: characteristicPath.lowercased()) as! [String : Any]
        guard !propertyMetaValue.isEmpty else {
//            print(#function,"propertyMetaForCharacteristic>> WARN: no property with path \(characteristicPath) in services metadata: \(servicesMeta)")
            return nil
        }
        return propertyMetaValue
    }
    
    func propertyName(for characteristic: CBCharacteristic) -> String {
        return propertyMeta(for: characteristic)!["name"] as! String
    }
    
    func stopCommands() {
//        print(#function,"stopping all activity scheduled: \(commandsQueue) and in progress: \(commandInProgress)")
        self.commandTimeoutTimer?.invalidate()
        self.commandTimeoutTimer = nil
        self.commandInProgress .removeAllObjects()
        commandsQueue = NSMutableArray()
    }
    
    @objc func PeripheralStateChanged(_ note: Notification) {
        let peripheral: CBPeripheral? = (note.object as! CBPeripheral)
        if peripheral?.state == .connected {
            if self.state[Constants.kPeripheralUUIDKey] != nil && ((peripheral?.identifier) != nil) {
                state[Constants.kPeripheralUUIDKey] = peripheral?.identifier.uuidString
            }
//            print(#function,"peripheralStateChanged >> discoverServices")
            peripheralActor?.discoverServices(CBUUIDsFromNSStrings(strings: servicesMeta.allKeys as! [String]))
        }
        else {
            stopCommands()
            PostNoteBLE(kDeviceDisconnected, self)
        }
    }
    
    @objc func PropertyUpdated(_ note: Notification) {
        let userInfo = NSMutableDictionary.init(dictionary: note.userInfo!)
        let characteristic: CBCharacteristic? =  userInfo["characteristic"] as? CBCharacteristic
        var characteristicPath: String? = characteristic?.path()
        let components: [String] = (characteristicPath?.components(separatedBy: Constants.kCBPathDelimiter))!
        if (components.count) > 1 {
            
            var serviceUUIDStr: String = components[0]
            var charactStr: String = components[1]
            
            if (serviceUUIDStr.count) > 15 {
                serviceUUIDStr = "\((serviceUUIDStr as NSString).substring(with: NSRange(location: 0, length: 8)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 8, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 12, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 16, length: 4)))-\((serviceUUIDStr as NSString).substring(with: NSRange(location: 20, length: 12)))"
//                print(#function,"service UUID 128bit \(serviceUUIDStr)")
            }
            if (charactStr.count) > 15 {
                charactStr = "\((charactStr as NSString).substring(with: NSRange(location: 0, length: 8)))-\((charactStr as NSString).substring(with: NSRange(location: 8, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 12, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 16, length: 4)))-\((charactStr as NSString).substring(with: NSRange(location: 20, length: 12)))"
//                print(#function,"service UUID 128bit \(charactStr)")
            }
            characteristicPath = "\(serviceUUIDStr).\(charactStr)"
        }
        let propertyMetaValue = servicesMeta.value(forKeyPath: characteristicPath!.lowercased()) as! NSDictionary
        if propertyMetaValue.allKeys.count == 0 {
//            print(#function,"propertyUpdated>> WARN: no property with path \(String(describing: characteristicPath)) in services metadata: \(servicesMeta)")
            return
        }
        
        let name = propertyMetaValue.value(forKey: "name") as! String
        var val: Any
        if (propertyMetaValue.value(forKey: "type") as! NSString).isEqual(to: "data") {
            val = userInfo["value"] as! Data
        }
        else if ((propertyMetaValue.value(forKey: "type") as! NSString).isEqual(to: "string")) {
            let stringData = NSString.init(data: userInfo.value(forKey: "value") as! Data, encoding:String.Encoding.utf8.rawValue)
            val = stringData!
        }
        else if ((propertyMetaValue.value(forKey: "type") as! NSString).isEqual(to: "integer")) {
            val = Int(characteristic!.value![0])
        }
        else {
            val = characteristic?.valueWithType(withType: (propertyMetaValue.value(forKey:"type") as! String)) as Any
        }
        if (val == nil)  {
            val = NSNull()
        }
        val = transformValue(val, ofProperty: name, direction: kValueTransformDirection.In)
        var oldValue: Any? = state[name]
        if nil == oldValue {
            oldValue = NSNull()
        }
//        print(#function,"{propertyMeta: \(propertyMetaValue), value: \(val), oldValue: \(String(describing: oldValue))}")
        if val == nil {
            return
        }
        state[name] = val
        PostNoteWithInfo(kDeviceDidUpdateProperty, self, ["name": name, "value": val, "oldValue": oldValue!])
//        print(#function,"Property Updated -- name")
        if isCommand(inProgressPerformingOperation: Constants.kPropertyOperationRead, onProperty: name) {
            processReadCommandOperation(withValue: val)
        }
        else if isCommand(inProgressPerformingOperation: Constants.kPropertyOperationReadWait, onProperty: name) {
//            print(#function,"Property Updated -- \(name)")
            processReadWaitCommandOperation(withValue: val)
        }
        else {
//            print(#function,"DID GET NOTIFICATION FROM DEVICE")
            PostNoteWithInfo(kDeviceDidSendNotification, self, ["name": name, "value": val])
        }
    }
    
    func processReadCommandOperation(withValue val: Any) {
        let comm: NSMutableDictionary = self.commandInProgress
        let op: NSMutableDictionary = comm["propertyOperationInProgress"] as! NSMutableDictionary
        op["readValue"] = val
        continueCommandInProgress()
    }
    
    func processReadWaitCommandOperation(withValue val: Any) {
        
    }
    
    @objc func PeripheralDidUpdateValue(forCharacteristic note: Notification) {
        //        print(#function,"*********property updated********* \(note)")
        perform(#selector(self.PropertyUpdated(_:)), with: note, afterDelay: 0.2)
    }
    
    func isCommand(inProgressPerformingOperation operation: String, onProperty property: String) -> Bool {
        if self.commandInProgress.allKeys.count == 0 {
            return false
        }
        let propertyOperationInProgress: NSDictionary = self.commandInProgress.value(forKey: "propertyOperationInProgress") as! NSDictionary
        if propertyOperationInProgress.value(forKey: "operation") != nil {
            if propertyOperationInProgress.value(forKey: "name") != nil {
                return true
            }
        }
        return false
    }
    
    func commandFailedWithError(_ err: Error?) {
        let command: NSDictionary = self.commandInProgress
        self.commandTimeoutTimer?.invalidate()
        self.commandTimeoutTimer = nil
        PostNoteWithInfo(kDeviceFailedToPerformCommand, self, ["name": command["name"]!, "command": command, "error": err!])
        self.commandInProgress.removeAllObjects()
        processNextCommandInQueue()
    }
    
    func processNextCommandInQueue() {
//        print(#function,"queue: \(commandsQueue)")
        if self.commandsQueue.count != 0 {
            let nextCommand = NSMutableDictionary.init(dictionary: self.commandsQueue.shift()! as! NSDictionary)
            print(#function,"next command: \(nextCommand)")
            performCommand((nextCommand["command"] as? String)!, withParams: (nextCommand["params"] as! NSMutableDictionary), metaValue: nextCommand["meta"] as! NSDictionary)
        }
    }
    
    func continueCommandInProgress()
    {
        commandTimeoutTimer?.invalidate()
        let command = self.commandInProgress
//        print(#function,"Command :- \(command)")
        
        if let currentPropertyOperation = command.value(forKey: "propertyOperationInProgress") as? NSDictionary {
            let arrayOfCompletedOperations = command.value(forKey: "completedPropertyOperations") as! NSMutableArray
            arrayOfCompletedOperations.push(currentPropertyOperation)
            command.setValue(arrayOfCompletedOperations, forKey: "completedPropertyOperations")
        }
        let nextPropertyOperation = (self.commandInProgress["propertyOperations"] as! NSMutableArray).shift()
        if nextPropertyOperation == nil {
            // Command complete from client side
            self.commandTimeoutTimer?.invalidate()
            self.commandTimeoutTimer = nil
            command.setValue(NSMutableDictionary(), forKey:"propertyOperationInProgress")
            let completedCommand = NSMutableDictionary()
            completedCommand.addEntries(from: command as! [AnyHashable : Any])
            PostNoteWithInfo("DeviceDidPerformCommand", self, completedCommand)
            self.commandInProgress.removeAllObjects()
            processNextCommandInQueue()
            return
        }
        
        command .setValue(nextPropertyOperation, forKey: "propertyOperationInProgress")
        commandTimeoutTimer = Timer.scheduledTimer(timeInterval: Constants.kCommandPropertySetTimeout, target: self, selector: #selector(self.commandTimeout(_:)), userInfo: nil, repeats: false)
        
        guard (nextPropertyOperation as? NSMutableDictionary) != nil else {
//            print(#function,"NextOperation is null \(String(describing: nextPropertyOperation))")
            return
        }
        
        let nextOperation = NSMutableDictionary.init(dictionary: nextPropertyOperation as! NSDictionary)
        let strOperationType = nextOperation .value(forKey: "operation") as! NSString
        if (NSString.init(string:Constants.kPropertyOperationWrite).isEqual(to:strOperationType as String)) {
            self.writeProperty(nextOperation.value(forKey: "name") as! String, withValue: nextOperation.value(forKey: "value") as Any)
        }else if (NSString.init(string:Constants.kPropertyOperationReadWait).isEqual(to:strOperationType as String)) {
//            print(#function,"waiting for property \(String(describing: nextPropertyOperation))")
        }
        else {
            self.readProperty(nextOperation.value(forKey: "name") as! String)
        }
    }
    
    @objc func commandTimeout(_ timer: Timer) {
//        print(#function,"command timed out: \(commandInProgress)")
        commandTimeoutTimer = nil
        commandFailedWithError(MyError.init(msg: "command timed out"))
    }
    
    func writeProperty(_ property: String, withValue value: Any) {
        let characteristicPath: String = PropertyCharacteristicPath(property: property, servicesMeta: servicesMeta, actor: self)!
//        print(#function,"characteristicPath \(characteristicPath)")
        
        let meta = servicesMeta.value(forKeyPath: characteristicPath.lowercased()) as! NSDictionary
//        print(#function,"writing property: \(property), characteristic path: \(characteristicPath), value: \(value), meta: \(meta)")
        
        let transformedValue = transformValue(value, ofProperty: property, direction: kValueTransformDirection.Out)
//        print(#function,"transformed value: \(String(describing: transformedValue))")
        var valueData: NSData = transformedValue as! NSData
        let propertyType: String = meta.value(forKey: "type") as! String
        if ("string" == propertyType) {
            if valueData.isKind(of: NSString.self)  {
                let stringValue: String = transformedValue as! String
                valueData = stringValue.data(using: String.Encoding.utf8)! as NSData
            }
        }
        else if ("integer" == propertyType) {
            if (transformedValue is NSNumber) {
                valueData = Data.init(from: transformedValue) as NSData
            }
        }
//        print(#function,"Value Data ", valueData)
        self.peripheralActor?.write(valueData as Data, forCharacteristicPath: characteristicPath)
    }
    
    func readProperty(_ property: String) {
        let characteristicPath: String = PropertyCharacteristicPath(property: property, servicesMeta: self.servicesMeta, actor: self)!
//        print(#function,"reading property: \(property), characteristic path: \(characteristicPath)")
        self.peripheralActor?.readValue(forCharacteristicPath: characteristicPath)
    }
    
    func notifyProperty(_ property: String, isEnable : Bool) {
        DispatchQueue.main.async {
            let characteristicPath: String = PropertyCharacteristicPath(property: property, servicesMeta: self.servicesMeta, actor: self)!
//            print(#function,"notify property: \(property), characteristic path: \(characteristicPath)")
            self.peripheralActor?.notifyValue(forCharacteristicPath: characteristicPath, isEnable: isEnable)
        }
    }
    
    func performCommand(_ command: String, withParams params: NSMutableDictionary, metaValue: NSDictionary! = nil) {
        var meta = NSMutableDictionary.init(dictionary: metaValue)
        if meta.allKeys.count == 0 {
            meta = self.commandsMeta.value(forKey: command) as! NSMutableDictionary
        }
        if !isConnected() {
            return
        }
        if (self.commandInProgress.allKeys.count > 0) {
            let commandToEnqueue = NSMutableDictionary.init(dictionary:["command": command, "params": params])
            if meta.allKeys.count != 0 {
                commandToEnqueue["meta"] = meta
            }
//            print(#function,"command is in progress: commandInProgress, enqueueing commandToEnqueue")
            commandsQueue.push(commandToEnqueue)
            return
        }
//        print(#function,"command: \(command), meta: \(meta), params: \(params)", command, meta, params)
        
        let propertyOperations = NSMutableArray()
        
        let arrProperty:[NSDictionary] = meta.value(forKey:"properties") as! [NSDictionary]
        
        for obj in arrProperty {
            let propertyOperation = NSMutableDictionary.init(dictionary: obj)
            let strOperationType = propertyOperation.value(forKey: "operation") as! NSString
            if (NSString.init(string:Constants.kPropertyOperationWrite).isEqual(to:strOperationType as String) && !(propertyOperation.object(forKey: "value") != nil)) {
                let valueStr:String = propertyOperation.value(forKey: "name") as! String
                propertyOperation.setValue(params.value(forKey:valueStr), forKey: "value")
            }
            propertyOperations.add(propertyOperation)
        }
//        print(#function,"Property operations \(propertyOperations)")
        let completedOperations = NSMutableArray()
        self.commandInProgress = ["propertyOperations": propertyOperations, "name": command, "completedPropertyOperations":completedOperations]
        PostNoteWithInfo(kDeviceWillPerformCommand, self, commandInProgress)
        continueCommandInProgress()
    }
    
    func performCommand(_ command: String, withParams params:NSMutableDictionary) {
//        print(#function,"Command - \(command)")
        performCommand(command, withParams: params, metaValue:[:])
    }
    
    @objc func PeripheralDidWriteValueForCharacteristic(_ note: Notification) {
        let userInfo = note.userInfo as NSDictionary?
        let property: String = self.propertyName(for: userInfo?.value(forKey: "characteristic") as! CBCharacteristic)
        if isCommand(inProgressPerformingOperation: Constants.kPropertyOperationWrite, onProperty: property) {
            continueCommandInProgress()
            return
        }
        //self.PropertyUpdated(note)
    }
    
    func transformValue(_ val: Any, ofProperty name: String, direction dir: kValueTransformDirection) -> Any {
        let commandName =  self.commandInProgress[Constants.kName] as? String
        if (commandName != nil) {
            switch commandName {
            case BleCommands.kCommand_CamOne:
                return transformCam_1_on_off_Command(val, withDirection: dir)
            case BleCommands.kCommand_CamTwo:
                return transformCam_2_on_off_Command(val, withDirection: dir)
            case BleCommands.kCommand_CamThree:
                return transformCam_3_on_off_Command(val, withDirection: dir)
            case BleCommands.kCommand_CamFour:
                return transformCam_4_on_off_Command(val, withDirection: dir)
            case .none: break
                
            case .some(_): break
                
            }
        }
        return val
    }
    
    //write Data as Json to device
    
    func transformCam_1_on_off_Command(_ val: Any, withDirection direction: kValueTransformDirection) -> Any {
        if kValueTransformDirection.In == direction {
            return val
        }
        var payloadData :Data = Data.init()
            payloadData.append(contentsOf: [CommandID.cam_1_on_off])
        
//        print("___________PayloadHEXString___________")
//            print(payloadData.hexString)
//        print("______________________________________")
//
        return payloadData
    }
    func transformCam_2_on_off_Command(_ val: Any, withDirection direction: kValueTransformDirection) -> Any {
        if kValueTransformDirection.In == direction {
            return val
        }
        var payloadData :Data = Data.init()
            payloadData.append(contentsOf: [CommandID.cam_2_on_off])
        
//        print("___________PayloadHEXString___________")
//            print(payloadData.hexString)
//        print("______________________________________")
//
        return payloadData
    }
    func transformCam_3_on_off_Command(_ val: Any, withDirection direction: kValueTransformDirection) -> Any {
        if kValueTransformDirection.In == direction {
            return val
        }
        var payloadData :Data = Data.init()
            payloadData.append(contentsOf: [CommandID.cam_3_on_off])
        
//        print("___________PayloadHEXString___________")
//            print(payloadData.hexString)
//        print("______________________________________")
//
        return payloadData
    }
    func transformCam_4_on_off_Command(_ val: Any, withDirection direction: kValueTransformDirection) -> Any {
        if kValueTransformDirection.In == direction {
            return val
        }
        var payloadData :Data = Data.init()
            payloadData.append(contentsOf: [CommandID.cam_4_on_off])
        
//        print("___________PayloadHEXString___________")
//            print(payloadData.hexString)
//        print("______________________________________")
//
        return payloadData
    }
}
