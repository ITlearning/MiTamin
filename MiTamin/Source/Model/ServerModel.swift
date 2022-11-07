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

struct EmptyData: Codable {
    var statusCode: Int
    var message: String
}

struct APIData<T: Decodable>: Decodable {
    var statusCode: Int
    var message: String
    var data: T
}

struct EditModel: Codable {
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
    let profileImgUrl: String?
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

struct MyTaminProgressModel: Codable, Equatable {
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

struct RandomCareModel: Codable {
    var careMsg1: String
    var careMsg2: String
    var takeAt: String
}

struct CategoryCareModel: Codable {
    var date: String
    var data: [CareFilterModel]
}

struct CareFilterModel: Codable {
    var careMsg1: String
    var careMsg2: String
    var careCategory: String
    var takeAt: String
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


struct ProfileModel: Codable {
    var nickname: String
    var profileImgUrl: String?
    var beMyMessage: String
    var provider: String
}

struct WishListModel: Codable {
    var wishId: Int
    var wishText: String
    var count: Int
}

struct MyDayModel: Codable {
    var myDayMMDD: String
    var dday: String
    var comment: String
}

struct CreatedAtModel: Codable {
    var year: Int
    var month: Int
}

struct DayNoteModel: Codable {
    var daynoteId: Int
    var imgList: [String]
    var year: Int
    var month: Int
    var wishId: Int
    var wishText: String
    var note: String
}

struct DayNoteListModel: Codable {
    var year: String
    var data: [DayNoteModel]
}

struct FeelingRankModel: Codable {
    var feeling: String
    var count: Int
}

struct WeeklyMentalModel: Codable {
    var dayOfWeek: String
    var mentalConditionCode: Int
}

struct CalendarModel: Hashable, Codable {
    var day: Int
    var mentalConditionCode: Int
}

struct WeeklyCalendarModel: Codable {
    var day: String
    var data: CalendarWeeklyServerModel?
}

struct CalendarWeeklyServerModel: Codable {
    var mytaminId: Int
    var takeAt: String
    var report: DailyNewModel?
    var care: CareDailyModel?
}


struct EmailModel {
    var email: String
    var authCode: String
}
