//
//  ViewController.swift
//  Alpha
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import CoreLocation

var ergebnis = 0
var barnummer = 0

class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    

    // VARS
    var qrbar = [QRBereich]()
    var qrbarname = ""
    var qrbaradresse = ""
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var locationManager = CLLocationManager()
    
    // OUTLETS
    @IBOutlet weak var square: UIImageView!
    
    // FUNC
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){

        
        if metadataObjects != nil && metadataObjects.count != 0 {
     
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
     
                if object.type == AVMetadataObject.ObjectType.qr {
                    self.session.stopRunning()
                    ergebnis = Int(object.stringValue!)!
                    
                    barnummer = ergebnis/1000*1000
     
                    qrbar = [QRBereich]()
                    qrbarname = ""
                    
                    fetchData()
     
                }
            }
        }
        
    }
    
    func fetchData() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("QRBereich").child("\(barnummer)").observe(.value, with: { (snapshot) in
     
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let qrbar = QRBereich(dictionary: dict)     
                self.qrbarname.append(qrbar.Name!)
                self.qrbaradresse.append(qrbar.Adresse!)
     
                print(self.qrbarname)
                
                CLGeocoder().geocodeAddressString(self.qrbaradresse) { (placemarks, error) in
                    guard
                    let placemarks = placemarks,
                    let locationone = placemarks.first?.location
                        else {
                            let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                    return}
                    
                    self.distanceCondition(locat: locationone, placema: placemarks)
            }
            }
        }
            
            , withCancel: nil)
        
    }
    
    func distanceCondition (locat: CLLocation, placema: [CLPlacemark]){

        let distancebar = self.locationManager.location?.distance(from: locat)
        print (distancebar!, " entfernung")
        let distanceint = Int(distancebar!)
        
        if distanceint < 50 {
          
            let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "codescan", sender: self)}))
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
          
            let alert = UIAlertController(title: "Fehler", message: "Du bist nicht in der Nähe von \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codescan"{
            let vc = segue.destination as! ScanDetailVC
            vc.scannummer = barnummer
            
        }
        if segue.identifier == "codescan"{
            let vc = segue.destination as! ScanDetailVC
            vc.scannummer = barnummer
            
        }
    }
    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("ERROR!!")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


