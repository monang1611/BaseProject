
//  CBUtils.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.


import UIKit
import CoreFoundation
import CoreBluetooth
import CommonCrypto

class CBUtils: NSObject {
    
}
func getDefaultActor() -> BLEActor? {
    if (appDelegate_.deviceActors.count) > 0 {
        return (appDelegate_.deviceActors[0])
    }
    return nil
}

/// Filter based on peripharal uuid
/// - Parameter strPeripharalUUID: UUID of Peripharal
/// - Returns: BLEActor
func getActorFromPeripharalUUID(strPeripharalUUID : String) -> BLEActor? {
    for objActor in appDelegate_.deviceActors {
        if let peripharalUUID = objActor.state[Constants.kPeripheralUUIDKey] as? String {
            if peripharalUUID.lowercased() == strPeripharalUUID.lowercased() {
                return objActor
            }
        }
    }
    return nil
}
func getActorForMacAddress(strMacAddress : String) -> BLEActor? {
    for objActor in appDelegate_.deviceActors {
        if let peripharalMac = objActor.state["mac_address"] as? String {
            if peripharalMac.lowercased() == strMacAddress.lowercased() {
                return objActor
            }
        }
    }
    return nil
}


func reconnectWithActor(_ deviceActor: BLEActor) {
    let peripheral: CBPeripheral? = deviceActor.peripheralActor?.peripheral
    if peripheral == nil {
//        AppDelegate_.centralManagerActor.retrievePeripherals()

        ///start ble scanning
        //
        let uuid = UUID(uuidString: deviceActor.state[Constants.kPeripheralUUIDKey] as! String)
//        print(#function,"UUID \(String(describing: uuid?.uuidString))")
        appDelegate_.centralManagerActor.centralManager?.retrievePeripherals(withIdentifiers: [uuid!]).forEach({ (p) in
            appDelegate_.centralManagerActor.add(p)
        })
        return
    }
    appDelegate_.centralManagerActor.centralManager?.connect(peripheral!, options: nil)
    appDelegate_.centralManagerActor.centralManager?.retrieveConnectedPeripherals(withServices:[]).forEach({ (p) in
        if (p.identifier.uuidString == (deviceActor.state[Constants.kPeripheralUUIDKey]) as! String) {
            appDelegate_.centralManagerActor.add(p)
        }
    })
}

func CBUUIDsFromNSStrings(strings: [String]) -> [CBUUID] {
//    print(#function,"CBUUIDsFromNSStrings \(strings)")
    var finalUUID = [CBUUID]()
    for strUUID in strings {
        finalUUID.append(CBUUID(string: strUUID))
    }
    return finalUUID
}

func NSStringsFromCBUUIDs(cbUUIDs: [CBUUID]) -> [String] {
    var finalUUID = [String]()
    for strUUID in cbUUIDs {
        finalUUID.append(NSStringFromCBUUID(strUUID))
    }
    return finalUUID
}

func CharacteristicPathWithArray(_ arr: [String]) -> String {
    return (arr as NSArray).componentsJoined(by: Constants.kCBPathDelimiter)
}

func PropertyCharacteristicPath(property: String, servicesMeta: NSDictionary, actor: BLEActor) -> String? {
    var serviceUUIDStr: String? = nil
    var characteristicUUIDStr: String? = nil
    for serviceUUID in servicesMeta.allKeys {
//        print(#function,"finding property \(serviceUUID)")
        serviceUUIDStr = serviceUUID as? String
        
        let charData = servicesMeta.value(forKey: serviceUUIDStr!) as! NSDictionary
        for charUUID in charData.allKeys {
            let dicData = charData .value(forKey: charUUID as! String) as! NSDictionary
            if (property == (dicData.value(forKey: "name") as! String)) {
                characteristicUUIDStr = charUUID as? String;
                break;
            }
        }
        
        if characteristicUUIDStr != nil {
            break
        }
    }
    if characteristicUUIDStr != nil {
        return ([serviceUUIDStr!, characteristicUUIDStr!] as NSArray).componentsJoined(by: Constants.kCBPathDelimiter)
    }
    return nil
}

