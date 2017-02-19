//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Myron Hicks on 2/18/17.
//  Copyright © 2017 myron hicks. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants : [CKRecord] = []
    
    @IBOutlet var spinner : UIActivityIndicatorView!
    
    var imageCache = NSCache<CKRecordID, NSURL>()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadSpinnerWhileFetchingData()
        fetchRecordsFromCloud()
        pullToRefreshControl()
        
        // Enable Self Sizing Cells
        tableView.estimatedRowHeight = 249.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func pullToRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControlEvents.valueChanged)
    }
    
    func loadSpinnerWhileFetchingData() {
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func fetchRecordsFromCloud() {
        //wipe data before fetching
        restaurants.removeAll()
        tableView.reloadData()
        //fetch data using Convenience API
        let cloudContainer = CKContainer.init(identifier: "iCloud.hicks.FoodPinCloud")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name", "type", "location"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {
            (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = {
            (cursor, error) -> Void in
            
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            
            print("Successfully retrieved the data from iCloud")
            
            OperationQueue.main.addOperation {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
            
            if let refreshControl = self.refreshControl {
                if refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
            }
        }
        
        publicDatabase.add(queryOperation)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantTableViewCell
        
        let restaurant = restaurants[indexPath.row]
        print(restaurant)
        cell.nameLabel.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel.text = restaurant.object(forKey: "type") as? String
        cell.locationLabel.text = restaurant.object(forKey: "location") as? String
        
        //set the default image
        cell.thumbnailImageView.image = UIImage(named: "photoalbum")
        
        if let imageFileUrl = imageCache.object(forKey: restaurant.recordID) {
            //fetch image from cache
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileUrl as URL) {
                cell.thumbnailImageView.image = UIImage(data: imageData)
                //cell.imageView?.image = UIImage(data: imageData)
            }
        }else{
            //fetch image from cloud in background
            let publicDatabase = CKContainer.init(identifier: "iCloud.hicks.FoodPinCloud").publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = {
                (record, recordID, error) -> Void in
                if let error = error {
                    print("Failed to get restaurant image from iCloud - \(error.localizedDescription)")
                    return
                }
                
                if let restaurantRecord = record {
                    OperationQueue.main.addOperation {
                        if let image = restaurantRecord.object(forKey: "image") {
                            let imageAsset = image as! CKAsset
                            
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                                cell.thumbnailImageView.image = UIImage(data: imageData)
                            }
                            
                            //add the image URL to cache
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                        }
                    }
                }
            }
            
            publicDatabase.add(fetchRecordsImageOperation)
        }
        
        return cell
        
    }

}
