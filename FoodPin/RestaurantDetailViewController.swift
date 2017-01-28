//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Ziga Besal on 30/12/2016.
//  Copyright © 2016 Ziga Besal. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    var restaurant: RestaurantMO!
    var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = restaurant.name
        
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        mapView.alpha = 0.0
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    self.location = location
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.mapView.alpha = 1.0
                    }, completion: {
                        completed in
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showMap))
                        self.mapView.addGestureRecognizer(tapGestureRecognizer)
                    })
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RestaurantDetailTableViewCell
        cell.backgroundColor = UIColor.clear
        
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
            cell.fieldLabel.text = "Been here"
            cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I've been here before. \(restaurant.rating == nil ? "" : restaurant.rating!)" : "No"
        case 4:
            cell.fieldLabel.text = "Phone"
            cell.valueLabel.text = restaurant.phone
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = self.restaurant
        } else if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = self.restaurant
            destinationController.location = self.location
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue) {
        
        if let rating = segue.identifier {
            restaurant.isVisited = true
            
            switch rating {
            case "great": restaurant.rating = "Absolutely love it! Must try"
            case "good": restaurant.rating = "Pretty good"
            case "dislike": restaurant.rating = "I don't like it"
            default: break
                
            }
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.saveContext()
        }
        
        tableView.reloadData()
    }
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
}
