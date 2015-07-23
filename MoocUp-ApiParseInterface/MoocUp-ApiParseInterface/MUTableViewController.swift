//
//  MUTableViewController.swift
//  MoocUp-ApiParseInterface
//
//  Created by Ancil on 7/22/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

import UIKit

let MUServerScheme = "https"
let MUServerHost = "api.coursera.org"
let MUServerPath = "/api/catalog.v1/"
let kMUTableViewCellIdentifier = "cell"

class MUTableViewController: UITableViewController {

    //MARK: - data members
    var courses = [Dictionary<String,AnyObject>]()
    let endpoint = "courses"
    
    let courseFields = [
        "id",
        "shortName",
        "name",
        "language",
        "photo",
        "smallIcon"
    ]

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let queryItems = getQueryItems(fromQueryNames: ["fields"])
        let url = getNSURL(fromEnpoint: endpoint, andQueryItems: queryItems)
        let data = NSData(contentsOfURL: url)!
        
        var coursesDict = NSJSONSerialization.JSONObjectWithData(
            data, options: nil, error: nil)!
            as! Dictionary<String,AnyObject>
        
        courses = coursesDict["elements"]! as! [Dictionary<String,AnyObject>]
        
    }

    //MARK: - URL Construction Methods
    func getQueryItems(fromQueryNames names:[String])->[NSURLQueryItem]
    {
        var queryItems = [NSURLQueryItem]()
        for name in names {
            if let value = getQueryValue(forName: name) {
                queryItems.append(NSURLQueryItem(name: name, value: value))
            } else {
                assert(false,"Error in getQueryItems(fromQueryNames)")
            }
        }
        return queryItems
    }
    
    func getNSURL(fromEnpoint enpoint: String, andQueryItems items:[NSURLQueryItem])->NSURL
    {
        var components:NSURLComponents = NSURLComponents()
        components.scheme = MUServerScheme
        components.host = MUServerHost
        components.path = MUServerPath + endpoint
        components.queryItems = items
        
        if let url = components.URL{
            return url
        } else {
            assert(false,"Error in getNSURL(fromEndpoint,andQueryItems)")
        }
    }
    
    func getQueryValue(forName name:String) -> String? {
        
        switch name {
            case "fields":
                return ",".join(courseFields)
                
            default:
                return nil
        }
    }
    
    
    //MARK: - TableView Data Source Delegate Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(kMUTableViewCellIdentifier) as! UITableViewCell
        
        var str = courses[indexPath.row]["name"] as! String
        
        cell.textLabel?.text = str
        
        return cell
    }

}