func RegisterForNoteWithObject( selector:Selector,  key: String,  observer: Any,  object: Any) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(key)
                                           , object: object)
}

func inverseFourByte(data : Data) -> Data {
    let arrayData = [UInt8](data)
    let arrInvertedData : [UInt8] = [arrayData[3],arrayData[2],arrayData[1],arrayData[0]]
    return Data.init(bytes: arrInvertedData, count: 4)
}

extension Dictionary where Value: Equatable {
    func checkKey(value : Value) -> Bool {
        return self.contains { $0.1 == value }
    }
}

func NSStringFromCBUUID(_ uuid: CBUUID) -> String {
    return uuid.data.hexString;
}

func GetUUID() -> String {
    let theUUID: CFUUID = CFUUIDCreate(nil)
    let string: CFString = CFUUIDCreateString(nil, theUUID)
    return (string as? String)!
}

func DictFromFile(_ filename: String) -> NSMutableDictionary {
    let filepathData: String? = Bundle.main.path(forResource: filename, ofType: nil)
    return NSMutableDictionary.init(contentsOfFile: filepathData!)!;
}

func ArrayFromFile(_ filename: String) -> NSMutableArray {
    let filepathData: String? = Bundle.main.path(forResource: filename, ofType: nil)
    return NSMutableArray.init(contentsOfFile: filepathData!)!;
}

func ReadValue(_ storageKey: String) -> Any {
    return UserDefaults.standard.value(forKey: storageKey) as Any
}

func StoreValue(_ storageKey:String,_ value : Any) {
    UserDefaults.standard.setValue(value, forKey: storageKey)
    UserDefaults.standard.synchronize();
}

func LoadObjects(_ storageKey: String) -> [Any] {
    let archived: Data? = ReadValue(storageKey) as? Data
//    print(#function,"archived: \(String(describing: archived))")
    if archived == nil {
        return []
    }
    let objects: [Any]? = NSKeyedUnarchiver.unarchiveObject(with: archived!) as? [Any]
//    print(#function,"Key \(storageKey) Value: \(String(describing: objects))")
    return objects!
}

func StoreObjects(_ storageKey: String, _ objects: [Any]) {
    let archived:Data = NSKeyedArchiver.archivedData(withRootObject: objects)
//    print(#function,"\(storageKey) : \(objects), archived: \(String(describing: archived))")
    StoreValue(storageKey, archived)
}


func PostNoteBLE(_ key: String, _ object: Any) {
//    print(#function,"posting notification \(key) with object \(object)")
    DispatchQueue.main.async(execute: {() -> Void in
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: key), object: object)
    })
}

func PostNoteWithInfo(_ key: String, _ object: Any, _ info: NSMutableDictionary) {
//    print(#function,"posting notification \(key) with object \(object), info: \(info)")
    DispatchQueue.main.async(execute: {() -> Void in
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: key),object: object, userInfo: (info as! [String : Any]))
    })
}

func RegisterForNotes(_ selector:Selector, _ noteKeys: [Any], _ observer: Any) {
    noteKeys .forEach { (strKey) in
        RegisterForNote(selector,strKey as! String, observer)
    }
}

func RegisterForNotesFromObject(_ selector:Selector, _ noteKeys: [Any], _ observer: Any, _ object: Any) {
    noteKeys .forEach { (key) in
        RegisterForNoteFromObject(selector,key as! String, observer, object)
    }
}

func RegisterForNoteFromObject(_ selector:Selector, _ key: String, _ observer: Any, _ object: Any) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(key), object: nil)
}

func RegisterForNote(_ selector:Selector, _ key: String, _ observer: Any) {
    RegisterForNoteFromObject(selector,key, observer, NSNull())
}


func UnregisterFromNotes(_ observer: Any) {
    NotificationCenter.default.removeObserver(observer)
}

func UnregisterFromNotesFromObject(_ observer: Any, _ object: Any) {
    NotificationCenter.default.removeObserver(observer, name: nil, object: object)
}

func UnregisterFromNotesFromObjectWithName(_ observer: Any, _ object: Any,_ name: String) {
    NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.init(rawValue: name), object: object)
}




//MARK:- Extensions -
extension Array where Element == UInt8 {
    var data : Data{
        return Data(self)
    }
}


