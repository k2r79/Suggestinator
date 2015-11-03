//
//  ViewController.swift
//  Suggestinator
//
//  Created by Vincent Kelleher on 21/10/2015.
//  Copyright © 2015 Vincent Kelleher. All rights reserved.
//

import UIKit

class SuggestionsViewController: UICollectionViewController {
    
    struct Suggestion {
        var title:String
        var type:String
        var image:UIImage
        
        init(title:String, type:String) {
            self.title = title
            self.type = type
            self.image = UIImage()
        }
    }
    
    var query = ""
    var suggestions = [Suggestion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let computedCellSize = (self.collectionView!.frame.size.width - 20) / 2
        
        let layout = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSizeMake(computedCellSize, computedCellSize)
        
        self.findSuggestions() { () -> () in
            self.collectionView?.reloadData();
        }
    }
    
    private func findSuggestions(callback:() -> ()) {
        let encodedQuery = "https://www.tastekid.com/api/similar?k=173208-Suggesti-9BWWRVBZ&q=" + query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let request = NSMutableURLRequest(URL: NSURL(string: encodedQuery)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) in
            let tasteKidJSON = JSON(data: data!)
            for (_, json) in tasteKidJSON["Similar"]["Results"] {
                var suggestion = Suggestion(title: json["Name"].string!, type: json["Type"].string!)
                self.findImage(&suggestion)
                
                self.suggestions.append(suggestion)
                
                dispatch_async(dispatch_get_main_queue(), {
                    callback()
                })
            }
        }.resume()
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
        cell.label.text = suggestion.title
        cell.imageView.image = suggestion.image //UIImage(named: "Fredo")
        
        return cell
    }
    
    private func findImage(inout suggestion:Suggestion) {
        let url_encoded = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=1&q=" + suggestion.title.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        let googleImageJSON = JSON(data: getDataFromUrl(url_encoded)!)
        
        let imageUrl = googleImageJSON["responseData"]["results"][0]["url"].string!
        
        if let imageData = getDataFromUrl(imageUrl) {
            suggestion.image = UIImage(data: imageData)!
        }
    }
    
    private func getDataFromUrl(url:String) -> NSData? {
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url) {
                return data
            }
        }
        
        return nil
    }
}

