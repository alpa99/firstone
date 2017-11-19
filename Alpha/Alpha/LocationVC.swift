//
//  LocationVC.swift
//  Alpha
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Pulley
import CoreLocation // BRAUCHEN WIR DAS
import AddressBookUI // BRAUCHEN WIR DAS

class LocationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    // VARS
    let cellID2 = "cellID2" // BRAUCHEN WIR DAS?
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    var testLocation = CLLocation(latitude: 52.375892, longitude: 9.732010)
    var startLocation: CLLocation!
    var barPointSubtitle = [String]()
    var BarAdressen = [String]()
    var BarNamen = [String]()
    
    // OUTLETS
    
    @IBOutlet weak var map: MKMapView!

    // FUNTIONS FIREBASE

    func fetchAdress() {

        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("BarInfo").observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject]{
                let bars = BarInfos(dictionary: dictionary)
                self.BarAdressen.append(bars.Adresse!)
                self.BarNamen.append(bars.Name!)
                for BarIndex in 0 ..< self.BarAdressen.count {
                    self.getPlaceMarkFromAdress(adress: self.BarAdressen[BarIndex], Titlex: self.BarNamen[BarIndex], Subtitlex: "irgendwas" )

                }
            }

        }, withCancel: nil)
    }

    // FUNCS LOCATION AND ANNOTATION

    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    

    func centerMapOnLocation(){
        
// let coordinateRegion = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, regionRadius, regionRadius)
   let coordinateRegion = MKCoordinateRegionMakeWithDistance(testLocation.coordinate, 2*regionRadius, 2*regionRadius)

        map.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
        

    }

    func createAnnotationForLocation(location: CLLocation, Title: String, Subtitle: String){

        
        let barpoint = BarAnnotation(coordinate: location.coordinate, title: Title, subtitle: Subtitle)
        map.addAnnotation(barpoint)
        
    }
    
    
    func getPlaceMarkFromAdress (adress: String, Titlex: String, Subtitlex: String){
        CLGeocoder().geocodeAddressString(adress){ (placemarks: [CLPlacemark]?,error: Error?) -> Void in
            if let marks = placemarks, marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(location: loc, Title: Titlex, Subtitle: "\(Subtitlex) km")}
                
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is MKUserLocation {return nil}
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
           // pinView!.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView!.annotation = annotation
        }
        
      //  pinView!.image = UIImage(named: "pin.png")
        let pinImage = UIImage(named: "pin.png")
        let size = CGSize(width: 35, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x:0, y:-5, width:size.width, height:size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        pinView!.layer.anchorPoint = CGPoint(x: 0.6, y: 0.8)
        pinView!.image = resizedImage
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let annotation = self.map.selectedAnnotations[0] as MKAnnotation!
            //Perform a segue here to navigate to another viewcontroller
            
            let detvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BestellungVC") as! BestellungVC
            detvc.barname = ((annotation?.title)!)!
            
            (parent as? PulleyViewController)?.setDrawerPosition(position: PulleyPosition(rawValue: 2)!)
            
            
            (parent as? PulleyViewController)?.setDrawerContentViewController(controller: detvc, animated: true)
            
        }
 }
    
    // OTHERS
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        fetchAdress()
        centerMapOnLocation()
    }
    
    override func viewDidAppear(_ animated: Bool){
        locationAuthStatus()
    }
    
    
    
}
