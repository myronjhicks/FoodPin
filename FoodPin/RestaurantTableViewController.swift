//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by myron hicks on 2/1/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var restaurants : [Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F 72 Po Hing Fong, Sheung Wan, Hong Kong", image: "cafedeadend.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", image: "homei.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", image: "teakha.jpg", phone: "456-789-1234",isVisited: false),
        Restaurant(name: "Cafe Loisl", type: "Austrian Casual Drink", location: "Shop B, 20 Tai Pint Shan Road SOHO, Sheung Wan, Hong Kong", image: "cafeloisl.jpg", phone: "456-789-1234",isVisited: false),
        Restaurant(name: "Petite Oyster", type: "French", location: " 24 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", image: "petiteoyster.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Shop J-K., 200 Hollywood Woad, SOHO, Sheung Wan, Hong Kong", image: "forkeerestaurant.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "G/F, 62 Po Hing Fond, Sheung Wan, Hong Kong", image: "posatelier.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Bourke Street Bakery", type: "Chocolate", location: "633 Bourke St Sydney New South Wales 2010 Surry Hills", image: "bourkestreetbakery.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "412-414 George St Sydney New South Wales", image: "haighschocolate.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Shop 1 61 York St Sydney New South Wales", image: "palominoespresso.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Upstate", type: "American", location: "95 1st Ave New York, NY 10003", image: "upstate.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Traif", type: "American", location: "225 S 4th St Brooklyn, NY 11211", image: "traif.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Graham Avenus Meats", type: "Breakfast & Brunch", location: "455 Graham Ave Brooklyn, NY 11211", image: "grahamavenuemeats.jps", phone: "456-789-1234",  isVisited: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "413 Graham Ave Brooklyn, NY 11211", image: "wafflewolf.jpg", phone: "456-789-1234", isVisited:false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "18 Bedford Ave Brooklyn, NY 11211", image: "fiveleaves.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "Sunset Park 4601 4th Ave Brooklyn, NY 11220", image: "cafelore.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "308 E 6th St New York, NY 10003", image: "confessional.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Barafina", type: "Spanish", location: "54 Frith Street London W1D 4SL United Kingdom", image: "barrafina", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "10 Seymour Place London W1H 7ND United Kingdom", image: "donostia.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "Royal Oak", type: "British", location: "2 Regency Street London Sw1P 4BZ United Kingdom", image: "royaloak.jpg", phone: "456-789-1234", isVisited: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "22 Charlwood Street London SW1V 2DY Pimlico", image: "caskpubkitchen.jpg", phone: "456-789-1234", isVisited: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove the title from the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    //used to send data to the next controller the segue leads to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Used to load how many rows in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    //For each row populate it with data (resturant* arrays)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //Configure the cell
        let row = indexPath.row
        cell.nameLabel.text = restaurants[row].name
        cell.thumbnailImageView.image = UIImage(named: restaurants[row].image)
        cell.locationLabel.text = restaurants[row].location
        cell.typeLabel.text = restaurants[row].type
        
        if restaurants[indexPath.row].isVisited {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //Used to delete a row in the table view. By default it makes swipe left to delete availble without any action
    //if delete is pressed
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            restaurants.remove(at: indexPath.row)
        }
        
        //trigger the view to reload its data
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //Swipe for more implementation (similar to Mail app (IOS)
    //Create custome actions for the table rows when they swipe left
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Social sharing button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler:{
        (action, indexPath) -> Void in
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name
            if let imageToShare = UIImage(named: self.restaurants[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        
        //Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {
        (action, indexPath) -> Void in
            self.restaurants.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction, shareAction]
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
}
