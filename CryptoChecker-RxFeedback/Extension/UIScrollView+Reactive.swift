//
//  UIScrollView+Reactive.swift
//  CryptoChecker
//
//  Created by yukatou on 2018/01/07.
//  Copyright © 2018年 yukatou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView  {

    var reachedBottom: Signal<()> {
        return contentOffset.asDriver()
            .flatMap { [weak base] contentOffset -> Signal<()> in
                guard let scrollView = base else {
                    return Signal.empty()
                }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Signal.just(()) : Signal.empty()
            }
    }
}
