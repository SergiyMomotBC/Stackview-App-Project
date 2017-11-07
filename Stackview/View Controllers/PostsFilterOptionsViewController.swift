//
//  PostsFilterOptionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import TTSegmentedControl

class PostsFilterOptionsViewController: UIViewController {
    @IBOutlet weak var taggedContainerView: UIView!
    @IBOutlet weak var nottaggedContainerView: UIView!
    @IBOutlet weak var minimumAnswersTextField: UITextField!
    @IBOutlet weak var minimumViewsTextField: UITextField!
    @IBOutlet weak var acceptedSwitch: TTSegmentedControl!
    @IBOutlet weak var communityWikiSwitch: TTSegmentedControl!
    @IBOutlet weak var closedSwitch: TTSegmentedControl!
    @IBOutlet weak var fromDateField: UITextField!
    @IBOutlet weak var toDateField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    weak var delegate: PostsFilterOptionsDelegate?
    var searchOptions: SearchParameters?
    let taggedPicker = TagPickerController()
    let nottaggedPicker = TagPickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter options"
        
        setupTagPicker(taggedPicker, forContainer: taggedContainerView)
        setupTagPicker(nottaggedPicker, forContainer: nottaggedContainerView)
        setupSwitches([acceptedSwitch, communityWikiSwitch, closedSwitch])
        setupInputFields([minimumAnswersTextField, minimumViewsTextField, fromDateField, toDateField])
        
        fromDateField.inputView = createDatePicker(withTag: 0)
        toDateField.inputView = createDatePicker(withTag: 1)
        
        resetButton.setTitleColor(.flatRed, for: .normal)
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(apply))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        func updateSwitch(_ switchControl: TTSegmentedControl, value optionalValue: Bool?) {
            if let value = optionalValue {
                switchControl.selectItemAt(index: value ? 1 : 2)
            } else {
                switchControl.selectItemAt(index: 0)
            }
        }
        
        if let options = searchOptions {
            taggedPicker.chosenTags = options.taggedList ?? []
            taggedPicker.chosenTagsCollectionView.reloadData()
            nottaggedPicker.chosenTags = options.notTaggedList ?? []
            nottaggedPicker.chosenTagsCollectionView.reloadData()
            
            minimumAnswersTextField.text = String(options.minAnswers ?? 0)
            minimumViewsTextField.text = String(options.minViews ?? 0)
            
            fromDateField.text = dateFormatter.string(from: options.fromDate ?? Date(timeIntervalSince1970: 0))
            toDateField.text = dateFormatter.string(from: options.toDate ?? Date())
            
            updateSwitch(acceptedSwitch, value: options.isAccepted)
            updateSwitch(communityWikiSwitch, value: options.isWiki)
            updateSwitch(closedSwitch, value: options.isClosed)
        }
    }
    
    private func createDatePicker(withTag tag: Int) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.minimumDate = Date(timeIntervalSince1970: 0)
        picker.maximumDate = Date()
        picker.tag = tag
        picker.addTarget(self, action: #selector(handleDatePickerChange(_:)), for: .valueChanged)
        return picker
    }
    
    private func setupInputFields(_ fields: [UITextField]) {
        for field in fields {
            field.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            field.textColor = .white
            field.delegate = self
            field.inputAccessoryView = InputAccessoryButton(title: "Done", action: { [weak field] in
                field?.endEditing(true)
            })
        }
    }
    
    private func setupTagPicker(_ tagPicker: TagPickerController, forContainer containerView: UIView) {
        containerView.layer.cornerRadius = 6.0
        addChildViewController(tagPicker)
        containerView.addSubview(tagPicker.view)
        tagPicker.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        tagPicker.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 2.0).isActive = true
        tagPicker.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2.0).isActive = true
        tagPicker.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tagPicker.didMove(toParentViewController: self)
    }
    
    private func setupSwitches(_ switches: [TTSegmentedControl]) {
        for control in switches {
            control.itemTitles = ["Any", "Yes", "No"]
            control.containerBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
            control.cornerRadius = 6.0
            control.thumbColor = UIColor.flatRed
            control.defaultTextColor = .white
            control.defaultTextFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            control.selectedTextColor = .white
            control.selectedTextFont = UIFont.boldSystemFont(ofSize: 16.0)
            control.allowChangeThumbWidth = false
        }
    }
    
    @objc private func handleDatePickerChange(_ datePicker: UIDatePicker) {
        if datePicker.tag == 0 {
            fromDateField.text = dateFormatter.string(from: datePicker.date)
        } else {
            toDateField.text = dateFormatter.string(from: datePicker.date)
        }
    }
    
    @objc private func reset() {
        searchOptions = SearchParameters()
        updateUI()
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func apply() {
        searchOptions?.taggedList = !taggedPicker.chosenTags.isEmpty ? taggedPicker.chosenTags : nil
        searchOptions?.notTaggedList = !nottaggedPicker.chosenTags.isEmpty ? nottaggedPicker.chosenTags : nil
        searchOptions?.minAnswers = Int(minimumAnswersTextField.text ?? "0")
        searchOptions?.minViews = Int(minimumViewsTextField.text ?? "0")
        searchOptions?.fromDate = dateFormatter.date(from: fromDateField.text ?? "")
        searchOptions?.toDate = dateFormatter.date(from: toDateField.text ?? "")
        searchOptions?.isAccepted = acceptedSwitch.currentIndex > 0 ? acceptedSwitch.currentIndex == 1 : nil
        searchOptions?.isWiki = communityWikiSwitch.currentIndex > 0 ? communityWikiSwitch.currentIndex == 1 : nil
        searchOptions?.isClosed = closedSwitch.currentIndex > 0 ? closedSwitch.currentIndex == 1 : nil
        
        delegate?.shouldApplyOptions(searchOptions!)
        navigationController?.popViewController(animated: true)
    }
}

extension PostsFilterOptionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
