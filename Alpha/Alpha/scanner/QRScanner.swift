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



class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    
    
    // VARS
    var qrbar = [QRBereich]()
    var qrbarname = ""
    var qrbaradresse = ""
    var KellnerID = ""
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var locationManager = CLLocationManager()
    var ergebnis = 0
    var barnummer = 0
    var tischnummer = 0
    
    var light = 0
    
    // OUTLETS
    @IBOutlet weak var square: UIImageView!
    @IBOutlet weak var flashlight: UIButton!
    @IBAction func flash(_ sender: UIButton) {
        if light == 0 {
            light += 1
            toggleTorch(on: true)
        }else{
            light += -1
            toggleTorch(on: false)
        }
        
    }
    
    //Taschenlampe
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                    try! device.setTorchModeOn(level: 0.3)
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    // FUNC
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        print("lego")
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            let alert = UIAlertController(title: "Fehler", message: "Wir benötigen zuerst deinen        Standort", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Einstellungen", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                print("")
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil
                        )}
                }
            }))
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
            
            
            self.present(alert, animated: true, completion: nil)
            self.session.startRunning()
        }
        else{
            ergebnis = 0
            barnummer = 0
            tischnummer = 0
        
        if metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObject.ObjectType.qr{
                    self.session.stopRunning()
                    if let string = object.stringValue {
                        if let ergebnis = Int(string) {
                            barnummer = ergebnis/1000*1000
                            tischnummer = ergebnis - barnummer
                            qrbar = [QRBereich]()
                            qrbarname = ""
                            fetchData()
                        }else {
                            let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                            qrbarname = ""
                            qrbaradresse = ""
                            ergebnis = 0
                            barnummer = 0
                            tischnummer = 0
                            self.present(alert, animated: true, completion: nil)
                            self.session.startRunning()
                            return}
                        
                    }
                }
            }
            }}
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
                self.KellnerID = qrbar.KellnerID!
                
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
                self.qrbarname = ""
                self.qrbaradresse = ""
                self.ergebnis = 0
                self.barnummer = 0
                self.tischnummer = 0

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
        
        if distanceint < 150 {
            
            let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "scansegue", sender: self)}))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let alert = UIAlertController(title: "Fehler", message: "Du bist nicht in der Nähe von \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
            
            qrbarname = ""
            qrbaradresse = ""
            ergebnis = 0
            barnummer = 0
            tischnummer = 0
            self.present(alert, animated: true, completion: nil)
            
            
            
            
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scansegue"{
            let vc = segue.destination as! PageViewController2
            vc.name = qrbarname
            print(qrbaradresse, "scanner!!!!!!!!")
            vc.adresse = qrbaradresse
            vc.tischnummer = tischnummer
            vc.KellnerID = KellnerID
            
            
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
        self.view.bringSubview(toFront: flashlight)
        session.startRunning()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
        qrbarname = ""
        qrbaradresse = ""
        ergebnis = 0
        barnummer = 0
        tischnummer = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

