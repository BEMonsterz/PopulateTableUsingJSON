//
//  PopulateTableViewController.swift
//  PopulateTableUsingJSON
//
//  Created by Bryan Ayllon on 7/25/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit

class PopulateTableViewController: UITableViewController {

    var populate = [PopulateStuff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        populateStuff()
        
        
    }
    
    private func populateStuff() {
        
        let populateAPI = "http://jsonplaceholder.typicode.com/photos"
        
        guard let url = NSURL(string: populateAPI) else {
            fatalError("Invalid URL")
        }
        
        let session = NSURLSession.sharedSession()
        
        
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            
            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                fatalError("Unable to format data")
            }
            
            let jsonArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            
            
            
            for item in jsonArray {
                
                let populate = PopulateStuff()
                populate.title = item.valueForKey("title") as! String
                
                populate.thumbnailUrl = item.valueForKey("thumbnailUrl") as! String
                
                self.populate.append(populate)
                
            }
            
            // loop ended I can refresh the tableview
            dispatch_async(dispatch_get_main_queue(), {
                
                
                // this is the main/ui thread
                self.tableView.reloadData()
                
            })
            
            
            
            }.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.populate.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PopulateCell", forIndexPath: indexPath)
        
        let populateStuff = self.populate[indexPath.row]
   
        let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(q){
            
                    guard let imageURL = NSURL(string: populateStuff.thumbnailUrl) else {
                        fatalError("Invalid URL")
                    }
            
                    let imageData = NSData(contentsOfURL: imageURL)
            
                    let image = UIImage(data: imageData!)
            dispatch_async(dispatch_get_main_queue(),{
                
                cell.imageView?.image = image
                self.tableView.reloadData()
            })
        }
        
        
        
        cell.textLabel?.text = populateStuff.title
        
        return cell
    }
    
   }