extension Data {
    var hexString: String {
        var hexString = ""
        for byte in self {
            hexString += String(format: "%02X", byte)
        }
        return hexString
    }
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}

extension NSData {
    public var hexadecimalString: NSString {
        var bytes = [UInt8](repeating: 0, count: length)
        getBytes(&bytes, length: length)
        
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }
        return NSString(string: hexString)
    }
}

extension Data {
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        for i in 0 ..< length {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }

}


extension Data {
    mutating func write<T>(withPointerTo object: Data,
                           block: @escaping (UnsafeMutablePointer<UInt8>, UnsafePointer<UInt8>) throws -> T) rethrows -> T {
        
        return try self.withUnsafeMutableBytes { (mutablePtr: UnsafeMutablePointer<UInt8>) in
            
            try object.withUnsafeBytes { (objectPtr: UnsafePointer<UInt8>) in
                try block(mutablePtr, objectPtr)
            }
            
        }
        
    }
    
    mutating func write<T>(withPointerTo object1: Data,
                           _ object2: Data,
                           block: @escaping (UnsafeMutablePointer<UInt8>, UnsafePointer<UInt8>, UnsafePointer<UInt8>) throws -> T) rethrows -> T {
        
        return try self.withUnsafeMutableBytes { (mutablePtr: UnsafeMutablePointer<UInt8>) in
            
            try object1.withUnsafeBytes { (object1Ptr: UnsafePointer<UInt8>) in
                try object2.withUnsafeBytes { (object2Ptr: UnsafePointer<UInt8>) in
                    try block(mutablePtr, object1Ptr, object2Ptr)
                }
            }
            
        }
        
    }
    
    mutating func write<T>(withPointerTo object1: Data,
                           _ object2: Data,
                           _ object3: Data,
                           block: @escaping (UnsafeMutablePointer<UInt8>, UnsafePointer<UInt8>, UnsafePointer<UInt8>, UnsafePointer<UInt8>) throws -> T) rethrows -> T {
        
        return try self.withUnsafeMutableBytes { (mutablePtr: UnsafeMutablePointer<UInt8>) in
            
            try object1.withUnsafeBytes { (object1Ptr: UnsafePointer<UInt8>) in
                try object2.withUnsafeBytes { (object2Ptr: UnsafePointer<UInt8>) in
                    try object3.withUnsafeBytes { (object3Ptr: UnsafePointer<UInt8>) in
                        try block(mutablePtr, object1Ptr, object2Ptr, object3Ptr)
                    }
                }
            }
            
        }
        
    }
}

extension NSArray {
    func arraybyRemovingObject(object: Any?) -> NSArray? {
        let copy = NSMutableArray.init(array: self)
        copy.remove(object as Any)
        return copy
    }
    
    func arrayByRemovingObjectAtIndex(index: Int) -> NSArray? {
        let copy = NSMutableArray.init(array: self)
        copy.removeObject(at: index)
        return copy
    }
    
    func arrayByRemovingLastObject() -> NSArray? {
        if count != 0 {
            let copy = NSMutableArray.init(array: self)
            copy.removeLastObject()
            return copy
        }
        return self
    }
    
    func arrayByRemovingFirstObject() -> NSArray? {
        if count != 0 {
            let copy = NSMutableArray.init(array: self)
            copy.removeObject(at: 0)
            return copy
        }
        return self
    }
    
    func arraybyInsertingObject(object: Any?, at index: Int) -> NSArray? {
        let copy = NSMutableArray.init(array: self)
        if let object = object as? AnyHashable {
            copy.insert(object, at: index)
        }
        return copy
    }
    
    func arrayByReplacingObjectAtIndex(index: Int, withObject object: Any?) -> NSArray? {
        let copy = NSMutableArray.init(array: self)
        if let object = object {
            copy[index] = object
        }
        return copy
    }
    
//    func shuffled() -> NSArray? {
//        let copy = NSMutableArray.init(array: self)
//        copy.shuffle()
//        return copy
//    }
    
