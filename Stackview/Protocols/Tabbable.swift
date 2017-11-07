//
//  Tabbable.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/5/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

protocol Tabbable where Self: UIViewController {
    var icon: UIImage { get }
    var iconTitle: String { get }
}
