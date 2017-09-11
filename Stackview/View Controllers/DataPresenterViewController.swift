//
//  DataPresenterViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation
import StatefulViewController

class DataPresenterViewController<DataType, CellType: GenericCell<DataType>>: DataViewController, PullRefreshable, DropDownNavigatable, UITableViewDelegate, UITableViewDataSource {
    let tableView = DataTableView()
    var data: [DataType] = []
    let api = StackExchangeRequest()
    weak var dataSource: RemoteDataSource?
    let preloadTriggerIndex = 5
    var dropDownItems: [String]?
    let scrollToTopButton = FloatingButton(image: UIImage(named: "scroll_top")!.withRenderingMode(.alwaysTemplate))
    var hasMoreData = false
    var shouldLoadOnInit = true
    var shouldEnablePullToRefresh = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainAppColor
        
        tableView.register(UINib(nibName: String(describing: CellType.self), bundle: nil), forCellReuseIdentifier: String(describing: CellType.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = loadMoreView

        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(scrollToTopButton)
        scrollToTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        scrollToTopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
        scrollToTopButton.alpha = 0.0
        scrollToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        
        if shouldEnablePullToRefresh {
            enablePullToRefresh(for: tableView, backgroundColor: view.backgroundColor!) { [weak self] in
                self?.data.removeAll()
                self?.loadQuestions(showLoader: false)
            }
        }
        
        if let items = self.dropDownItems {
            enableDropDownMenu(with: items, title: title ?? "", initialItemIndex: 0) { [weak self] index in
                self?.paging.reset()
                self?.data.removeAll()
                self?.handleDropDownSelection(for: index)
                self?.loadQuestions()
            }
        }
        
        if shouldLoadOnInit {
            loadQuestions()
        }
        
        view.layoutIfNeeded()
    }
    
    func handleDropDownSelection(for index: Int) {}
    
    @objc func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    }
    
    func loadQuestions(showLoader: Bool = true) {
        loading = true
        
        if showLoader {
            startLoading()
        }
        
        api.makeRequest(to: dataSource!.endpoint, with: [paging] + dataSource!.parameters) { (results: [DataType]?, error: RequestError?, hasMore: Bool?) in
            self.data += results ?? []
            self.tableView.reloadData()
            
            if let requestError = error, self.data.isEmpty {
                self.hasMoreData = false
                
                switch requestError {
                case .noInternetConnection:
                    self.endLoading(animated: true, error: ErrorType.noConnection, completion: nil)
                default:
                    self.endLoading(animated: true, error: ErrorType.other, completion: nil)
                }
            } else {
                self.hasMoreData = hasMore ?? false
                self.endLoading(animated: true, error: nil, completion: nil)
            }
            
            if showLoader && !self.data.isEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)
            }
            
            self.tableView.dg_stopLoading()
            self.loading = false
            self.loadMoreView.disable()
            
            if showLoader {
                let heightDelta = self.tableView.frame.height
                for cell in self.tableView.visibleCells {
                    cell.center.y += heightDelta
                    cell.alpha = 0.0
                    
                    UIViewPropertyAnimator(duration: 1.0, controlPoint1: CGPoint(x: 0.075, y: 0.88), controlPoint2: CGPoint(x: 0.165, y: 1.0), animations: {
                        cell.center.y -= heightDelta
                    }).startAnimation(afterDelay: 0.1)
                    
                    UIViewPropertyAnimator(duration: 1.0, controlPoint1: CGPoint(x: 0.215, y: 0.61), controlPoint2: CGPoint(x: 0.355, y: 1.0), animations: {
                        cell.alpha = 1.0
                    }).startAnimation(afterDelay: 0.1)
                }
            }
        }
    }
    
    override func hasContent() -> Bool {
        return data.count > 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < scrollView.frame.height && scrollToTopButton.tag == 0 {
            scrollToTopButton.tag = 1
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.scrollToTopButton.alpha = 0.0
            }, completion: nil)
        } else if scrollView.contentOffset.y >= scrollView.frame.height && scrollToTopButton.tag == 1 {
            scrollToTopButton.tag = 0
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                self.scrollToTopButton.alpha = 0.9
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CellType.self), for: indexPath) as! CellType
        cell.setup(for: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - preloadTriggerIndex && !loading && hasMoreData {
            paging.nextPage()
            loadMoreView.enable()
            loadQuestions(showLoader: false)
        }
    }
}
