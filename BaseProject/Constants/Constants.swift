//
//  Constants.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.

import Foundation


let kAppName:String = "BaseProject"


struct NotificationName {
    static let kSample = "sample"
}

struct APIMsg {
    static let kRegistrationSuccess = "Successfully created user"
    static let kRegistrationError = "Error while validating user"
    static let kForgotPasswordError = "Something went wrong."
}
struct AlertTitle {
    static let kError = "Error!!"
    static let kSuccess = "Success"
    static let kFaild = "Faild"
}
struct AlertButton {
    static let kOkay = "Okay"
    static let kOk = "Ok"
    static let kYes = "Yes"
    static let kNo = "No"
}
//MARK:- APP CONTSTANTS -
struct AlertIsFor {
    static let kRegisterProcessComplete = "Register Process Complete"
    static let kFactoryReset = "Factory Reset"
    static let kVehicleInfo = "Vehicle Info"
    static let kE_Calling = "E_Calling"
    static let kAddContact = "AddContact"
    static let kPassword_is_sent_by_email = "Password is sent by e-mail"
    static let kPassword_not_matched = "Password not matched"
    static let kAlert_ButtonOk = "OK"
    static let kAlert_ButtonBACK = "BACK"
    static let kAlert_Img_Cross = "error_grey"
    static let kAlert_BluetoothEnable = "Bluetooth Enable"
    static let kAlert_BluetoothDeny = "Bluetooth Deny"
    static let kAlert_Bluetooth_not_found = "Bluetooth not found.\nPlease try again."
    static let kAlert_ButtonGo_to_Settings = "Go to Settings"
    static let kAlert_Bluetooth_not_found_and_redirect = "Bluetooth not found.\nPlease try again"
    static let kAlert_ButtonGo_to_the_Settings_page = "Go to the Settings page"

}

struct showPopUpName {
   static let kPopUp_Custom = "PopUp Custom"
}

struct popUpIsFor {
    static let kPopUp_FirmwareUpdate = "FirmwareUpdate"
    static let kPopUp_PickerTrendData = "PickerTrendData"
    static let kPopUp_PickerDateRangeData = "PickerDateRangeData"
    static let kPopUp_PickerMetricsData = "PickerMetricsData"
}

//COLOR CODE HEX -
struct colorCodeHex {
    static let kTextFieldGrayColorCodeHex = "DBDBDB"
    static let kTextFieldBlueColorCodeHex = "71A4F9" //"003FAB"
    static let kDeselctedColorCodeHex = "707070"
    static let kSafeZoneMapSelectedColorCodeHex = "0066FF"
    static let kSafeZoneMapDeSelectedColorCodeHex = "00246B"
}

//MARK:- USERR DEFAULTS KEYS -
struct userDefaultsKeys {
    static let kIsLoggedIn = "IsLoggedIn"
    static let kUserDeatils = "UserDeatils"
    static let kRegisterVehicleDetails = "RegisterVehicleDetails"
    static let kRegister_ECallListDetails = "RegisterECallListDetails"
  
    static let kUserGroup_SavedUserGroupData = "SavedUserGroupData"
    static let kRegisterUser_Recieved_UserId = "RegisterUser_Recieved_UserId"
    static let kRegisterUser_Recieved_VehicleId = "RegisterUser_Recieved_VehicleId"
    
    static let kRecievedVincode = "Recieved_Vincode"
    static let kLastConnectedDeviceActor = "LastConnectedDeviceActor"
}


//MARK:- VIEW CONTROLLERS IDENTIFIERS -
struct ScreenNameIdentifiers {
    static let kRegistrationVC = "RegistrationVC"
    static let kHomeVC = "HomeVC"
    static let kLoginVC = "LoginVC"
    static let kCustomeAlertPopupViewVC = "CustomAlertPopUpViewVC"
    static let kBeaconDetailsVC = "BeaconDetailsVC"
}