    func mappedArrayUsingBlock(block: @escaping (_ object: Any?) -> Any?) -> NSArray? {
        if block != nil {
            let array = NSMutableArray.init(capacity: self.count)
            for object in self {
                let replacement = block((object as Any?))
                if let replacement = replacement {
                    if let replacement = replacement as? AnyHashable {
                        array.add(replacement)
                    }
                }
            }
            return array
        }
        return self
    }
    
    func reversedArray() -> NSArray? {
        return reverseObjectEnumerator().allObjects as NSArray
    }
    
//    func arrayByMergingObjectsFromArray(array: NSArray?) -> NSArray? {
//        let copy = NSMutableArray.init(array: self)
//        copy.mergeObjectsFromArray(array: array) //mergeObjects(fromArray: array)
//        return copy
//    }
    
//    func objectsInCommonWithArray( array: NSArray?) -> NSArray? {
//        var set = NSMutableOrderedSet.init(array: self as! [Any])//NSMutableOrderedSet(array: self)
//        set.intersects(Set<Any>(arrayLiteral: array))//intersect(Set<AnyHashable>(array))
//        return set.array
//    }

    
    func uniqueObjects() -> NSArray? {
        return NSOrderedSet(array: self as! [Any]).array as NSArray
    }
    
    func forEachObjectPerformBlock(_ block: @escaping (_ obj: Any?) -> Void) {
        enumerateObjects({ obj, i, stop in
            block(obj)
        })
    }
    
    func arrayByMappingObjectsUsingFullBlock(block: @escaping (_ obj: Any?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Any?) -> NSArray? {
        var arr: NSArray = []
        enumerateObjects({ obj, idx, stop in
            if let stop1 = block(obj, idx, stop) as? AnyHashable {
                arr.adding(stop1)//append(stop1)
            }
        })
        return arr
    }
    
    func arrayByMappingObjectsUsingBlock(block: @escaping (_ obj: Any?) -> Any?) -> NSArray? {
        return arrayByMappingObjectsUsingFullBlock { (obj, idx, stop) -> Any? in
            return block((obj))
        }
    }
    
    func arrayByFilteringObjectsUsingFullBlock( block: @escaping (_ obj: Any?, _ idx: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Bool) -> NSArray? {
        var arr: NSArray = []
        enumerateObjects({ obj, idx, stop in
            if block(obj, idx, stop) {
                if let obj = obj as? AnyHashable {
                    arr.adding(obj)//append(obj)
                }
            }
        })
        return arr
    }
    
    func arrayByFilteringObjectsUsingBlock( block: @escaping (_ obj: Any?) -> Bool) -> NSArray? {
        return arrayByFilteringObjectsUsingFullBlock { (obj, i, stop) -> Bool in
            return block(obj)
        }
    }
    
    func objectPassingTest(block: @escaping (_ obj: Any?) -> Bool) -> Any? {
        return objectPassingTestFull { (obj, i, stop) -> Bool in
            return block(obj)
        }
    }
    
    func objectPassingTestFull(block: @escaping (_ obj: Any?, _ i: Int, _ stop: UnsafeMutablePointer<ObjCBool>?) -> Bool) -> Any? {
        let i = indexOfObject(passingTest: block)
        if NSNotFound == i {
            return nil
        }
        return self[i]
    }
    
    func each(_ block: @escaping (_ obj: Any?) -> Void) {
        return enumerateObjects({ obj, i, stop in
            block(obj)
        })
    }
    
    func map(_ block: @escaping (_ obj: Any?) -> Any?) -> NSArray? {
        return arrayByMappingObjectsUsingBlock(block: block)
    }
    
    func grep(_ block: @escaping (_ obj: Any?) -> Bool) -> NSArray? {
        return arrayByFilteringObjectsUsingBlock(block: block)
    }
    
    func find(_ block: @escaping (_ obj: Any?) -> Bool) -> Any? {
        return objectPassingTest(block: block)
    }
}

extension NSMutableArray {
    func removeFirstObject() {
        if count != 0 {
            removeObject(at: 0)
        }
    }

//
    
    func shift() -> Any? {
        if count > 0 {
            let obj = self[0]
            removeObject(at: 0)
            return obj
        }
        return nil
    }

//
    func push(_ obj: Any?) {
        if let obj = obj {
            add(obj)
        }
    }
}
