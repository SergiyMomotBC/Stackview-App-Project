//
//  TabSelectorView.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TabSelectorView: UIStackView {
    var normalColor: UIColor = .white
    var selectedColor: UIColor = .flatRed
    var currentIndex: Int = 0
    var animationSpeed: Double = 0.2
    var selectorHeight: CGFloat = 3.0
    var tabChangedHandler: ((Int) -> Void)?
    
    private var tabButtons: [UIButton] = []
    
    private lazy var selectorView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1, height: self.selectorHeight)))
        view.backgroundColor = self.selectedColor
        view.layer.cornerRadius = view.frame.height / 2
        return view
    }()
    
    init(tabs: [String], initialIndex: Int = 0) {
        super.init(frame: .zero)
        
        distribution = .fillProportionally
        axis = .horizontal
        alignment = .leading
        spacing = 4.0
        
        for (index, tab) in tabs.enumerated() {
            let button = createButton(title: tab, id: index)
            addArrangedSubview(button)
            tabButtons.append(button)
        }
        
        addSubview(selectorView)
        
        tabButtons.first!.isSelected = true
        
        if initialIndex != 0 {
            selectTab(at: initialIndex)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x = tabButtons[currentIndex].frame.origin.x
        let y = tabButtons[currentIndex].frame.height - selectorHeight
        let width = tabButtons[currentIndex].frame.width
        
        selectorView.frame = CGRect(x: x, y: y, width: width, height: selectorHeight)
    }
    
    private func animateSelector() {
        let button = tabButtons[currentIndex]
        
        UIView.animate(withDuration: animationSpeed) {
            self.selectorView.frame = CGRect(origin: CGPoint(x: button.frame.origin.x, y: self.selectorView.frame.origin.y),
                                             size: CGSize(width: button.frame.width, height: self.selectorView.frame.height))
        }
    }
    
    func selectTab(at index: Int) {
        tabButtons[currentIndex].isSelected = false
        tabButtons[index].isSelected = true
        currentIndex = index
        tabChangedHandler?(index)
        animateSelector()
    }
    
    private func createButton(title: String, id: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = id
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(selectedColor, for: .selected)
        button.setTitleColor(selectedColor, for: .highlighted)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        guard button.tag != currentIndex else { return }
        selectTab(at: button.tag)
    }
}
