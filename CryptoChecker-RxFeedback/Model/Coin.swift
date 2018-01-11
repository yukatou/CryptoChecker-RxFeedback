//
//  Ticker.swift
//  CryptoChecker
//
//  Created by yukatou on 2018/01/07.
//  Copyright © 2018年 yukatou. All rights reserved.
//

import Foundation

struct Coin: Codable {
    let id: String
    let name: String
    let symbol: String
    let rank: Int
    let priceUSD: Double

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUSD = "price_usd"
    }

    init(from decoder: Decoder) {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        id = try! container.decode(String.self, forKey: .id)
        name = try! container.decode(String.self, forKey: .name)
        symbol = try! container.decode(String.self, forKey: .symbol)
        rank = Int(try! container.decode(String.self, forKey: .rank)) ?? 0
        priceUSD = Double(try! container.decode(String.self, forKey: .priceUSD)) ?? 0.0
    }

}

extension Coin {
    var imageURL: URL? {
        return URL(string: "https://files.coinmarketcap.com/static/img/coins/32x32/\(self.id).png")
    }
}
