//
//  Suggestion.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 17/12/2015.
//  Copyright © 2015 Vincent Kelleher. All rights reserved.
//

import UIKit

class Suggestion: NSObject {
    
    var title:String
    var type:String
    var summary:String
    var image:UIImage
        
    init(title:String, type:String, summary:String) {
        self.title = title
        self.type = type
        self.summary = summary
        self.image = UIImage()
    }
}
