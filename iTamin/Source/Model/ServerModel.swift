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
    let password: String
    let profileImgUrl: String
    let beMyMessage: String
    let nickname: String
    let mytaminHour: String?
    let mytaminMin: String?
}

struct EmailCheckModel: Codable {
    let data: Bool
}
