//
//  AnimatedTabBar.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

fileprivate extension Array {
    subscript (safe index: Int) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct TabSwitcherMenuItem {
    let title: String
    let tintColor: UIColor
    let normalImage: UIImage
    let highlightedImage: UIImage
}

protocol ColorTabsDataSource: class {
    func numberOfItems(inTabSwitcher tabSwitcher: ColorTabs) -> Int
    func tabSwitcher(_ tabSwitcher: ColorTabs, titleAt index: Int) -> String
    func tabSwitcher(_ tabSwitcher: ColorTabs, iconAt index: Int) -> UIImage
    func tabSwitcher(_ tabSwitcher: ColorTabs, hightlightedIconAt index: Int) -> UIImage
    func tabSwitcher(_ tabSwitcher: ColorTabs, tintColorAt index: Int) -> UIColor
}

class ColorTabs: UIControl {
    private let highlighterViewOffScreenOffset: CGFloat = 44.0
    private let switchAnimationDuration: TimeInterval = 0.3
    private let highlighterAnimationDuration: TimeInterval = 0.15
    
    weak var dataSource: ColorTabsDataSource?
    var titleTextColor: UIColor = .white
    var titleFont: UIFont = .boldSystemFont(ofSize: 18)
    var normalIconColor = UIColor.secondaryAppColor
    var highlightedIconColor = UIColor.white
    
    fileprivate let stackView = UIStackView()
    fileprivate var buttons: [UIButton] = []
    fileprivate var labels: [UILabel] = []
    
    fileprivate(set) lazy var highlighterView: UIView = {
        let highlighterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0, height: self.bounds.height)))
        highlighterView.layer.cornerRadius = self.bounds.height / 2
        self.addSubview(highlighterView)
        self.sendSubview(toBack: highlighterView)
        return highlighterView
    }()
    
    override var frame: CGRect {
        didSet {
            stackView.frame = bounds
        }
    }
    
    override var bounds: CGRect {
        didSet {
            stackView.frame = bounds
        }
    }
    
    var selectedSegmentIndex: Int = 0 {
        didSet {
            if oldValue != selectedSegmentIndex {
                transition(from: oldValue, to: selectedSegmentIndex)
                sendActions(for: .valueChanged)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            layoutIfNeeded()
            let countItems = dataSource?.numberOfItems(inTabSwitcher: self) ?? 0
            if countItems > selectedSegmentIndex {
                transition(from: selectedSegmentIndex, to: selectedSegmentIndex)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        moveHighlighterView(toItemAt: selectedSegmentIndex)
    }
    
    func centerOfItem(atIndex index: Int) -> CGPoint {
        return buttons[index].center
    }
    
    func setIconsHidden(_ hidden: Bool) {
        buttons.forEach {
            $0.alpha = hidden ? 0 : 1
        }
    }
    
    func setHighlighterHidden(_ hidden: Bool) {
        let sourceHeight = hidden ? bounds.height : 0
        let targetHeight = hidden ? 0 : bounds.height
        
        let animation: CAAnimation = {
            $0.fromValue = sourceHeight / 2
            $0.toValue = targetHeight / 2
            $0.duration = highlighterAnimationDuration
            return $0
        }(CABasicAnimation(keyPath: "cornerRadius"))
        
        highlighterView.layer.add(animation, forKey: nil)
        highlighterView.layer.cornerRadius = targetHeight / 2
        
        UIView.animate(withDuration: highlighterAnimationDuration, animations: {
            self.highlighterView.frame.size.height = targetHeight
            self.highlighterView.alpha = hidden ? 0 : 1
            
            for label in self.labels  {
                label.alpha = hidden ? 0 : 1
            }
        })
    }
    
    func reloadData() {
        guard let dataSource = dataSource else { return }
        
        buttons = []
        labels = []
        
        let count = dataSource.numberOfItems(inTabSwitcher: self)
        for index in 0..<count {
            let button = createButton(forIndex: index, withDataSource: dataSource)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            
            let label = createLabel(forIndex: index, withDataSource: dataSource)
            labels.append(label)
            stackView.addArrangedSubview(label)
        }
    }
    
}

fileprivate extension ColorTabs {
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.distribution = .fillEqually
    }
    
    func createButton(forIndex index: Int, withDataSource dataSource: ColorTabsDataSource) -> UIButton {
        let button = UIButton()
        
        button.tintColor = highlightedIconColor
        button.setImage(dataSource.tabSwitcher(self, iconAt: index), for: UIControlState())
        button.setImage(dataSource.tabSwitcher(self, hightlightedIconAt: index), for: .selected)
        button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        
        return button
    }
    
    func createLabel(forIndex index: Int, withDataSource dataSource: ColorTabsDataSource) -> UILabel {
        let label = UILabel()
        
        label.isHidden = true
        label.textAlignment = .left
        label.text = dataSource.tabSwitcher(self, titleAt: index)
        label.textColor = titleTextColor
        label.adjustsFontSizeToFitWidth = true
        label.font = titleFont
        
        return label
    }
}

fileprivate extension ColorTabs {
    @objc func selectButton(_ sender: UIButton) {
        if let index = buttons.index(of: sender) {
            selectedSegmentIndex = index
        }
    }
    
    func transition(from fromIndex: Int, to toIndex: Int) {
        guard let fromLabel = labels[safe: fromIndex],
            let fromIcon = buttons[safe: fromIndex],
            let toLabel = labels[safe: toIndex],
            let toIcon = buttons[safe: toIndex] else {
                return
        }
        
        let animation = {
            fromLabel.isHidden = true
            fromLabel.alpha = 0
            fromIcon.isSelected = false
            
            toLabel.isHidden = false
            toLabel.alpha = 1
            toIcon.isSelected = true
            
            self.stackView.layoutIfNeeded()
            self.layoutIfNeeded()
            self.moveHighlighterView(toItemAt: toIndex)
        }
        
        UIView.animate(
            withDuration: switchAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 3,
            options: [],
            animations: animation,
            completion: nil
        )
    }
    
    func moveHighlighterView(toItemAt toIndex: Int) {
        guard let countItems = dataSource?.numberOfItems(inTabSwitcher: self) , countItems > toIndex else { return }
        
        let toLabel = labels[toIndex]
        let toIcon = buttons[toIndex]
        
        // offset for first item
        let point = convert(toIcon.frame.origin, to: self)
        let offsetForFirstItem: CGFloat = toIndex == 0 ? -highlighterViewOffScreenOffset : 0
        highlighterView.frame.origin.x = point.x + offsetForFirstItem
        
        // offset for last item
        let offsetForLastItem: CGFloat = toIndex == countItems - 1 ? highlighterViewOffScreenOffset : 0
        highlighterView.frame.size.width = toLabel.bounds.width + (toLabel.frame.origin.x - toIcon.frame.origin.x) + 10 - offsetForFirstItem + offsetForLastItem
        
        highlighterView.backgroundColor = dataSource!.tabSwitcher(self, tintColorAt: toIndex)
    }
}
