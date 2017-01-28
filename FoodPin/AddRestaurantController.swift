//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Ziga Besal on 14/01/2017.
//  Copyright © 2017 Ziga Besal. All rights reserved.
//

import UIKit
import CoreData

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var textFieldName: UITextField!
    @IBOutlet var textFieldType: UITextField!
    @IBOutlet var textFieldLocation: UITextField!
    @IBOutlet var textFieldPhone: UITextField!
    
    @IBOutlet var btnBeenHere: UIButton!
    @IBOutlet var btnHaveNotBeenHere: UIButton!
    var isVisited = true
    
    var restaurant: RestaurantMO!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            
            let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true
            
            let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true
            
            let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true
        }
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func visitedStatusChanged(_ sender: UIButton) {
        sender.backgroundColor = UIColor.red
        if (sender == btnBeenHere) {
            isVisited = true
            btnHaveNotBeenHere.backgroundColor = UIColor.lightGray
        } else if (sender == btnHaveNotBeenHere) {
            isVisited = false
            btnBeenHere.backgroundColor = UIColor.lightGray
        }
    }
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveRestaurant" {
            let restaurantName: String = textFieldName.text!
            let restaurantType: String = textFieldType.text!
            let restaurantLocation: String = textFieldLocation.text!
            
            if restaurantName == "" || restaurantType == "" || restaurantLocation == "" {
                let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                return false
            }
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                restaurant = RestaurantMO(context:
                    appDelegate.persistentContainer.viewContext)
                restaurant.name = restaurantName
                restaurant.type = restaurantType
                restaurant.location = restaurantLocation
                if let restaurantPhone = textFieldPhone.text {
                    restaurant.phone = restaurantPhone
                }
                restaurant.isVisited = isVisited
                if let restaurantImage = photoImageView.image {
                    if let imageData = UIImagePNGRepresentation(restaurantImage) {
                        restaurant.image = NSData(data: imageData)
                    }
                }
                
                print("Saving data to context ...")
                appDelegate.saveContext()
            }

        }

        return true
    }

}
