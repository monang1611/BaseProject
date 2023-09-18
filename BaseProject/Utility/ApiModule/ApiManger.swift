//
//  ApiManager.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.

import Foundation
import Alamofire
import MBProgressHUD

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

enum DataType : String {
    case url
    case data
    case string
    case array
    case image
}

extension UIApplication {
    var keyWindow: UIWindow? {
        return self.windows.filter{ $0.isKeyWindow }.first
    }
}

extension AppDelegate {
    class var sharedInstance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class var keyWindow: UIWindow? {
        return UIApplication.shared.windows.filter{ $0.isKeyWindow }.first
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    class func setLoginAsRootViewController() {
//        let rootController = UIStoryboard.main.instantiateInitialViewController()
//        
//        if #available(iOS 13.0, *){
//            if let scene = UIApplication.shared.connectedScenes.first {
//                guard let windowScene = (scene as? UIWindowScene) else { return }
//                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
//                window.windowScene = windowScene //Make sure to do this
//                window.rootViewController = rootController
//                window.makeKeyAndVisible()
//                AppDelegate.sharedInstance.window = window
//            }
//        } else {
//            AppDelegate.sharedInstance.window?.rootViewController = rootController
//            AppDelegate.sharedInstance.window?.makeKeyAndVisible()
//        }
    }
    
    /*
     class func setSideMenuAndRootViewController() {
     let customSideMenuController = CustomSideMenuController.loadController()
     
     if #available(iOS 13.0, *){
     if let scene = UIApplication.shared.connectedScenes.first {
     guard let windowScene = (scene as? UIWindowScene) else { return }
     let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
     window.windowScene = windowScene //Make sure to do this
     window.rootViewController = customSideMenuController
     window.makeKeyAndVisible()
     AppDelegate.sharedInstance.window = window
     }
     } else {
     AppDelegate.sharedInstance.window?.rootViewController = customSideMenuController
     AppDelegate.sharedInstance.window?.makeKeyAndVisible()
     }
     }
     */
}


struct UserDefault {
    struct key {
        static let email         = "email"
        static let langauge      = "langauge"
        static let username      = "username"
        static let customerId    = "customerId"
        static let walletAddress = "walletAddress"
        static let walletNumber  = "walletNumber"
        static let userLoggedIn  = "userLoggedIn"
        static let authToken     = "authToken"
        static let isInstalled   = "isInstalled"
        static let firstName     = "firstName"
        static let lastName      = "lastName"
        static let imgUrl        = "imgUrl"
        static let FingerPrint   = "FingerPrint"
    }
}

class Global: NSObject {
    class var shared: Global {
        struct Singloten {
            static let shared: Global = Global()
        }
        return Singloten.shared
    }
    
    var appName: String = "My Health Style"
    
    var authToken: String {
        return UserDefaults.standard.string(forKey: UserDefault.key.authToken) ?? "eyJhbGciOiJIUzI1NiJ9.eyJjbGllbnRfaWQiOiI5ZGI5ODMwOC1kYzkwLTQ0MWItYTZjZC1kMDFhZWViNjY4YmQiLCJleHAiOjE2NjE4MzQwMDN9.JAl9qAvm66OyZclRl0efo1XIO7PuvPDWPY_9ALyF0Xc"
    }
}

struct ErrorMsg{
    static let APINotRespond = "Oh No ! Something went wrong.."
    static let APIInvalidToken = "Invalid Token"
}

struct DataProvider {
    var value : Any
    var fileName : String = ""
    var type : DataType
    
    init(value: Any, fileName: String = "", type: DataType) {
        self.value = value
        self.fileName = fileName
        self.type = type
    }
}

class APIManager {
    enum ApiServer: String {
        case Production
        
        var url: String {
            switch self {
            case .Production: return "http://54.79.79.135/myhealthstyle/api/auth/" //"http://3.26.43.162/myhealthstyle/api/auth/"
            }
        }
    }
    
    static var hud = MBProgressHUD()
    static var currentApiServer: ApiServer = .Production
    
    class var baseUrl: String {
        return "http://54.79.79.135/myhealthstyle/"
    }
    
    enum basePath: String {
        case oauthToken = "api/auth/"
        case customers = "api/user/"
        case device = "api/device/"
        case health = "api/health/"
        case friend = "api/friend/"
        case friendRequest = "api/friend/requests/"
        
    }
    
    enum Api: String {
        case authToken = "NewToken"
        case login = "login"
        case register = "register"
        case forgotPassword = "forgot_password"
        case forgotPasswordVerifyOtp = "forgot_password_verify_otp"
        case resetPassword = "reset_password"
        
        case getProfile = "get_profile"
        case updateprofile = "update_profile"
        case deleteAccount = "delete_account"
        case clearData = "clear_data"
        case changePassword = "change_password"
        case logout = "logout"
        
        case getdevice =  "list"
        case getdevicedetail = "get/"
        
