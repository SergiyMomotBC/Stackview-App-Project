//
//  BrowsingHistoryViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import CFAlertViewController
import DZNEmptyDataSet

class BrowsingHistoryViewController: UIViewController {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var searchbar = SearchbarTextfield(placeholder: "Search history...")
    let tableView = DataTableView()
    var datedRecords: [(date: Date, records: [BrowsingRecord])] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainAppColor
        title = "Browsing history"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "delete_all_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(deleteAll))
        
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.delegate = self
        searchbar.inputAccessoryView = InputAccessoryButton(title: "Done", action: { [weak self] in
            self?.datedRecords = CoreDataManager.shared.getBrowsingRecords()
            self?.tableView.reloadData()
            self?.searchbar.text = ""
            self?.searchbar.endEditing(true)
            self?.isSearching = false
        })
        
        view.addSubview(searchbar)
        if #available(iOS 11.0, *) {
            searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4.0).isActive = true
            searchbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0).isActive = true
            searchbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0).isActive = true
        } else {
            searchbar.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.0).isActive = true
            searchbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
            searchbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        }
        
        searchbar.heightAnchor.constraint(equalToConstant: SearchbarTextfield.preferredHeight).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchbar.bottomAnchor, constant: 4.0).isActive = true
        
        if #available(iOS 11.0, *) {
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        tableView.register(BrowsingRecordSectionHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: String(describing: BrowsingRecordSectionHeaderView.self))
        tableView.register(UINib(nibName: String(describing: BrowsingRecordTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: BrowsingRecordTableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.estimatedRowHeight = 100.0
        tableView.sectionHeaderHeight = 40.0
        tableView.backgroundView = UIView()
        
        datedRecords = CoreDataManager.shared.getBrowsingRecords()
        tableView.reloadData()
    }
    
    func deleteSection(_ section: Int) {
        tableView.beginUpdates()
        
        for record in datedRecords[section].records {
            CoreDataManager.shared.deleteBrowsingRecord(record)
        }
        
        datedRecords.remove(at: section)
        tableView.deleteSections(IndexSet(integer: section), with: .automatic)
        
        tableView.endUpdates()
    }
    
    @objc private func deleteAll() {
        guard !datedRecords.isEmpty else { return }
        
        let alert = CFAlertViewController(title: "Delete all history", titleColor: .mainAppColor,
                                          message: "Are you sure you want to delete all history records? This action cannot be reverted.",
                                          messageColor: .black, textAlignment: .natural, preferredStyle: .alert,
                                          headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        
        let cancelButton = CFAlertAction(title: "Cancel", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil)
        let confirmButton = CFAlertAction(title: "Confirm", style: .Default, alignment: .justified, backgroundColor: .flatPurple, textColor: .white) { [weak self] _ in
            for datedRecord in self?.datedRecords ?? [] {
                for record in datedRecord.records {
                    CoreDataManager.shared.deleteBrowsingRecord(record)
                }
            }
            
            self?.datedRecords.removeAll()
            self?.tableView.reloadData()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(confirmButton)
        
        present(alert, animated: true, completion: nil)
    }
}

extension BrowsingHistoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        datedRecords = CoreDataManager.shared.getBrowsingRecords(forSearchQuery: searchbar.text ?? "")
        tableView.reloadData()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
    }
}

extension BrowsingHistoryViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if !isSearching {
            return UIImage(named: "no_content_empty_state")!
        } else {
            return UIImage(named: "search_empty_state")!
        }
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        return NSAttributedString(string: !isSearching ? "There are no browsing records so far." : "No search results.", attributes: attributes)
    }
}

extension BrowsingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchbar.isEditing {
            searchbar.endEditing(true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datedRecords.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datedRecords[section].records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BrowsingRecordTableViewCell.self), for: indexPath) as! BrowsingRecordTableViewCell
        cell.setup(for: datedRecords[indexPath.section].records[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: BrowsingRecordSectionHeaderView.self)) as? BrowsingRecordSectionHeaderView
        header?.deleteButton.tag = section
        header?.deleteButton.addTarget(self, action: #selector(sectionDeleteButtonTapped(_:)), for: .touchUpInside)
        
        let viewedDate = datedRecords[section].date
        let days = Calendar.current.dateComponents([.day], from: viewedDate, to: Date()).day!
        
        if days == 0 {
            header?.textLabel?.text = "Today"
        } else if days == 1 {
            header?.textLabel?.text = "Yesterday"
        } else {
            header?.textLabel?.text = BrowsingHistoryViewController.dateFormatter.string(from: viewedDate)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let record = datedRecords[indexPath.section].records.remove(at: indexPath.row)
            CoreDataManager.shared.deleteBrowsingRecord(record)
            
            if datedRecords[indexPath.section].records.isEmpty {
                datedRecords.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuestionDetailViewController(for: String(datedRecords[indexPath.section].records[indexPath.row].questionID), saveVisit: false)
        navigationController?.show(vc, sender: nil)
    }
    
    @objc private func sectionDeleteButtonTapped(_ button: UIButton) {
        deleteSection(button.tag)
    }
}
