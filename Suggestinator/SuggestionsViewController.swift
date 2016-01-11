//
//  ViewController.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 21/10/2015.
//  Copyright © 2015 Vincent Kelleher. All rights reserved.
//

import UIKit

class SuggestionsViewController: UICollectionViewController {
    
    var query = ""
    var suggestions = [Suggestion]()
    var suggestionDataTask:NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let computedCellSize = (self.collectionView!.frame.size.width - 20) / 2
        
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSizeMake(computedCellSize, computedCellSize)
        
        self.findSuggestions({ () -> () in
            self.collectionView?.reloadData();
        }) { () -> () in
            let alert = UIAlertController(title: "No results...", message: "No results have been found for your search criteria.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                let homeView = self.storyboard!.instantiateViewControllerWithIdentifier("HomeView") as! SuggestionatorViewController
                self.showViewController(homeView, sender: homeView)
                
                return nil
            }()))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func findSuggestions(callback:() -> (), noResultCallback:() -> ()) {
        let encodedQuery = "https://www.tastekid.com/api/similar?k=173208-Suggesti-9BWWRVBZ&verbose=1&q=" + query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let request = NSMutableURLRequest(URL: NSURL(string: encodedQuery)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        suggestionDataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            let tasteKidJSON = JSON(data: data!)
            let results = tasteKidJSON["Similar"]["Results"];
            for (_, json) in results {
                var suggestion = Suggestion(title: json["Name"].string!, type: json["Type"].string!, summary: json["wTeaser"].string!)
                
                if json["yID"].string != nil {
                    let imageURL = "https://i.ytimg.com/vi/" + json["yID"].string! + "/hqdefault.jpg"
                    if let imageData = self.getDataFromUrl(imageURL) {
                        suggestion.image = UIImage(data: imageData)!
                    }
                }
                
                self.suggestions.append(suggestion)
                
                dispatch_async(dispatch_get_main_queue(), {
                    callback()
                })
            }
            
            if (results.isEmpty) {
                noResultCallback();
            }
        }
        
        suggestionDataTask!.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SuggestionCell", forIndexPath: indexPath) as! SuggestionCellViewController
        
        let suggestion = self.suggestions[indexPath.item]
        cell.suggestion = suggestion
        cell.label.text = suggestion.title
        cell.imageView.image = suggestion.image
        
        return cell
    }
    
    private func getDataFromUrl(url:String) -> NSData? {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url) {
                return data
            }
        }
        
        return nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        suggestionDataTask!.cancel()
        
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OpenSuggestionDetails" {
            if let destination = segue.destinationViewController as? SuggestionTableViewController {
                destination.suggestion = (sender as? SuggestionCellViewController)!.suggestion
            }
        }
    }
}