struct WeddingDetails {
    static let kWeddingDetails_WeddingDate = "WeddingDate"
    static let kWeddingDetails_NoOfPeople = "NoOfPeople"
    static let kWeddingDetails_WeddingBudget = "WeddingBudget"
    static let kWeddingDetails_BrideName = "BrideName"
    static let kWeddingDetails_GroomName = "GroomName"
}


//MARK:- VALIDATIONS -
struct ValidationMsgs {
    static let kAlertMsgFor_Please_check_your_internet_connection = "Please check your internet connection"
    static let kAlertMsgFor_Unable_to_store_data_Please_try_again = "Unable to store data, Please try again"
   
    //FOR ADD MARRIAGE INFO ------
    static let kAlertMsgFor_Please_enter_wedding_date = "Please select a date"
    static let kAlertMsgFor_Please_enter_how_many_people_will_attend_wedding = "Enter number of people attending the wedding."
    static let kAlertMsgFor_Please_enter_valid__how_many_people_will_attend_wedding = "Enter valid number of people attending the wedding."

    static let kAlertMsgFor_Please_enter_budget = "Please enter your budget"
    static let kAlertMsgFor_Please_valid_budget = "Please enter valid budget"
    static let kAlertMsgFor_Please_enter_bride_name = "Please enter a name of bride"
    static let kAlertMsgFor_Please_enter_groom_name = "Please enter a name of groom"
    static let kAlertMsgFor_Please_select_groom = "Please select groom from options"
    static let kAlertMsgFor_Please_select_Bride = "Please select bride from options"

    //FOR ADD EVENTS ------
    static let kAlertMsgFor_Please_enter_event_name = "Please enter an event name"
    
    //FOR ADD GUESTS ------
    static let kAlertMsgFor_Please_enter_guest_name = "Please enter a guest name"
    static let kAlertMsgFor_Please_enter_guest_address = "Please enter a guest address"
    
    //FOR EVENTS - THINGS TO BUY ------
    static let kAlertMsgFor_Please_enter_Item_name = "Please enter an item name"
    static let kAlertMsgFor_Please_enter_store_Name = "Please enter a store name"
    static let kAlertMsgFor_Please_enter_store_address = "Please enter a store address"

    //ADD DETAILS ----
    static let kAlertMsgFor_Please_enter_location_name = "Please enter a location name"
    static let kAlertMsgFor_Please_enter_location_address = "Please enter location address"
    static let kAlertMsgFor_Please_enter_guests = "Please enter a number of guest"
    static let kAlertMsgFor_Please_enter_website = "Please enter a website"
    static let kAlertMsgFor_Please_enter_valid_website = "Please enter a valid website"

    //ADD PERSON -----
    static let kAlertMsgFor_Please_enter_person_name = "Please enter a person name"
    static let kAlertMsgFor_Please_enter_person_address = "Please enter a person address"

    //DRESS AND SUITE -----
    static let kAlertMsgFor_Please_enter_Dress_name = "Please enter a dress name"
    static let kAlertMsgFor_Please_enter_Dress_cost = "Please enter a dress cost"
    static let kAlertMsgFor_Please_enter_shoe_name = "Please enter a shoe name"
    static let kAlertMsgFor_Please_enter_shoe_cost = "Please enter a shoe cost"
    static let kAlertMsgFor_Please_enter_jewellery_name = "Please enter a jewellery name"
    static let kAlertMsgFor_Please_enter_jewellery_cost = "Please enter a jewellery cost"
    
    //COMMON ----
    static let kAlertMsgFor_Please_enter_name = "Please enter a name"
    static let kAlertMsgFor_Please_valid_name = "Please enter valid a name"
    static let kAlertMsgFor_Please_enter_cost = "Please enter a cost"
    static let kAlertMsgFor_Please_enter_phone_number = "Please enter a phone number"
    static let kAlertMsgFor_Please_enter_valid_phone_number = "Please enter a valid phone number"
    static let kAlertMsgFor_Please_enter_upload_an_image = "Please upload an image"
    static let kAlertMsgFor_Please_enter_event_date_time = "Please select date & time"
    static let kAlertMsgFor_Please_enter_venue_name = "Please enter a venue name"
    static let kAlertMsgFor_Please_enter_venue_address = "Please enter a venue address"
    static let kAlertMsgFor_Please_enter_valid_Website = "Please enter a valid website"

