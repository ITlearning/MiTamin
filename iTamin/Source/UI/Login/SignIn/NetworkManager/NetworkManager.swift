//
//  NetworkManager.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import Alamofire
import Combine
import UIKit
import SwiftKeychainWrapper

extension NetworkManager {
    enum ServerType {
        case notUseToken
        case useToken
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private var baseURL = "https://my-tamin.herokuapp.com"
    
    // MARK: Login
    private let signUp = "/auth/signup"
    private let emailCheck = "/auth/check/email/"
    private let nickNameCheck = "/auth/check/nickname/"
    private let login = "/auth/default/login"
    
    // MARK: Home
    private let welcomeMessage = "/home/welcome"
    private let breathSuccess = "/home/breath"
    private let senseSuccess = "/home/sense"
    private let getProgress = "/home/progress/status"
    private let reportDaily = "/report/new"
    private let careDaily = "/care/new"
    private let latestMytamin = "/mytamin/latest"
    private let loadDailyReport = "/report/"
    private let loadCareReport = "/care/"
    
    func editDailyReport(condition: Int = 0, tags:[String] = [], todayReport: String = "") -> AnyPublisher<APIData<EditModel>, APIError> {
        var para: [String: Any] = [:]
        switch tags.count {
        case 1:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "todayReport": todayReport
            ]
        case 2:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "tag2": tags[1],
                "todayReport": todayReport
            ]
        case 3:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "tag2": tags[1],
                "tag3": tags[2],
                "todayReport": todayReport
            ]
        default:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "todayReport": todayReport
            ]
        }
        
        let request = putRequest(URL(string: baseURL + loadDailyReport + "\(UserDefaults.standard.string(forKey: .reportId) ?? "")"), useType: .useToken, parameters: para)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func editCareReport(category: Int, careMsg1: String, careMsg2: String) -> AnyPublisher<APIData<EditModel> ,APIError> {
        let request = putRequest(URL(string: baseURL + loadCareReport + "\(UserDefaults.standard.string(forKey: .careId) ?? "")"), useType: .useToken, parameters: [
            "careCategoryCode": category,
            "careMsg1": careMsg1,
            "careMsg2": careMsg2
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func loadCareReportData() -> AnyPublisher<APIData<CareModel>, APIError> {
        let request = getRequest(URL(string: baseURL + loadCareReport + "\(UserDefaults.standard.string(forKey: .careId) ?? "")"), useType: .useToken)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func loadDailyReportData() -> AnyPublisher<APIData<ReportModel>, APIError> {
        
        let request = getRequest(URL(string: baseURL + loadDailyReport + "\(UserDefaults.standard.string(forKey: .reportId) ?? "")"), useType: .useToken)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getLatestMyTaminData() -> AnyPublisher<APIData<LatestMyTaminModel>, APIError> {
        let request = getRequest(URL(string: baseURL + latestMytamin), useType: .useToken)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func careDaily(category: Int, careMsg1: String, careMsg2: String) -> AnyPublisher<APIData<CareDailyModel>, APIError> {
        let request = postRequest(URL(string: baseURL + careDaily), useType: .useToken, parameters: [
            "careCategoryCode": category,
            "careMsg1": careMsg1,
            "careMsg2": careMsg2
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func reportNewDaily(condition: Int, tags:[String], todayReport: String) -> AnyPublisher<APIData<DailyNewModel>, APIError> {
        
        var para : [String: Any] = [:]
        
        switch tags.count {
        case 1:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "todayReport": todayReport
            ]
        case 2:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "tag2": tags[1],
                "todayReport": todayReport
            ]
        case 3:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "tag2": tags[1],
                "tag3": tags[2],
                "todayReport": todayReport
            ]
        default:
            para = [
                "mentalConditionCode": condition,
                "tag1": tags[0],
                "todayReport": todayReport
            ]
        }
        
        let request = postRequest(URL(string: baseURL + reportDaily), useType: .useToken, parameters:para)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func welcomeToServer() -> AnyPublisher<APIData<WelComeModel>, APIError> {
        let request = getRequest(URL(string: baseURL + welcomeMessage))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func breathCheckToServer() -> AnyPublisher<APIData<MyTaminSuccessModel>, APIError> {
        let request = patchRequest(URL(string: baseURL + breathSuccess))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func senseCheckToServer() -> AnyPublisher<APIData<MyTaminSuccessModel>,APIError> {
        let request = patchRequest(URL(string: baseURL + senseSuccess))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func checkMyTaminStatus() -> AnyPublisher<APIData<MyTaminProgressModel>, APIError> {
        let request = getRequest(URL(string: baseURL + getProgress))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func emailCheckToServer(string: String) -> AnyPublisher<APIData<Bool>, APIError> {
        let request = getRequest(URL(string: baseURL + emailCheck + string), useType: .notUseToken)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func nickNameCheckToServer(string: String) -> AnyPublisher<APIData<Bool>, APIError> {
        
        let urlString = baseURL + nickNameCheck + string
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let reques = getRequest(URL(string: encodedString), useType: .notUseToken)
        
        return run(reques)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func signUpToServer(model: SignUpModel, skip: Bool = false) -> AnyPublisher<APIData<SignUpReciveModel>, APIError> {
        
        var parameters: Parameters = [:]
        
        // 스킵시 데이터 구성
        if skip {
            parameters = [
                "email": "\(model.email)",
                "password": "\(model.password)",
                "nickname": "\(model.nickname)"
            ]
        } else { // 모든 데이터 입력 시 데이터 구성
            parameters = [
                "email": model.email,
                "password": model.password,
                "nickname": model.nickname,
                "mytaminHour": model.mytaminHour ?? "",
                "mytaminMin": model.mytaminMin ?? ""
            ]
        }
        
        let request = postRequest(URL(string: baseURL + signUp), useType: .notUseToken, parameters: parameters)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func loginToServer(email: String, password: String) -> AnyPublisher<APIData<LoginModel>, APIError> {
        var parameters: Parameters = [:]
        
        parameters = [
            "email": email,
            "password": password
        ]
        
        let request = postRequest(URL(string: baseURL + login), useType: .notUseToken, parameters: parameters)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

extension NetworkManager {
    
    private func getRequest(_ url:URL?, useType: ServerType = .useToken ,parameters: [String: Any] = [:]) -> DataRequest {
        let headers: HTTPHeaders
        if useType == .useToken {
            headers = ["Content-Type" : "application/json;charset=UTF-8",
                       "X-AUTH-TOKEN": KeychainWrapper.standard.string(forKey: "accessToken") ?? ""]
            print(KeychainWrapper.standard.string(forKey: "accessToken") ?? "")
        } else {
            headers = ["Content-Type" : "application/json;charset=UTF-8"]
        }
        return AF.request(url!, method: .get, parameters: parameters, headers: headers)
    }
    
    private func postRequest(_ url:URL?, useType: ServerType = .useToken ,parameters: [String: Any] = [:]) -> DataRequest {
        
        let headers: HTTPHeaders
        if useType == .useToken {
            headers = ["Content-Type" : "application/json;charset=UTF-8",
                       "X-AUTH-TOKEN": KeychainWrapper.standard.string(forKey: "accessToken") ?? ""]
            
        } else {
            headers = ["Content-Type" : "application/json;charset=UTF-8"]
        }
        return AF.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers)
    }
    
    private func putRequest(_ url:URL?, useType: ServerType = .useToken ,parameters: [String: Any] = [:]) -> DataRequest {
        
        let headers: HTTPHeaders
        if useType == .useToken {
            headers = ["Content-Type" : "application/json;charset=UTF-8",
                       "X-AUTH-TOKEN": KeychainWrapper.standard.string(forKey: "accessToken") ?? ""]
            
        } else {
            headers = ["Content-Type" : "application/json;charset=UTF-8"]
        }
        return AF.request(url!, method: .put, parameters: parameters, encoding: JSONEncoding.default , headers: headers)
    }
    
    private func patchRequest(_ url:URL?, useType: ServerType = .useToken ,parameters: [String: Any] = [:]) -> DataRequest {
        
        let headers: HTTPHeaders
        if useType == .useToken {
            headers = ["Content-Type" : "application/json;charset=UTF-8",
                       "X-AUTH-TOKEN": KeychainWrapper.standard.string(forKey: "accessToken") ?? ""]
            
        } else {
            headers = ["Content-Type" : "application/json;charset=UTF-8"]
        }
        return AF.request(url!, method: .patch, parameters: parameters, encoding: JSONEncoding.default , headers: headers)
    }
    
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request.validate().publishData(emptyResponseCodes: [200, 204, 205]).tryMap { result -> Response<T> in
            if let error = result.error {
                if let errorData = result.data {
                    let value = try decoder.decode(ErrorData.self, from: errorData)
                    throw APIError.http(value)
                }
                else {
                    throw error
                }
            }
            if let data = result.data {
                #if DEBUG
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                #endif
                let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: result.response!)
            } else {
                return Response(value: Empty.emptyValue() as! T, response: result.response!)
            }
        }
        .mapError({ (error) -> APIError in
            print(error)
            if let apiError = error as? APIError {
                return apiError
            } else {
                return .unknown
            }
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
