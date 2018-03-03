//
//  GMVC.swift
//  Alpha
//
//  Created by Alper Maraz on 23.12.17.
//  Copyright © 2017 AM. All rights reserved.
//

//import UIKit
//import GoogleMaps
//import CoreLocation
//import Firebase
//
//class GMVC: UIViewController, CLLocationManagerDelegate {
//
//     var testLocation = CLLocationCoordinate2D(latitude: 52.375892, longitude: 9.732010)
//
//    var locationManager = CLLocationManager()
//
//    var BarAdressen = [String]()
//    var BarNamen = [String]()
//
//    var mapView: GMSMapView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
//        GMSServices.provideAPIKey("AIzaSyDLPjONZOJkAWL-7ExV2v1scHSt6iYXf28")
//        let camera =  GMSCameraPosition.camera(withTarget: testLocation, zoom: 15)
//
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    func locationAuthStatus(){
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
//            mapView?.isMyLocationEnabled = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//
//    func fetchAdress() {
//
//        var datref: DatabaseReference!
//        datref = Database.database().reference()
//        datref.child("BarInfo").observe(.childAdded, with: { (snapshot) in
//
//            if let dictionary = snapshot.value as? [String: AnyObject]{
//                let bars = BarInfos(dictionary: dictionary)
//                self.BarAdressen.append(bars.Adresse!)
//                self.BarNamen.append(bars.Name!)
//                for BarIndex in 0 ..< self.BarAdressen.count {
//                    self.getPlaceMarkFromAdress(adress: self.BarAdressen[BarIndex], Titlex: self.BarNamen[BarIndex], Subtitlex: "irgendwas" )
//
//                }
//            }
//
//        }, withCancel: nil)
//    }
//
//
//
////    func getPlaceMarkFromAdress (adress: String, Titlex: String, Subtitlex: String){
////        CLGeocoder().geocodeAddressString(adress){ (placemarks: [CLPlacemark]?,error: Error?) -> Void in
////            if let marks = placemarks, marks.count > 0 {
////                if let loc = marks[0].location {
////                    }
////
////            }
////        }
//
//  //  }
//
//}

