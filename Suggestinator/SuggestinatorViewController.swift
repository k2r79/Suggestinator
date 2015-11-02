//
//  SuggestinatorViewController.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 21/10/2015.
//  Copyright © 2015 Vincent Kelleher. All rights reserved.
//

import UIKit

class SuggestionatorViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FindSuggestions" {
            if let destination = segue.destinationViewController as? SuggestionsViewController {
                destination.query = "Pulp Fiction"
            }
        }
    }
}