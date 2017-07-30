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

class LocationVC: UIViewController,/* UITableViewDelegate, UITableViewDataSource,*/ MKMapViewDelegate {
    
   
    @IBOutlet weak var map: MKMapView!
   // @IBOutlet weak var mapTV: UITableView!
    
    let cellID2 = "cellID2"
    
    var bars2 = [BarInfos] ()
    
    
    let regionRadius: CLLocationDistance = 500
    
    let locationManager = CLLocationManager()
    
    // var adresses = ["Goseriede 12, 30159 Hannover, Deutschland"]
    
    var adresse = [BarInfos]()
    var BarAdressen = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
    /*    mapTV.delegate = self
        mapTV.dataSource = self
        
        mapTV.register(barCell2.self, forCellReuseIdentifier: cellID2)
 */
        fetchAdress()
       // fetchBars2()
        
        
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
    
 /*   func fetchBars2 () {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Barliste").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bar2 = BarInfos(dictionary: dictionary)
                bar2.setValuesForKeys(dictionary)
                print(bar2.Name!, bar2.Stadt!)
                self.bars2.append(bar2)
                
                DispatchQueue.main.async(execute: {
                    self.mapTV.reloadData()
                } )
            }
            
            //  print(snapshot)
            
            
            
            
        }, withCancel: nil)
        
        
    }

    
    */
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        locationAuthStatus()
    }
    
  /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: cellID2, for: indexPath)
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        let bar2 = bars2[indexPath.row]
        
        
        cell2.textLabel?.text = bar2.Name
        cell2.detailTextLabel?.text = bar2.Stadt
        
        return cell2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bars2.count
    }
    */
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
      func centerMapOnLocation(location:CLLocation){
     let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2 , regionRadius * 2)
     map.setRegion(coordinateRegion, animated: true)

    }
     
     
     
     func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        if let loc = userLocation.location {
     centerMapOnLocation(location: loc)
        }
    
     }
    
    
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

class barCell2: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

