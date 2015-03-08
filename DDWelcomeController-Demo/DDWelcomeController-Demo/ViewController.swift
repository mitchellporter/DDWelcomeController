//
//  ViewController.swift
//  DDWelcomeController-Demo
//
//  Created by 端 闻 on 8/3/15.
//  Copyright (c) 2015年 monk-studio. All rights reserved.
//

import UIKit

let segueToWelcomeID = "toTutorial"

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(animated: Bool) {
        //distinguish whether is the first launch
        var defaults = NSUserDefaults.standardUserDefaults()
        if(defaults.boolForKey("everLaunchedBefore") == false){
            self.performSegueWithIdentifier(segueToWelcomeID, sender: nil)
            defaults.setBool(true, forKey: "everLaunchedBefore")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //these are all sample view setups
        let view1 = UIView(frame: UIScreen.mainScreen().bounds)
        let view2 = UIView(frame: UIScreen.mainScreen().bounds)
        let view3 = UIView(frame: UIScreen.mainScreen().bounds)
        view1.backgroundColor = UIColor(white: 0.3, alpha: 1)
        view2.backgroundColor = UIColor(white: 0.5, alpha: 1)
        view3.backgroundColor = UIColor(white: 0.7, alpha: 1)
        let words1 = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, self.view.frame.height))
        words1.text = "VIEW1"
        words1.textColor = UIColor.whiteColor()
        words1.textAlignment = NSTextAlignment.Center
        words1.font = UIFont.boldSystemFontOfSize(40)
        words1.center = view1.center
        view1.addSubview(words1)
        let words2 = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, self.view.frame.height))
        words2.text = "VIEW2"
        words2.textColor = UIColor.whiteColor()
        words2.textAlignment = NSTextAlignment.Center
        words2.font = UIFont.boldSystemFontOfSize(40)
        words2.center = view2.center
        view2.addSubview(words2)
        let words3 = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, self.view.frame.height))
        words3.text = "VIEW3"
        words3.textColor = UIColor.whiteColor()
        words3.textAlignment = NSTextAlignment.Center
        words3.font = UIFont.boldSystemFontOfSize(40)
        words3.center = view3.center
        view3.addSubview(words3)
        let words4 = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, self.view.frame.height))
        words4.text = "Swipe up to Get In"
        words4.textColor = UIColor.whiteColor()
        words4.font = UIFont.italicSystemFontOfSize(20)
        words4.textAlignment = NSTextAlignment.Center
        words4.center = view3.center
        words4.center = CGPointMake(words4.center.x, words4.center.y + 30)
        view3.addSubview(words4)
        
        //magic begin here
        let destinationVC = segue.destinationViewController as DDWelcomeController
        destinationVC.transitioningDelegate = destinationVC
        destinationVC.views = [view1,view2,view3]
    }
    @IBAction func unwindToMainMenu(sender:UIStoryboardSegue!){
        
    }

    

}

