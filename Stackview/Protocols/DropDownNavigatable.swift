//
//  DropDownNavigatable.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/24/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

protocol DropDownNavigatable {}

extension DropDownNavigatable where Self: DataViewController {
    func enableDropDownMenu(with items: [String], title: String, initialItemIndex index: Int, handler: @escaping (Int) -> Void) {
        guard let navigationController = self.navigationController else { return }
        
        let dropDownMenu = BTNavigationDropdownMenu(navigationController: navigationController, containerView: navigationController.view, title: title, subtitle: items[index], items: items)

        dropDownMenu.cellTextLabelAlignment = .center
        dropDownMenu.animationDuration = 0.25
        dropDownMenu.didSelectItemAtIndexHandler = handler
        
        self.navigationItem.titleView = dropDownMenu
    }
}
