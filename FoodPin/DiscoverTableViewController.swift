//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Ziga Besal on 04/02/2017.
//  Copyright © 2017 Ziga Besal. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var restaurants: [CKRecord] = []
    var imageCache = NSCache<CKRecordID, NSURL>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        fetchRecordsFromCloud()
        
        // Spinner config
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
        
        // Pull to refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    func fetchRecordsFromCloud() {
        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()        
        
        // Fetch data using convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        // Create query operation
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        
        queryOperation.recordFetchedBlock = {
            (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = {
            (cursor, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            print("Results fetch sucessful")
            // Reload data under main thread for swift experience... See what I did there?
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        // Set the default image
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        // Check if image is available in cache
        if let imageFileUrl = imageCache.object(forKey: restaurant.recordID) {
            if let imageData = try? Data.init(contentsOf: imageFileUrl as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        } else {
            
        }
        // Fetch image from iCloud
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsImageOperation.desiredKeys = ["image"]
        fetchRecordsImageOperation.queuePriority = .veryHigh
        
        fetchRecordsImageOperation.perRecordCompletionBlock = {
            (record, recordID, error) -> Void in
            if error != nil {
                print("Error fetching image: \(error?.localizedDescription)")
                return
            }
            
            if let restaurantRecord = record {
                OperationQueue.main.addOperation {
                    if let image = restaurantRecord.object(forKey: "image") {
                        let imageAsset = image as! CKAsset
                        if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                            cell.imageView?.image = UIImage(data: imageData)
                        }
                        
                        // Add image URL to cache
                        self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                    }
                }
            }
        }
        
        publicDatabase.add(fetchRecordsImageOperation)
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
