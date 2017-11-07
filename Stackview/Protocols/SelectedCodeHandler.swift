//
//  SelectedCodeHandler.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

protocol SelectedCodeHandler: class {
    func handleCode(_ codeHTML: String)
}

extension SelectedCodeHandler where Self: UIViewController {
    func handleCode(_ codeHTML: String) {
        navigationController?.show(CodeViewController(for: codeHTML), sender: nil)
    }
}
