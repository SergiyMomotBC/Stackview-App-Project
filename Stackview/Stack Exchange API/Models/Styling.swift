//
//  Styling.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Styling: Decodable {
    let linkColorHEX: String?
    let tagBackgroundColorHEX: String?
    let tagForegroundColorHEX: String?
    
    private enum CodingKeys: String, CodingKey {
        case linkColorHEX = "link_color"
        case tagBackgroundColorHEX = "tag_background_color"
        case tagForegroundColorHEX = "tag_foreground_color"
    }
}
