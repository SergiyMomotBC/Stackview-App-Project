//
//  TagsCollectionView.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagsCollectionView: UICollectionView {
    var tagNames: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        register(TagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagCollectionViewCell.self))
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        allowsSelection = true
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
            layout.scrollDirection = .horizontal
        }
    }
}

extension TagsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCell.self), for: indexPath) as! TagCollectionViewCell
        cell.tagNameLabel.text = tagNames[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        TagQuickInfoPopupController.displayQuickInfo(about: tagNames[indexPath.row])
    }
}
