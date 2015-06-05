//
//  CollectAPIMenuViewController.swift
//  Tealium Collect Library
//
//  Created by George Webster on 3/10/15.
//  Copyright (c) 2015 Tealium Inc. All rights reserved.
//

import UIKit

enum MenuItems: Int {
    case SendEvent = 0
    case SendView
    case FetchProfile
    case LogLastProfile
    case NumberOfItems
}

class CollectAPIMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UITableViewDatasource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuItems.NumberOfItems.rawValue
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ASMenuCellIdentifier") as! UITableViewCell
        
        if let menuItem = MenuItems(rawValue: indexPath.row) {
            
            switch menuItem {
                
            case .SendEvent:
                cell.textLabel?.text = "Send Event"
                
            case .SendView:
                cell.textLabel?.text = "Send View"
                
            case .FetchProfile:
                cell.textLabel?.text = "Fetch Current Profile"
            
            case .LogLastProfile:
                cell.textLabel?.text = "Log Last Loaded Profile"
                
            default:
                println("un supported menu item")
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let menuItem = MenuItems(rawValue: indexPath.row) {
            
            switch menuItem {
                
            case .SendEvent:
                sendCollectEvent()
                
            case .SendView:
                sendCollectView()
                
            case .FetchProfile:
                fetchCollectVisitorProfile()
                
            case .LogLastProfile:
                accessLastLoadedVisitorProfile()
                
            default:
                println("un supported menu item")
            }
        }
    }
    
    
    func sendCollectView() {
        
        let data: [String: String] = [ "event_name" : "m_view" ]
        
        TealiumCollect.sendViewWithData(data)
    }
    
    func sendCollectEvent() {

        let data: [String: String] = [ "event_name" : "m_link" ]

        TealiumCollect.sendEventWithData(data)
    }
    
    func fetchCollectVisitorProfile() {
        
        TealiumCollect.fetchVisitorProfileWithCompletion { (profile, error) -> Void in
            
            if (error != nil) {
                println("test app failed to receive profile with error: \(error.localizedDescription)")
            } else {
                println("test app received profile: \(profile)")
            }
        }
    }
    
    func accessLastLoadedVisitorProfile() {
        
        if let profile:TEALVisitorProfile = TealiumCollect.cachedVisitorProfileCopy() {
            println("last loaded profile: \(profile)")
        } else {
            println("a valid profile has not been received yet.")
        }
    }
    
    func presentTraceInputView() {
    
    }
    
    func joinTraceWithToken( token:String ) {
    
        TealiumCollect.joinTraceWithToken(token)
    }

    func leaveTrace() {
        
        TealiumCollect.leaveTrace()
    }
}


