//
//  TagPickerController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/4/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagPickerController: UIViewController {
    fileprivate static let collectionViewHeight: CGFloat = 40.0
    fileprivate static let cellHeight: CGFloat = 24.0
    fileprivate static let textFieldMaxWidth: CGFloat = 150.0
    
    var availableTags: [String] = []
    var textField: UITextField?
    var allowsNewTags = false
    var chosenTags: [String] = []
    var accessoryView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let loadingView = BottomLoadingView()
    var requestTask: DispatchWorkItem?
    let api = StackExchangeRequest()
    weak var delegate: TagPickerControllerDelegate?
    var lastChosenTags: [String] = []
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    lazy var chosenTagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 0
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagCollectionViewCell.self))
        view.register(TagInputCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagInputCollectionViewCell.self))
        view.delegate = self
        view.dataSource = self
        view.addGestureRecognizer(tapRecognizer)
        return view
    }()
    
    lazy var availableTagsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: 3000, height: 30.0), collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagCollectionViewCell.self))
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(obtainFocus))
        tapRecognizer.numberOfTapsRequired = 1
        return tapRecognizer
    }()
    
    var isInteractive = true {
        didSet {
            chosenTagsCollectionView.isUserInteractionEnabled = isInteractive
        }
    }
    
    var allTags: [String] = [] {
        didSet {
            filterAvailableTags()
        }
    }

    override func loadView() {
        view = chosenTagsCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accessoryView.frame = CGRect(x: 0, y: 0, width: 0, height: TagPickerController.collectionViewHeight)
        accessoryView.contentView.addSubview(availableTagsCollectionView)
        availableTagsCollectionView.topAnchor.constraint(equalTo: accessoryView.contentView.topAnchor).isActive = true
        availableTagsCollectionView.leadingAnchor.constraint(equalTo: accessoryView.contentView.leadingAnchor, constant: 16.0).isActive = true
        availableTagsCollectionView.trailingAnchor.constraint(equalTo: accessoryView.contentView.trailingAnchor, constant: -16.0).isActive = true
        availableTagsCollectionView.bottomAnchor.constraint(equalTo: accessoryView.contentView.bottomAnchor).isActive = true
        
        accessoryView.contentView.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: accessoryView.contentView.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: accessoryView.contentView.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: accessoryView.contentView.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: accessoryView.contentView.bottomAnchor).isActive = true
    }
    
    func setChosenTags(_ tags: [String]) {
        chosenTags = tags
        lastChosenTags = tags
    }
    
    @objc private func obtainFocus() {
        if isInteractive && textField != nil && !textField!.isEditing {
            textField?.becomeFirstResponder()
        }
    }

    func filterAvailableTags() {
        availableTags = allTags.filter { !self.chosenTags.contains($0) && $0.contains(textField?.text ?? "") }
        availableTagsCollectionView.reloadData()
    }

    func scrollChosenTagsToEnd() {
        chosenTagsCollectionView.scrollToItem(at: IndexPath(row: chosenTags.count, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func setPlaceholderText(_ text: String) {
        let textColor = UIColor(white: 0.85, alpha: 1.0)
        let textFont = UIFont.boldSystemFont(ofSize: 16.0)
        textField?.attributedPlaceholder = NSAttributedString(string: "  " + text, attributes: [.foregroundColor: textColor, .font: textFont])
    }
    
    func removeChosenTag(at indexPath: IndexPath) {
        guard chosenTags.count > indexPath.row else { return }
        
        let selectedTag = chosenTags[indexPath.row]
        
        if allTags.contains(selectedTag) {
            availableTags.append(selectedTag)
            availableTagsCollectionView.reloadData()
        }
        
        chosenTags.remove(at: indexPath.row)
        chosenTagsCollectionView.deleteItems(at: [indexPath])
    }
    
    func addChosenTag(from indexPath: IndexPath) {
        availableTagsCollectionView.isUserInteractionEnabled = false
        
        let selectedTag = availableTags[indexPath.row]
        let addedPath = IndexPath(row: chosenTags.count, section: 0)
        
        chosenTags.append(selectedTag)
        availableTags.remove(at: indexPath.row)
        chosenTagsCollectionView.insertItems(at: [addedPath])
        chosenTagsCollectionView.scrollToItem(at: addedPath, at: .centeredHorizontally, animated: true)
        
        if let cell = availableTagsCollectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: -TagPickerController.collectionViewHeight)
                cell.alpha = 0.0
            }, completion: { success in
                cell.transform = .identity
                cell.alpha = 1.0
                self.availableTagsCollectionView.deleteItems(at: [indexPath])
                self.availableTagsCollectionView.isUserInteractionEnabled = true
            })
        }
    }
    
    @objc func tagSearchTextChanged() {
        if let task = self.requestTask {
            task.cancel()
            requestTask = nil
        }
        
        requestTask = DispatchWorkItem {
            self.availableTagsCollectionView.isHidden = true
            self.loadingView.enable()
            
            self.api.makeRequest(to: "tags", with: [TagSearchParameters(query: self.textField?.text ?? ""), PagingParameters(pageSize: 10)], completion: { (result: [Tag]?, error: RequestError?, _) in
                self.allTags = result?.map { $0.name! } ?? []
                self.requestTask = nil
                self.loadingView.disable()
                self.availableTagsCollectionView.isHidden = false
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: requestTask!)
    }
}

extension TagPickerController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 || !availableTags.isEmpty {
            collectionView.backgroundView = nil
            return 1
        } else {
            messageLabel.text = textField?.text?.isEmpty ?? true ? "Start entering tag name..." : "No tags found..."
            collectionView.backgroundView = messageLabel
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? chosenTags.count + 1 : availableTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 && indexPath.row == chosenTags.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagInputCollectionViewCell.self), for: indexPath) as! TagInputCollectionViewCell
            textField = cell.textField
            textField?.addTarget(self, action: #selector(tagSearchTextChanged), for: .editingChanged)
            textField?.inputAccessoryView = accessoryView
            textField?.delegate = self
            textField?.text = ""
            setPlaceholderText("Tap to add tags...")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCell.self), for: indexPath) as! TagCollectionViewCell
            cell.tagNameLabel.text = collectionView.tag == 0 ? chosenTags[indexPath.row] : availableTags[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 && indexPath.row == chosenTags.count {
            return CGSize(width: TagPickerController.textFieldMaxWidth, height: TagPickerController.cellHeight)
        } else {
            var width: CGFloat
            if collectionView.tag == 0 {
                width = (chosenTags[indexPath.row] as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14.0)]).width + 17.0
            } else {
                width = (availableTags[indexPath.row] as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14.0)]).width + 17.0
            }
            
            return CGSize(width: width, height: TagPickerController.cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            if textField!.isEditing && indexPath.row < chosenTags.count {
                removeChosenTag(at: indexPath)
            } else if !textField!.isEditing && indexPath.row == chosenTags.count {
                textField?.becomeFirstResponder()
            }
        } else if chosenTags.count < 5 {
            textField?.text = ""
            addChosenTag(from: indexPath)
        }
    }
}

extension TagPickerController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setPlaceholderText("Add a tag...")
        tapRecognizer.isEnabled = false
        scrollChosenTagsToEnd()
        delegate?.tagPickerBeginAddingTags(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setPlaceholderText("Tap to add tags...")
        textField.text = ""
        allTags.removeAll()
        availableTagsCollectionView.reloadData()
        tapRecognizer.isEnabled = true
        delegate?.tagPickerDoneAddingTags(self, changesCommited: lastChosenTags != chosenTags)
        lastChosenTags = chosenTags
    }
}
