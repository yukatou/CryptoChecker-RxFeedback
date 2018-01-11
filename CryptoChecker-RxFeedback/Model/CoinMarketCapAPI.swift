//
//  CoinMarketCapAPI.swift
//  CryptoChecker
//
//  Created by yukatou on 2018/01/07.
//  Copyright © 2018年 yukatou. All rights reserved.
//

import Foundation
import Moya

enum CoinMarketCapAPI {
    case tickers(start: Int, limit: Int)
    case ticker(id: String)
}

enum Currency: String {
    case JPY
    case USD
}

extension CoinMarketCapAPI: TargetType {

    var baseURL: URL {
        return URL(string: "https://api.coinmarketcap.com/v1")!
    }

    var path: String {
        switch self {
        case .tickers: return "/ticker"
        case .ticker(let id): return "/ticker/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .tickers(let start, let limit):
            let parameters: [String: Any] = [
                "start": start,
                "limit": limit,
                "convert": Currency.JPY.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .ticker(_):
            return .requestPlain
        }
    }

    var sampleData: Data {
        return "success".data(using: .utf8)!
    }

    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
}
