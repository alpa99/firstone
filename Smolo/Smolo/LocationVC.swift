//
//  LocationVC.swift
//  Smolo
//
//  Created by Alper Maraz on 04.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Pulley


class LocationVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    
    let cellID2 = "cellID2"
    
    let regionRadius: CLLocationDistance = 500
    
    let locationManager = CLLocationManager()
    
    
    
    var BarAdressen = [String]()
    var BarNamen = [String]()
    
    
    var barPointSubtitle = "shishabar sonst was"
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        
      
        fetchAdress()
        // fetchBars2()
    }
    
    
    func fetchAdress() {
        
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Barliste").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bars = BarInfos(dictionary: dictionary)
                bars.setValuesForKeys(dictionary)
                //print(adresse.Adresse!)
                self.BarAdressen.append(bars.Adresse!)
                self.BarNamen.append(bars.Name!)
                //print(self.BarAdressen)
                for BarIndex in 0 ..< self.BarAdressen.count {
                    self.getPlaceMarkFromAdress(adress: self.BarAdressen[BarIndex], Titlex: self.BarNamen[BarIndex])
                    // zeigt immer namen der letzten bar
                    
                }
            }
            
        }, withCancel: nil)
        
        
        
        
        
    }
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        let annotation = view.annotation
    //        let index = (self.mapView.annotations as NSArray).index(of: annotation!)
    //        print ("Annotation Index = \(index)")
    //
    //    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        locationAuthStatus()
    }
    
    
    
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
    
    
    
    //
    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
    //        if let loc = userLocation.location {
    //     centerMapOnLocation(location: loc)
    //        }
    //
    //   }
    
    func createAnnotationForLocation(location: CLLocation, Title: String){
        
        
        let barpoint = BarAnnotation(coordinate: location.coordinate, title: Title, subtitle: barPointSubtitle)
        map.addAnnotation(barpoint)
    }
    
    
    func getPlaceMarkFromAdress (adress: String, Titlex: String){
        CLGeocoder().geocodeAddressString(adress){ (placemarks: [CLPlacemark]?,error: Error?) -> Void in
            if let marks = placemarks, marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(location: loc, Title: Titlex)}
                
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let annotation = self.map.selectedAnnotations[0] as MKAnnotation!
            //Perform a segue here to navigate to another viewcontroller
            print(((annotation?.title)!)!)
            
            let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarDetailVC") as! BarDetailVC
            detvc.barname = ((annotation?.title)!)!
            
            (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
            
            
            (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
            
        }
    }
    
}
    

