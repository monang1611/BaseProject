//
//  ApiService.swift
//  Copyright © 2023 Meet,Monang,Nilomi . All rights reserved.

import Foundation
import Alamofire

import UIKit

class ApiService {
    static let shared: ApiService = ApiService()
    
    var retryData:Int = 3
    var callApiCount:Int = 0
    
    func GetAllRequestsPending(completion: ((Int) -> Void)?){
        var requestCount = 0
        AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { _ in requestCount = requestCount + 1 }
            uploadData.forEach { _ in requestCount = requestCount + 1 }
            downloadData.forEach { _ in requestCount = requestCount + 1 }
            completion?(requestCount)
        }
    }
    
    func cancelAllRequests(completion: (() -> Void)?) {
        AF.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            completion?()
        }
    }
    
   
}
