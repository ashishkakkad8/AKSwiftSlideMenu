//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            break
        case 1:
            print("Play\n", terminator: "")
            break
        case 2:
            print("Camera\n", terminator: "")
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(self.defaultMenuImage(), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: "onSlideMenuButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 22), false, 0.0)
            
            UIColor.blackColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 3, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 10, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 17, 30, 1)).fill()
            
            UIColor.whiteColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 4, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 11,  30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 18, 30, 1)).fill()
            
            defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        })
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(sender : UIButton){
        if (sender.tag == 10)
        {
            // Menu is already displayed, no need to display it twice, otherwise we hide the menu
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenu : UIView = view.subviews.last!
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var rectViewMenu : CGRect = viewMenu.frame
                rectViewMenu.origin.x = -1 * UIScreen.mainScreen().bounds.size.width
                viewMenu.frame = rectViewMenu
                viewMenu.layoutIfNeeded()
                viewMenu.backgroundColor = UIColor.clearColor()
                }, completion: { (finished) -> Void in
                    viewMenu.removeFromSuperview()
            })
            
            return
        }
        
        sender.enabled = false
        sender.tag = 10
        
        let objMenu : MenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        objMenu.btnMenu = sender
        objMenu.delegate = self
        self.view.addSubview(objMenu.view)
        self.addChildViewController(objMenu)
        objMenu.view.layoutIfNeeded()
        
        
        objMenu.view.frame=CGRectMake(0 - UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            objMenu.view.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height);
            sender.enabled = true
            }, completion:nil)
    }
}