    static let kAlertMsgFor_Failed = "Something went wrong, please try again"

    static let kAlertMsgFor_Please_choose_different_name = "This name is already exists, please choose a different name"
    static let kAlertMsgFor_UpdateValueSuccess = "Update value successfully"
    static let kAlertMsgFor_Please_enter_email_address = "Please enter email address"
    static let kAlertMsgFor_Please_enter_Valid_email_address = "Please enter valid email address"
    
   

}


//MARK:- BLE CONTSTANTS -
let kPlease_enable_bluetooth = "Please enable bluetooth"
let kError = "Error"
let kConnected = "Connected"
let kDisconnected = "Disconnected"

struct constantBle {
    static let advertisementData = "advertisementData"
    static let kCBAdvDataManufacturerData = "kCBAdvDataManufacturerData"
}
//MARK:- NOTIFICATION CENTRE -
struct DataBaseTableName {
    static let kDeviceLogTable = "devicelog"
    static let kUserTable = "user"
}

//MARK:- NOTIFICATION CENTRE -
struct notificationCentreConstants {
    static let kNC_RecievedVincodeResponseFromDevice = "RecievedVincodeResponseFromDevice"
    static let kDeviceLogFatch = "deviceLogFatch"
}
//MARK:- NOTIFICATION CENTRE -
struct PlanURL {
    static let kBasic = "https://www.vertex-golf.com/packages"
    
}

//MARK:- IMAGE CONSTATNS -
struct ImageIconNames {
    static let kBackIcon = "iv_back"
    static let kMenuIcon = "Menu Icon"
}

let kProfileDefaultpic = "profile_default"
let kImgDeviceDisconnected = "disconnected"


let kUserDefaultEmail:String = "kEmail"
let kUserDefaultTokanID:String = "kAuthToken"
let kUserDefaultPassword:String = "kPassword"
let kUserDefaultLogin:String = "kisLogin"

struct ApiKeys {
    static let kSuccess = "Success"
    static let ksocialUid = "socialUid"
    static let ksocialProvider = "socialProvider"
    static let kFirstName = "firstName"
    static let kLastName = "lastName"
    static let kemail = "email"
    static let kNickname = "nickname"
    static let kpassword = "password"
    static let kMobileNumber = "mobileNumber"
    static let kDOB = "DOB"
    static let kAddress = "address"
    static let kGender = "gender"
    static let kWeighT = "weight"
    static let kHeight = "height"
    
    static let kisGuest = "isGuest"
    static let ktoken = "token"
    
    static let kOldPassword = "oldPassword"
    static let kNewPassword = "newPassword"

    static let kotp = "otp"
    static let kotpRef = "otpRef"
    

    static let kDeviceType = "deviceType"

    
    static let kFriend_id = "friend_id"
    static let kResponde = "responde"
    static let kType = "type"
    static let kAccept = "accept"
    static let kReject = "reject"
    static let kReceived = "received"
    static let kSent = "sent"
    
    static let kSerial_number = "serial_number"
    static let kActivation_code = "activation_code"
    
    static let kAuthtoken = "Authtoken"
    static let kContentType = "Content-Type"
    static let kContentType_Value = "application/x-www-form-urlencoded"
    static let kContentTypeAppJson_Value = "application/json"

}

//func ReadValue(_ storageKey: String) -> Any {
//    return UserDefaults.standard.value(forKey: storageKey) as Any
//}
func RemoveValue(_ storageKey: String){
    UserDefaults.standard.removeObject(forKey: storageKey)
    UserDefaults.standard.synchronize();
}

func StoreValue( storageKey:String, value : Any) {
    UserDefaults.standard.setValue(value, forKey: storageKey)
    UserDefaults.standard.synchronize();
}
