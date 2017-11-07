//
//  ContextMenuDelegate.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

protocol ContextMenuDelegate: class {
    func contextMenu(_ contextMenu: ContextMenu, didSelect action: ContextMenuAction)
}
