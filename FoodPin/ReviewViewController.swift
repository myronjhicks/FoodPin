//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Myron Hicks on 2/4/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView : UIImageView!
    @IBOutlet var containerView : UIView!
    @IBOutlet var reviewImageView: UIImageView!
    
    var restaurant : RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(data: restaurant.image as! Data)
        reviewImageView.image = UIImage(data: restaurant.image as! Data)
        
        // Do any additional setup after loading the view.
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //combining two transforms
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y:0)
        let translateTransform = CGAffineTransform(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform  = CGAffineTransform.identity
        })

        /* Spring Animation
         UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            //self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
        */
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
