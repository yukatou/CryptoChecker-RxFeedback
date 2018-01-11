//
//  ControlEvent+Signal.swift
//  CryptoChecker-RxFeedback
//
//  Created by yukatou on 2018/01/12.
//  Copyright © 2018年 yahoojapan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ControlEvent {
    func asSignal() -> Signal<E> {
        return self.asObservable().asSignal(onErrorSignalWith: .empty())
    }
}
