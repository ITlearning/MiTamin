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
    private let reset = "/auth/reset/code"
    private let codeURL = "/auth/code"
    private let signupEmailCheck = "/auth/signup/code"
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
    
    // MARK: MyPage
    private let profile = "/user/profile"
    private let wishList = "/wish/list"
    private let addWishList = "/wish/new"
    private let editWishList = "/wish/"
    private let myDayInfo = "/myday/info"
    /// 데이노트 작성 가능 여부
    private let checkDayNoteMonth = "/daynote/check/"
    private let writeDayNote = "/daynote/new"
    private let editDayNote = "/daynote/"
    private let dayNoteList = "/daynote/list"
    
    // MARK: User
    /// 가입날짜 조회
    private let createdAt = "/user/created-at"
    
    //MARK: History
    private let feelingRank = "/report/feeling/rank"
    private let careRandom = "/care/random"
    private let categoryCareList = "/care/list"
    private let weeklyMental = "/report/weekly/mental"
    private let calendarMonthly = "/mytamin/monthly/"
    private let calendarWeekly = "/mytamin/weekly/"
    private let myTamin = "/mytamin/"
    
    func checkEmailSignUp(email: String) -> AnyPublisher<EmptyData, APIError> {
        let request = postRequest(URL(string: baseURL + signupEmailCheck), useType: .notUseToken, parameters: [
            "email" : email
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func checkSuccessCode(model: EmailModel) -> AnyPublisher<APIData<Bool>, APIError> {
        
        let request = getRequest(URL(string: baseURL + codeURL), useType: .notUseToken, parameters: [
            "email": "\(model.email)",
            "authCode": "\(model.authCode)"
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getEmailReset(email: String) -> AnyPublisher<EmptyData, APIError> {
        let request = postRequest(URL(string: baseURL + reset), useType: .notUseToken, parameters: [
            "email": email
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func deleteMyTamin(id: Int) -> AnyPublisher<EmptyData, APIError> {
        let request = deleteRequest(URL(string: baseURL + myTamin + "\(id)"))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getCalendarWeekly(date: String) -> AnyPublisher<APIData<[String: CalendarWeeklyServerModel?]>, APIError> {
        let request = getRequest(URL(string: baseURL + calendarWeekly + date))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getCalendarMonthly(day: String) -> AnyPublisher<APIData<[CalendarModel]>, APIError> {
        let request = getRequest(URL(string: baseURL + calendarMonthly + day))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getWeekMental() -> AnyPublisher<APIData<[WeeklyMentalModel]>, APIError> {
        let request = getRequest(URL(string: baseURL + weeklyMental))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getCategoryCareList(filter: [Int] = []) -> AnyPublisher<APIData<[String: [CareFilterModel]]>, APIError> {
        let request = postRequest(URL(string: baseURL + categoryCareList), parameters: [
            "careCategoryCodeList": filter
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getCareRandom() -> AnyPublisher<APIData<RandomCareModel?>, APIError> {
        let request = getRequest(URL(string: baseURL + careRandom))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getFeelingRank() -> AnyPublisher<APIData<[FeelingRankModel]>, APIError> {
        let request = getRequest(URL(string: baseURL + feelingRank))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getDayNoteList() -> AnyPublisher<APIData<[String:[DayNoteModel]]>, APIError> {
        let request = getRequest(URL(string: baseURL + dayNoteList))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func checkDayNote(day: String) -> AnyPublisher<APIData<Bool>, APIError> {
        let request = getRequest(URL(string: baseURL + checkDayNoteMonth + day))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getCreateAt() -> AnyPublisher<APIData<CreatedAtModel>, APIError> {
        let reqeust = getRequest(URL(string: baseURL + createdAt))
        
        return run(reqeust)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getMyDayInformation() -> AnyPublisher<APIData<MyDayModel>, APIError> {
        let reqeust = getRequest(URL(string: baseURL + myDayInfo))
        
        return run(reqeust)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func deleteWishList(wishId: Int) -> AnyPublisher<EmptyData, APIError> {
        let request = deleteRequest(URL(string: baseURL + editWishList+"\(wishId)"))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func editWishList(wishId: Int, text: String) -> AnyPublisher<EmptyData, APIError> {
        let request = putRequest(URL(string: baseURL + editWishList+"\(wishId)"), parameters: [
            "wishText": text
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func addWishList(text: String) -> AnyPublisher<APIData<WishListModel>, APIError> {
        let request = postRequest(URL(string: baseURL + addWishList), parameters: [
            "wishText": text
        ])
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getWishList() -> AnyPublisher<APIData<[WishListModel]>, APIError> {
        let request = getRequest(URL(string: baseURL + wishList))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func deleteDayNote(dayNoteId: Int) -> AnyPublisher<EmptyData, APIError> {
        let request = deleteRequest(URL(string: baseURL + editDayNote + "\(dayNoteId)"))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func editDayNote(daynoteId: Int, wishIdx: Int, note: String, images: [UIImage]) -> AnyPublisher<EmptyData, APIError> {
        let request = putMultiPartRequest(URL(string: baseURL + editDayNote + "\(daynoteId)"), parameters: [
            "wishId": wishIdx,
            "note": note
        ], imageData: images, type: "DayNote")
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func writeDayNote(wishIdx: Int, note: String, date: String, images: [UIImage]) -> AnyPublisher<APIData<DayNoteModel>, APIError> {
        let request = postMultiPartRequest(URL(string: baseURL + writeDayNote), parameters: [
            "wishId": wishIdx,
            "note": note,
            "date": date
        ], imageData: images)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func editProfile(imageEdit: String, nickName: String, sub: String, image: UIImage? = UIImage()) -> AnyPublisher<APIData<EditModel>, APIError> {
        let request = putMultiPartRequest(URL(string: baseURL + profile), parameters: [
            "isImgEdited": imageEdit,
            "nickname" : nickName,
            "beMyMessage" : sub
        ], imageData: [image ?? UIImage()], type: "Profile")
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func getProfile() -> AnyPublisher<APIData<ProfileModel>, APIError> {
        let request = getRequest(URL(string: baseURL + profile), useType: .useToken)
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func editDailyReport(condition: Int = 0, tags:[String] = [], todayReport: String = "") -> AnyPublisher<EmptyData, APIError> {
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
    
    func editCareReport(category: Int, careMsg1: String, careMsg2: String) -> AnyPublisher<EmptyData ,APIError> {
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
    
    func breathCheckToServer() -> AnyPublisher<EmptyData, APIError> {
        let request = patchRequest(URL(string: baseURL + breathSuccess))
        
        return run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func senseCheckToServer() -> AnyPublisher<EmptyData,APIError> {
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
    
    private func postMultiPartRequest(_ url: URL?, parameters: [String: Any] = [:], imageData: [UIImage]) -> DataRequest {
        let headers: HTTPHeaders = ["Content-Type" : "multipart/form-data;charset=UTF-8; boundary=6o2knFse3p53ty9dmcQvWAIx1zInP11uCfbm",
                                    "X-AUTH-TOKEN" : KeychainWrapper.standard.string(forKey: "accessToken") ?? "" ]
        
        return AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            for image in imageData {
                if let image = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(image, withName: "fileList", fileName: "\(image).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url!, usingThreshold: UInt64.init(), method: .post, headers: headers)
    }
    
    private func putMultiPartRequest(_ url: URL?, parameters: [String: Any] = [:], imageData: [UIImage], type: String) -> DataRequest {
        let headers: HTTPHeaders = ["Content-Type" : "multipart/form-data;charset=UTF-8; boundary=6o2knFse3p53ty9dmcQvWAIx1zInP11uCfbm",
                                    "X-AUTH-TOKEN" : KeychainWrapper.standard.string(forKey: "accessToken") ?? "" ]
        
        return AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            
            for image in imageData {
                if let image = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(image, withName: type == "DayNote" ? "fileList" : "file", fileName: "\(image).jpg", mimeType: "image/jpg")
                }
            }
        }, to: url!, usingThreshold: UInt64.init(), method: .put, headers: headers)
    }
    
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
    
    private func postRequest(_ url:URL?, useType: ServerType = .useToken,parameters: [String: Any] = [:]) -> DataRequest {
        
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
    
    private func deleteRequest(_ url:URL?, useType: ServerType = .useToken ,parameters: [String: Any] = [:]) -> DataRequest {
        
        let headers: HTTPHeaders
        if useType == .useToken {
            headers = ["Content-Type" : "application/json;charset=UTF-8",
                       "X-AUTH-TOKEN": KeychainWrapper.standard.string(forKey: "accessToken") ?? ""]
            
        } else {
            headers = ["Content-Type" : "application/json;charset=UTF-8"]
        }
        return AF.request(url!, method: .delete, parameters: parameters, encoding: JSONEncoding.default , headers: headers)
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
