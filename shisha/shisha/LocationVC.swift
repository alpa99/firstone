//
//  LocationVC.swift
//  Smolo
//
//  Created by Alper Maraz on 05.07.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapTV: UITableView!
    
    
    let regionRadius: CLLocationDistance = 500
    
    let locationManager = CLLocationManager()
    
    // var adresses = ["Goseriede 12, 30159 Hannover, Deutschland"]
    
    var adresse = [BarInfos]()
    var BarAdressen = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        mapTV.delegate = self
        mapTV.dataSource = self
        
        
        fetchAdress()
        
        
        
    }
    
    
    func fetchAdress() {
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Barliste").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let adresse = BarInfos(dictionary: dictionary)
                adresse.setValuesForKeys(dictionary)
                //print(adresse.Adresse!)
                self.BarAdressen.append(adresse.Adresse!)
                print(self.BarAdressen)
                for a in 0 ..< self.BarAdressen.count {
                    self.getPlaceMarkFromAdress(adress: self.BarAdressen[a])
                }
            }
            
            
        }, withCancel: nil)
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        locationAuthStatus()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /*  func centerMapOnLocation(location:CLLocation){
     let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2 , regionRadius * 2)
     map.setRegion(coordinateRegion, animated: true)
     }
     
     
     
     func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
     if let loc = userLocation.location {
     centerMapOnLocation(location: loc)
     }
     } */
    
    
    func createAnnotationForLocation(location: CLLocation){
        let barpoint = BarAnnotation(coordinate: location.coordinate)
        map.addAnnotation(barpoint)
    }
    
    
    func getPlaceMarkFromAdress (adress: String){
        CLGeocoder().geocodeAddressString(adress){ (placemarks: [CLPlacemark]?,error: Error?) -> Void in
            if let marks = placemarks, marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(location: loc)
                }
            }
        }
        
    }
    
    
    
    
    
}
