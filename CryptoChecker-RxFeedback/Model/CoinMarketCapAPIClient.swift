//
//  CoinMarketCapAPIClient.swift
//  CryptoChecker
//
//  Created by yukatou on 2018/01/07.
//  Copyright © 2018年 yukatou. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class CoinMarketCapAPIClient {
    let provider = MoyaProvider<CoinMarketCapAPI>()

    func fetch(page: Int, limit: Int) -> Single<[Coin]> {

        let start = (page - 1) * limit

        return provider.rx.request(.tickers(start: start, limit: limit))
            .retry(3)
            .filterSuccessfulStatusAndRedirectCodes()
            .map([Coin].self)
            .observeOn(MainScheduler.instance)
    }
}
