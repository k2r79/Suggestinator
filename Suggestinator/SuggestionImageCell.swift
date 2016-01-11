//
//  SuggestionTitleCell.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 11/01/2016.
//  Copyright © 2016 Vincent Kelleher. All rights reserved.
//

import UIKit

class SuggestionImageCell: UITableViewCell {
    
    override func layoutSubviews() {
        imageView?.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
    }
}
