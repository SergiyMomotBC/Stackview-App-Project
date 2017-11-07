//
//  PostsFilterOptionsDelegate.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/5/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

protocol PostsFilterOptionsDelegate: class {
    func shouldApplyOptions(_ options: SearchParameters)
}

