//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by myron hicks on 2/1/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit


//This class has a table view associated with it
//In order to populate the table view we need to adopt UITableViewDataSource and UITableViewDelegate
class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = restaurant.name
        
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        //remove the seperators of the empty rows
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //change the color of the seperators
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        restaurantImageView.image = UIImage(named: restaurant.image)
        
        //to enable self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //For each of the rows in the table, populate the two fields of the prototype cell
    //Displays 4 field/value pairs of restaurant information
    //the restaurant variable was populated from the prepare method in the restaurant table view controller
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Name"
            cell.valueLabel.text = restaurant.name
        case 1:
            cell.fieldLabel.text = "Type"
            cell.valueLabel.text = restaurant.type
        case 2:
            cell.fieldLabel.text = "Location"
            cell.valueLabel.text = restaurant.location
        case 3:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        case 4:
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited ? "Yes, I've been here before. \(restaurant.rating)" : "No")
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    @IBAction func close(segue:UIStoryboardSegue){
        
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue){
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great" :
                restaurant.rating = "Absolutely love it! Must try."
            case "good" :
                restaurant.rating = "Pretty good."
            case "dislike" :
                restaurant.rating = "I don't like it."
            default:
                break
            }
        }
        
        tableView.reloadData()
    }
    


}
