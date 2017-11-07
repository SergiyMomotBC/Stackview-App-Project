//
//  RecentSearchesTableView.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class RecentSearchesTableView: UITableView {
    private let headerHeight: CGFloat = 60.0
    private let maxRecords = 7
    
    private var records: [SearchRecord] = []
    private let recordsType: SearchRecordType
    
    var recordSelectedHandler: ((String) -> Void)?
    
    init(for type: SearchRecordType) {
        self.recordsType = type
        super.init(frame: .zero, style: .plain)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadData() {
        records = CoreDataManager.shared.getRecords(of: recordsType)
        super.reloadData()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .mainAppColor
        rowHeight = 44.0
        estimatedRowHeight = 0.0
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        delegate = self
        dataSource = self
        emptyDataSetSource = self
        alwaysBounceVertical = false
        tableFooterView = UIView()
        separatorColor = .lightGray
        scrollIndicatorInsets = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        superview?.endEditing(true)
    }
    
    private func createHeaderView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.mainAppColor
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        headerLabel.textColor = .white
        headerLabel.text = "Recent searches"
        
        view.addSubview(headerLabel)
        headerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.0).isActive = true
        
        let clearButton = UIButton()
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitleColor(.flatRed, for: .normal)
        clearButton.setTitleColor(.lightGray, for: .highlighted)
        clearButton.setTitle("Clear all", for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        clearButton.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        
        view.addSubview(clearButton)
        clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12.0).isActive = true
        clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .lightGray
        view.addSubview(line)
        line.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        return view
    }
    
    @objc private func clearAll() {
        for record in records {
            CoreDataManager.shared.deleteRecord(record)
        }
        
        reloadData()
    }
}

extension RecentSearchesTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(maxRecords, records.count)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return records.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.textLabel?.text = records[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let record = records.remove(at: indexPath.row)
            CoreDataManager.shared.deleteRecord(record)
            
            if records.isEmpty {
                tableView.deleteSections(IndexSet(integer: 0), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        recordSelectedHandler?(records[indexPath.row].title)
    }
}

extension RecentSearchesTableView: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24.0), NSAttributedStringKey.foregroundColor: UIColor.white]
        return NSAttributedString(string: "There are no recent searches at the moment.", attributes: attributes)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -100.0
    }
}
