//
//  SuggestionView.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 17/12/2015.
//  Copyright © 2015 Vincent Kelleher. All rights reserved.
//

import UIKit

class SuggestionTableViewController: UITableViewController {
    
    var suggestion:Suggestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell") as UITableViewCell!
            
            cell.textLabel!.text = suggestion.title
            cell.textLabel!.font = UIFont.systemFontOfSize(22.0)
            
            return cell
        }
        
        if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionImageCell") as! SuggestionImageCell
            
            cell.imageView!.image = suggestion.image
            cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
            
            return cell
        }
        
        if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SuggestionCell") as UITableViewCell!
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.Justified
            
            let attributedString = NSAttributedString(string: suggestion.summary,
                attributes: [
                    NSParagraphStyleAttributeName: paragraphStyle,
                    NSBaselineOffsetAttributeName: NSNumber(float: 0)
                ])

            
            cell.textLabel!.attributedText = attributedString
            cell.textLabel!.font = UIFont.systemFontOfSize(13.5)
            cell.textLabel!.numberOfLines = 0
            
            return cell
        }

        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 1) {
            return 200
        }
        
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