        case adddevice = "add"
        case updatehealthdetails = "update/"
        
        case history = "history"
        case friend = "list?search=" //"list?search=new1@user.com"
        case friendHealthHistory = "health/history"
        case deletehealthHistory = "delete/"
        case gethistorydetail = "detail/"
        
        case getUsersToSendReq = "get_users"
        case getSentReq = "sent"
        case getRecievedReq = "received"
        case sendFriendRequest = "send_friend_request"
        case respondFriendRequest = "responde_request"
        case removeRequest = "remove_request"
        case getFollowers = "get_followers"
        case removeFollower = "remove_follower"
        case getFollowingList = "get_followings"
        case followUser = "follow"
        case unfollowUser = "unfollow"
        case getUsersToFollow = "get_users_to_follow"
        case addWarranty = "add_warranty"
        case email_verification_verify_otp = "email_verification_verify_otp"
        case resend_otp = "resend_register_otp"
        
        var requestUrl: String {
            if self == .authToken {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }else if self == .login {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .updateprofile {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }else if self == .register {
                return APIManager.baseUrl + APIManager.basePath.customers.rawValue + self.rawValue
            } else if self == .resend_otp {
                return APIManager.baseUrl + APIManager.basePath.customers.rawValue + self.rawValue
            } else if self == .deleteAccount {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .clearData {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .email_verification_verify_otp {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .changePassword {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .logout {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }else if self == .forgotPassword {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }else if self == .forgotPasswordVerifyOtp {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }else if self == .resetPassword {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            } else if self == .getdevice {
                return APIManager.baseUrl + APIManager.basePath.device.rawValue + self.rawValue
            } else if self == .adddevice {
                return APIManager.baseUrl + APIManager.basePath.health.rawValue + self.rawValue
            } else if self == .history {
                return APIManager.baseUrl + APIManager.basePath.health.rawValue + self.rawValue
            } else if self == .friend {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .friendHealthHistory {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .getdevicedetail {
                return APIManager.baseUrl + APIManager.basePath.device.rawValue + self.rawValue
            } else if self == .updatehealthdetails {
                return APIManager.baseUrl + APIManager.basePath.health.rawValue + self.rawValue
            } else if self == .deletehealthHistory {
                return APIManager.baseUrl + APIManager.basePath.health.rawValue + self.rawValue
            } else if self == .gethistorydetail {
                return APIManager.baseUrl + APIManager.basePath.health.rawValue + self.rawValue
            } else if self == .getUsersToSendReq {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .getSentReq {
                return APIManager.baseUrl + APIManager.basePath.friendRequest.rawValue + self.rawValue
            } else if self == .getRecievedReq {
                return APIManager.baseUrl + APIManager.basePath.friendRequest.rawValue + self.rawValue
            } else if self == .sendFriendRequest {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .respondFriendRequest {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .removeRequest {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .getFollowers {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .removeFollower {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .getFollowingList {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .followUser {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .unfollowUser {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .getUsersToFollow {
                return APIManager.baseUrl + APIManager.basePath.friend.rawValue + self.rawValue
            } else if self == .addWarranty {
                return APIManager.baseUrl + APIManager.basePath.device.rawValue + self.rawValue
            } else {
                return APIManager.baseUrl + APIManager.basePath.oauthToken.rawValue + self.rawValue
            }
        }
    }
    
    class func ShowLoader(loadingView: UIView) {
        hud = MBProgressHUD.showAdded(to: loadingView, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading..."
        hud.show(animated: true)
        //        appDelegate_.showLoader(.PleaseWait)
    }
    
    class func HideLoader(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            hud.hide(animated: true)
        }
        //        appDelegate_.hideLoader()
    }
    
    class func showApiAlert() {
        let alert = UIAlertController(title: AlertTitle.kError, message: ValidationMsgs.kAlertMsgFor_Please_check_your_internet_connection, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertButton.kOk, style: .default, handler: nil))
        AppDelegate.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
//MARK:- API method Define here
extension APIManager{
    //MARK: - Login API -
//    class func callLoginApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: LoginDModel.self) { response in
//                    guard let loginDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(loginDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Guest Uset Login API -
//    class func callGuestUserLoginApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now() ) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: LoginDModel.self) { response in
//                    guard let loginDeatils = response.value else {
//                        print("Guest User Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(loginDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Register API -
////    class func callRegisterApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//
//    class func callRegisterApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ForgotPasswordModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: ForgotPasswordModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Register error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Forgot Password API -
//    class func callForgotPasswordApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ForgotPasswordModel>) -> ())?) {
//
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: ForgotPasswordModel.self) { response in
//                    guard let forgotPswdDeatils = response.value else {
//                        print("forgotPswdDeatils error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(forgotPswdDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Email Verify Otp HANDLER -
//    class func callEmailVerifyOtpApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: LoginDModel.self) { response in
//                    guard let verifyOtpDeatils = response.value else {
//                        print("Verify Otp error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(verifyOtpDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Forgot Password Verify Otp HANDLER -
//    class func callForgotPasswordVerifyOtpApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<VerifyOtpModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: VerifyOtpModel.self) { response in
//                    guard let verifyOtpDeatils = response.value else {
//                        print("Verify Otp error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(verifyOtpDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Resend Otp HANDLER -
//    class func callResendOtpApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ForgotPasswordModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//
//                AF.request(request).responseDecodable(of: ForgotPasswordModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Resend Otp error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - RESET PASSSWORD HANDLER -
//    class func callResetPasswordApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ResetPasswordModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: ResetPasswordModel.self) { response in
//                    guard let resetPasswordDeatils = response.value else {
//                        print("Reset Password error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(resetPasswordDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - CALL CHANGE PASSWORD API -
//    class func callChangePasswordApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ChangePasswordModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: ChangePasswordModel.self) { response in
//                    guard let resetPasswordDeatils = response.value else {
//                        print("Change Password error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(resetPasswordDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - GET PROFILE API -
//    class func callProfileApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: LoginDModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Get User error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - UPDATE USER PROFILE API -
//    class func callUserUpdateProfile(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<LoginDModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: LoginDModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Update User error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - DELETE AC API -
//    class func callDeleteAccountApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ClearOrDeleteModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: ClearOrDeleteModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Delete User Account error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - CLEAR AC API -
//    class func callClearDataApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ClearOrDeleteModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: ClearOrDeleteModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Clear User Account error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - LOGOUT API -
//    class func callLogoutApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<ClearOrDeleteModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: ClearOrDeleteModel.self) { response in
//                    guard let registerDeatils = response.value else {
//                        print("Clear User Account error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(registerDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET DEVICE LIST API -
//    class func callGetDeviceApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetDeviceModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                //  request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: GetDeviceModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET DEVICE DETAILS API -
//    class func callGetDeviceDetailApi(apiUrl: String, id:String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetDeviceDetailsModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: "\(apiUrl)\(id)")!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                //  request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: GetDeviceDetailsModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Add Health Device Api -
//    class func callAddHealthDeviceApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<AddHealthToDeviceModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: AddHealthToDeviceModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - UPDATE HEALTH DETAILS API -
//    class func callUpadateHealthDetailsApi(apiUrl: String, id:String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<AddHealthToDeviceModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: "\(apiUrl)\(id)")!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: AddHealthToDeviceModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET HEALTH DETAILS API -
//    class func callGetHealthDetailApi(apiUrl: String, id:String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetHealthDetailModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: "\(apiUrl)\(id)")!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                //  request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: GetHealthDetailModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//           showApiAlert()
//        }
//    }
//
//
//    //MARK: - Get Health History Api -
//    class func callGetHistoryApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetHistoryModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                //                    request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: GetHistoryModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - Get Health History Api -
//    class func callGetHistoryByDateApi(apiUrl: String,dateFilter : String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetHistoryModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
////                var request = URLRequest(url: URL.init(string: apiUrl)!)
//                var request = URLRequest(url: URL.init(string: "\(apiUrl)?\(dateFilter)")!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: GetHistoryModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - DELETE HEALTH HISTORY API -
//    class func callDeleteHealthHistoryApi(apiUrl: String, id:String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<DeleteHealthHistoryModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: "\(apiUrl)\(id)")!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                // request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: DeleteHealthHistoryModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Login error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET FRIENDS / SEARCH FRIENDS LIST API -
//    class func callGetFriendsListApi(apiUrl: String, searchFrndName : String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFriendsListModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request : URLRequest?
//                if searchFrndName == "" {
//                    //its a all frnds list api
//                    let apiURL = apiUrl.replacingOccurrences(of: "?search=", with: "")
//                    request = URLRequest(url: URL.init(string: apiURL)!)
//                } else {
//                    //its a search frnds list
//                    request = URLRequest(url: URL.init(string: "\(apiUrl)\(searchFrndName)")!)
//                }
//
//                request?.httpMethod = method.rawValue
//                request?.headers = headers!
//
//                AF.request(request!).responseDecodable(of: GetFriendsListModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("FRIENDS / SEARCH FRIENDS error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET FRIENDS HEALTH HISTORY API -
//    class func callGetFriendHealthHistoryApi(apiUrl: String, friendsId : String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFriendHealthHistoryModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request : URLRequest?
//                if friendsId == "" {
//                    //its a all frnds history api
//                    request = URLRequest(url: URL.init(string: apiUrl)!)
//                } else {
//                    //its a only individual frnds history
//                    request = URLRequest(url: URL.init(string: "\(apiUrl)/\(friendsId)")!)
//                }
//                request?.httpMethod = method.rawValue
//                request?.headers = headers!
//
//                AF.request(request!).responseDecodable(of: GetFriendHealthHistoryModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Frnds History error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - Get Users To Send Friend Api -
//    class func callGetUsersToSendFriendApi(apiUrl: String, searchfriendsText : String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetUsersToSendFriendRequestModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
////                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request : URLRequest?
//                if searchfriendsText == "" {
//                    //its a all frnds list api
//                    request = URLRequest(url: URL.init(string: apiUrl)!)
//                } else {
//                    //its a search frnds list
//                    request = URLRequest(url: URL.init(string: "\(apiUrl)?search=\(searchfriendsText)")!)
//                }
//                request?.httpMethod = method.rawValue
//                request?.headers = headers!
//
//                AF.request(request!).responseDecodable(of: GetUsersToSendFriendRequestModel.self) { response in
//                    guard let getFriendsDeatils = response.value else {
//                        print("Get Users To Send Friend error")
////                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getFriendsDeatils.msg)
////                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - Get Received Friend Requests Api -
//    class func callGetReceivedFriendRequestsApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFriendsListModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var  request = URLRequest(url: URL.init(string: apiUrl)!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: GetFriendsListModel.self) { response in
//                    guard let getFriendsDeatils = response.value else {
//                        print("Get Users To Send Friend error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getFriendsDeatils.msg)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET RECIEVED FRIENDS REQUESTS API -
//    class func callGetReceivedFriendsRequestsApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFriendsListModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: GetFriendsListModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("RECIEVED FRIENDS REQUESTS error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET SENT FRIENDS REQUESTS API -
//    class func callGetSentFriendsRequestsApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFriendsListModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: GetFriendsListModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Sent FRIENDS REQUESTS error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - SEND FRIEND REQUEST API -
//    class func callSendFriendRequestApi(apiUrl: String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<FriendRequestModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: FriendRequestModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("SEND FRIEND REQUEST error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - RESPOND FRIEND REQUEST API -
//    class func callRespondFriendRequestApi(apiUrl: String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<FriendRequestModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now( )) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: FriendRequestModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Respond FRIEND REQUEST error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - GET FOLLOWERS LIST / Followings List  API -
//    class func callGetFollowersListApi(apiUrl: String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetFollowersListModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.headers = headers!
//
//                AF.request(request).responseDecodable(of: GetFollowersListModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("Get FOLLOWERS List error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//    //MARK: - GET USERS TO FOLLOW / USERS TO FOLLOW (SEARCH) API -
//    class func callGetUsersToFollowApi(apiUrl: String , isApi : isApiForGetUsersToFollow , searchText : String, method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<GetUsersToFollowModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now()  ) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//
//                var request : URLRequest?
//                if isApi == .isForGetUsersToFollow {
//                    request = URLRequest(url: URL.init(string: apiUrl)!)
//                } else {
//                    //its a search
//                    request = URLRequest(url: URL.init(string: "\(apiUrl)?search=\(searchText)")!)
//                }
//                request?.httpMethod = method.rawValue
//                request?.headers = headers!
//
//                AF.request(request!).responseDecodable(of: GetUsersToFollowModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("USERS TO FOLLOW / USERS TO FOLLOW (SEARCH) error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.status)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
//
//
//    //MARK: - ADD DEVICE WARRENTY API -
//    class func callAddDeviceWarrentyApi(apiUrl: String,  method: HTTPMethod, parameters: [String: Any], encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders?, loadingView: UIView, showLoader: Bool = true, progressHandler: ((Double) -> Void)? = nil, wsresponse:((_ response: AFDataResponse<AddDeviceWarrentyModel>) -> ())?) {
//        if Connectivity.isConnectedToInternet {
//            if showLoader {
//                DispatchQueue.main.asyncAfter(deadline: .now() ) {
//                    self.ShowLoader(loadingView: loadingView)
//                }
//            }
//
//            DispatchQueue.main.async {
//                AF.session.configuration.timeoutIntervalForRequest = 2100
//                var request = URLRequest(url: URL.init(string: (apiUrl))!)
//                request.httpMethod = method.rawValue
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.headers = headers!
////                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
//                if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) {
//                     request.httpBody = data
//                }
//                //                    print("Params ---> \(parameters)")
//
//                AF.request(request).responseDecodable(of: AddDeviceWarrentyModel.self) { response in
//                    guard let getDeviceDeatils = response.value else {
//                        print("ADD DEVICE WARRENTY error")
//                        HideLoader()
//                        wsresponse?(response)
//                        return
//                    }
//                    print(getDeviceDeatils.data)
//                    HideLoader()
//                    wsresponse?(response)
//                }
//            }
//        } else {
//            showApiAlert()
//        }
//    }
    
}

