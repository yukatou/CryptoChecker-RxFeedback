//
//  Double+Decimal.swift
//  CryptoChecker-RxFeedback
//
//  Created by yukatou on 2018/01/11.
//  Copyright © 2018年 yahoojapan. All rights reserved.
//

import Foundation

extension Double {

    var decimalString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3

        return formatter.string(from: NSNumber(value: self))!
    }
}
