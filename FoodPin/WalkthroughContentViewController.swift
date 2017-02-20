//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by Myron Hicks on 2/16/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel : UILabel!
    @IBOutlet var contentLabel : UILabel!
    @IBOutlet var contentImageView : UIImageView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var forwardButton : UIButton!
    
    var index = 0
    var heading = ""
    var imageFile = ""
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index
        switch index {
        case 0...1 : forwardButton.setTitle("NEXT", for: .normal)
        case 2 : forwardButton.setTitle("DONE", for: .normal)
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        switch  index {
        case 0...1 :
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.forward(index: index)
        case 2 :
            UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
            publishDynamicQuickActions()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    func publishDynamicQuickActions() {
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            let bundleIdentifier = Bundle.main.bundleIdentifier
            
            let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"), userInfo: nil)
            
            let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Discover restaurants", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover-shortcut"), userInfo: nil)
            
            let shortcutItem3 = UIApplicationShortcutItem(type: "\(bundleIdentifier).NewRestaurant", localizedTitle: "New Restaurant", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
            
            UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2, shortcutItem3]
        }
    }

}
