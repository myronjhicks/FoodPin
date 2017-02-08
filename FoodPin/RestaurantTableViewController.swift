//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by myron hicks on 2/1/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants : [RestaurantMO] = []
    
    var fetchResultController : NSFetchedResultsController<RestaurantMO>!
    
    var searchController : UISearchController!
    
    //used to store the search results
    var searchResults : [RestaurantMO] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Remove the title from the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //add search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search restaurants..."
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        
        //fetch data from data source
        let fetchRequest : NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        //controll how the results are sorted
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            }catch {
                print(error)
            }
        }
        
    }
    
    //content filtering method
    func filterContent(for searchText : String){
        searchResults = restaurants.filter({
            (restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
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
        if searchController.isActive {
            return searchResults.count
        }else{
            return restaurants.count
        }
    }

    //For each row populate it with data (resturant* arrays)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //Configure the cell
        let row = indexPath.row
        let restaurant = (searchController.isActive) ? searchResults[row] : restaurants[row]
        cell.nameLabel.text = restaurant.name
        cell.thumbnailImageView.image = UIImage(data: restaurant.image as! Data)
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        if restaurant.isVisited {
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else{
            return true
        }
    }
    
    //Swipe for more implementation (similar to Mail app (IOS)
    //Create custome actions for the table rows when they swipe left
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //Social sharing button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler:{
        (action, indexPath) -> Void in
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
            if let imageToShare = UIImage(data: self.restaurants[indexPath.row].image as! Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
            
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        
        //Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {
        (action, indexPath) -> Void in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                appDelegate.saveContext()
            }
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        
    }
}
