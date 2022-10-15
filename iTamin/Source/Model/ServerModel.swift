//
//  ServerModel.swift
//  iTamin
//
//  Created by Tabber on 2022/09/24.
//

import Foundation

enum APIError: Error {
    case http(ErrorData)
    case unknown
}

struct ErrorData: Codable {
    var statusCode: Int
    var errorName: String
    var message: String?
}


struct Response<T> {
    let value: T
    let response: URLResponse
}

struct APIData<T: Decodable>: Decodable {
    var statusCode: Int
    var message: String
    var data: T
}

struct SignUpModel: Codable {
    let email: String
    let password: String
    let nickname: String
    let mytaminHour: String?
    let mytaminMin: String?
}

struct SignUpReciveModel: Codable {
    let email: String
    let profileImgUrl: String
    let beMyMessage: String
    let nickname: String
    let mytaminHour: String?
    let mytaminMin: String?
}

struct EmailCheckModel: Codable {
    let data: Bool
}


struct LoginModel: Codable {
    let accessToken: String
    let refreshToken: String
}

struct WelComeModel: Codable {
    let nickname: String
    let comment: String
}

struct MyTaminSuccessModel: Codable {
    let updatedTime: String
}

struct MyTaminProgressModel: Codable {
    var breathIsDone: Bool
    var senseIsDone: Bool
    var reportIsDone: Bool
    var careIsDone: Bool
}

struct DailyNewModel: Codable {
    var reportId: Int
    var canEdit: Bool
    var mentalConditionCode: Int
    var mentalCondition: String
    var feelingTag: String
    var todayReport: String
}

struct CareDailyModel: Codable {
    var careId: Int
    var canEdit: Bool
    var careCategory: String
    var careMsg1: String
    var careMsg2: String
}

struct LatestMyTaminModel: Codable {
    var takeAt: String
    var report: ReportModel
    var care: CareModel
}

struct CareModel: Codable {
    var careId: Int
    var canEdit: Bool
    var careCategory: String
    var careMsg1: String
    var careMsg2: String
}

struct ReportModel: Codable {
    var reportId: Int
    var canEdit: Bool
    var mentalConditionCode: Int
    var mentalCondition: String
    var feelingTag: String
    var todayReport: String
}
