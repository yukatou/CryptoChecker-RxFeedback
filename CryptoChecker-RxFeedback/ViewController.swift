//
//  ViewController.swift
//  CryptoChecker-RxFeedback
//
//  Created by yukatou on 2018/01/10.
//  Copyright © 2018年 yahoojapan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import Kingfisher

struct State {
    var loadPage: Int? = 1
    var loading: Bool = false
    var items: [Coin] = []
}

enum Event {
    case refresh
    case loadNextPage
    case response([Coin])
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let api = CoinMarketCapAPIClient()
        let fetchCount = 30
        tableView.refreshControl = refreshControl

        Driver.system(
            initialState: State(),
            reduce: { (state: State, event: Event) -> State in
                switch event {
                case .refresh:
                    var results = state
                    results.loadPage = 1
                    results.loading = true
                    results.items = []
                    return results

                case .loadNextPage:
                    var results = state
                    results.loadPage = (results.items.count / fetchCount) + 1
                    results.loading = true
                    return results

                case .response(let items):
                    var results = state
                    results.loadPage = nil
                    results.loading = false
                    results.items += items
                    return results
                }
            },
            feedback:
                bind(self) { me, state in
                    let subscriptions = [
                        state.map { $0.items }
                            .drive(me.tableView.rx.items(cellIdentifier: "Cell"))(me.configureCell),
                        state.map { $0.loading }.filter { !$0 }
                            .drive(onNext: { _ in me.refreshControl.endRefreshing() })
                    ]

                    let events: [Signal<Event>] = [
                        me.refreshControl.rx.controlEvent(.valueChanged).asSignal().map { _ in Event.refresh },
                        state.flatMapLatest { state in
                            if state.loading {
                                return Signal.empty()
                            }
                            return me.tableView.rx.reachedBottom.map { _ in Event.loadNextPage }
                        }
                    ]

                    return Bindings(subscriptions: subscriptions, events: events)
                },
                react(query: { $0.loadPage }, effects: { page in
                    return api.fetch(page: page, limit: fetchCount)
                        .asSignal(onErrorJustReturn: [])
                        .map(Event.response)
                })
        )
        .drive()
        .disposed(by: disposeBag)
    }

    private func configureCell(row: Int, item: Coin, cell: UITableViewCell) {
        let coinImageView = cell.viewWithTag(1) as! UIImageView
        let coinNameLabel = cell.viewWithTag(2) as! UILabel
        let coinPriceLabel = cell.viewWithTag(3) as! UILabel

        coinImageView.kf.setImage(with: item.imageURL)
        coinNameLabel.text = item.name
        coinPriceLabel.text = "$\(item.priceUSD.decimalString)"
    }
}
