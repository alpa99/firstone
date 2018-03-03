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
    var distancebar = 0.0
    
    // OUTLETS
    @IBOutlet weak var square: UIImageView!
    
    // FUNC
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        
        if metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObject.ObjectType.qr{
                    self.session.stopRunning()
                    if let string = object.stringValue {
                        if let ergebnis = Int(string) {
                            barnummer = ergebnis/1000*1000
                            qrbar = [QRBereich]()
                            qrbarname = ""
                            fetchData()
                        }else {
                            let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                            
                            self.present(alert, animated: true, completion: nil)
                            self.session.startRunning()
                            return}
                        
                    }
                }
            }
        }
    }
    
    func fetchData() {
        print("fetchDATA")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("QRBereich").child("\(barnummer)").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                let qrbar = QRBereich(dictionary: dict)
                self.qrbarname.append(qrbar.Name!)
        
                self.qrbaradresse.append(qrbar.Adresse!)
                
                print(self.qrbarname)
                print(self.qrbaradresse, "ADrESs!!")
                CLGeocoder().geocodeAddressString(self.qrbaradresse, completionHandler: { (placemarks, error) -> Void in
                    
                    if let placemark = placemarks?[0] {
                        let location = placemark.location
                        self.distanceCondition(locat: location!)}
                })
            }else {
                    let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                    
                    self.present(alert, animated: true, completion: nil)
                    self.session.startRunning()
                    return}
            }
        
            
            , withCancel: nil)
        
    }
    
    func distanceCondition (locat: CLLocation){
        
        print(locat, "LOCAT")
        let distancebar = self.locationManager.location?.distance(from: locat)
        print (distancebar!, " entfernung")
        let distanceint = Int(distancebar!)
        
        if distanceint < 50 {
            
            let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "scansegue", sender: self)}))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let alert = UIAlertController(title: "Fehler", message: "Du bist nicht in der Nähe von \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scansegue"{
            let vc = segue.destination as! PageViewController2
            vc.name = qrbarname
            print(qrbaradresse, "scanner!!!!!!!!")
            vc.adresse = qrbaradresse
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
