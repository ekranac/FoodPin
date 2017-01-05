//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Ziga Besal on 21/12/2016.
//  Copyright © 2016 Ziga Besal. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    var restaurants:[Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "Hong Kong", image: "cafedeadend.jpg", visited: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei.jpg", visited: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha.jpg", visited: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl.jpg", visited: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster.jpg", visited: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkeerestaurant.jpg", visited: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier.jpg", visited: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery.jpg", visited: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haighschocolate.jpg", visited: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palominoespresso.jpg", visited: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate.jpg", visited: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif.jpg", visited: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "grahamavenuemeats.jpg", visited: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "wafflewolf.jpg", visited: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves.jpg", visited: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore.jpg", visited: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional.jpg", visited: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina.jpg", visited: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia.jpg", visited: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak.jpg", visited: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "caskpubkitchen.jpg", visited: false)
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove text from back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurant = restaurants[indexPath.row]
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.thumbnailImageView.image = UIImage(named: restaurant.image)
        
        cell.accessoryType = restaurant.visited ? .checkmark : .none

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete data based on indexPath
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexpath: IndexPath) -> [UITableViewRowAction]? {
        let restaurant = restaurants[indexpath.row]
        var activityItems: [Any] = []
        let shareAction = UITableViewRowAction(style: .default, title: "Share", handler: {
            (action, indexPath) -> Void in
            activityItems.append("Just checking in at \(restaurant.name)")
            if let imageToShare = UIImage(named: restaurant.image) {
                activityItems.append(imageToShare)
            }
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: {
            (action, indexPath) -> Void in
            let index = indexPath.row
            self.restaurants.remove(at: index)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        shareAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let index = tableView.indexPathForSelectedRow?.row {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[index]
            }
        }
    }
 

}
