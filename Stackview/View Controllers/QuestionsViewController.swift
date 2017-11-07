//
//  QuestionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

fileprivate enum Endpoint: String {
    case questions
    case featured = "questions/featured"
    case unanswered = "questions/unanswered"
}

fileprivate struct Tagging: ParametersConvertible {
    let tags: String
    
    var parameters: [String : Any] {
        return ["tagged": tags]
    }
}

class QuestionsViewController: DataPresenterViewController<Question, QuestionTableViewCell> {
    fileprivate var sortingOption: QuestionsAdvancedSortOption = .creation
    fileprivate var endpointValue = Endpoint.questions
    fileprivate var tagPickerController = TagPickerController()
    
    init(for tag: Tag? = nil) {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        
        if let tagName = tag?.name {
            tagPickerController.setChosenTags([tagName])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Questions"
        self.dropDownItems = ["Newest", "Recently active", "Most voted", "Featured", "Unanswered", "Hot today", "Hot this week", "Hot this month"]
        
        super.viewDidLoad()
        
        self.setupTagPicker()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showSearch))
    }

    private func setupTagPicker() {
        addChildViewController(tagPickerController)
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        header.addSubview(tagPickerController.view)
        tagPickerController.view.topAnchor.constraint(equalTo: header.topAnchor, constant: 10.0).isActive = true
        tagPickerController.view.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16.0).isActive = true
        tagPickerController.view.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16.0).isActive = true
        tagPickerController.view.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        
        tagPickerController.didMove(toParentViewController: self)
        tagPickerController.delegate = self
        tableView.tableHeaderView = header
    }

    override func handleDropDownSelection(for index: Int) {
        endpointValue = .questions
        
        switch index {
        case 0:
            sortingOption = .creation
        case 1:
            sortingOption = .activity(min: nil, max: nil)
        case 2:
            sortingOption = .votes(min: nil, max: nil)
        case 3:
            endpointValue = .featured
        case 4:
            endpointValue = .unanswered
        case 5:
            sortingOption = .hot
        case 6:
            sortingOption = .week
        case 7:
            sortingOption = .month
        default:
            fatalError()
        }
    }
    
    @objc func showSearch() {
        navigationController?.show(QuestionsSearchViewController(), sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuestionDetailViewController(for: String(data[indexPath.row].id!))
        navigationController?.show(vc, sender: nil)
    }
}

extension QuestionsViewController: TagPickerControllerDelegate {
    func tagPickerBeginAddingTags(_ tagPicker: TagPickerController) {
        tableView.isScrollEnabled = false
    }
    
    func tagPickerDoneAddingTags(_ tagPicker: TagPickerController, changesCommited: Bool) {
        tableView.isScrollEnabled = true
        
        if changesCommited {
            data.removeAll()
            loadData()
        }
    }
}

extension QuestionsViewController: RemoteDataSource {
    var endpoint: String {
        return endpointValue.rawValue
    }
    
    var parameters: [ParametersConvertible] {
        return [endpointValue == .questions ? SortingParameters(option: self.sortingOption, order: .descending)
                                            : SortingParameters(option: QuestionsAdvancedSortOption.creation, order: .descending),
                Tagging(tags: api.vectorize(parameters: tagPickerController.chosenTags))]
    }
}
