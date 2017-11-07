//
//  TagPickerControllerDelegate.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/9/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

protocol TagPickerControllerDelegate: class {
    func tagPickerBeginAddingTags(_ tagPicker: TagPickerController)
    func tagPickerDoneAddingTags(_ tagPicker: TagPickerController, changesCommited: Bool)
}
