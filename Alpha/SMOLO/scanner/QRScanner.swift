//
//  ViewController.swift
//  SMOLO
//
//  Created by Alper Maraz on 19.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import CoreLocation
import GoogleMobileAds



class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate {
    
    
    // VARS
    var qrbar = [QRBereich]()
    var qrbarname = ""
    var qrbaradresse = ""
    var barname = ""
    var KellnerID = ""
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    var locationManager = CLLocationManager()
    var ergebnis = 0
    var barnummer = 0
    var tischnummer = 0
    var AnzahlQRCodes = 0
    
    var light = 0
    
    // OUTLETS
    
    @IBOutlet weak var topbanner: GADBannerView!
    
    @IBOutlet weak var square: UIImageView!
    @IBOutlet weak var flashlight: UIButton!
    @IBAction func flash(_ sender: UIButton) {
        myButtonTapped()
        if light == 0 {
            light += 1
            toggleTorch(on: true)
        }else{
            light += -1
            toggleTorch(on: false)
        }
        
    }
    func myButtonTapped(){
        if flashlight.isSelected == true {
            flashlight.isSelected = false
            flashlight.setImage(#imageLiteral(resourceName: "flashlight-i"), for: UIControl.State.normal)
        }else {
            flashlight.isSelected = true
            flashlight.setImage(#imageLiteral(resourceName: "flashlight"), for: UIControl.State.normal)
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
            alert.addAction(UIAlertAction(title: "Einstellungen", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) in
                print("")
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil
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
                            barname = ""
                            fetchData()
                        }else {
                            let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                            qrbarname = ""
                            barname = ""
                            qrbaradresse = ""
                            ergebnis = 0
                            barnummer = 0
                            tischnummer = 0
                            self.present(alert, animated: true, completion: nil)
                            self.session.startRunning()
                            return}
                        
                    } else {
                        print("ok")
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
                self.barname.append(qrbar.DispName!)
                self.KellnerID = qrbar.KellnerID!
                
                
                
                if self.tischnummer <= qrbar.AnzahlQRCodes! {
                let locationBar = CLLocation(latitude: qrbar.Latitude!, longitude: qrbar.Longitude!)
                    
                self.distanceCondition(locat: locationBar)
//                CLGeocoder().geocodeAddressString(self.qrbaradresse, completionHandler: { (placemarks, error) -> Void in
//
//                    if let placemark = placemarks?[0] {
//                        let location = placemark.location
//
//                        self.distanceCondition(locat: location!)}
//                })
                } else {
                    let alert = UIAlertController(title: "Fehler", message: "Dies ist kein gültiger Smolo-Code", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in
                   self.session.startRunning()}))
                    self.present(alert, animated: true, completion: nil)

                    return
                }
            }else {
                let alert = UIAlertController(title: "Fehler", message: "Dies ist kein Smolo-Code", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
                self.qrbarname = ""
                self.barname = ""
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
        let distanceint = Int(distancebar!)
        
        if distanceint < 9999999999 {
            
            let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.barname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "scansegue", sender: self)}))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let alert = UIAlertController(title: "Fehler", message: "Du bist nicht in der Nähe von \(self.qrbarname)!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler:{ (action) in self.session.startRunning()}))
            
            qrbarname = ""
            barname = ""
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
           // löschen
            vc.name = "Huqa"
            vc.barname = "Huqa"
            vc.adresse = "keine Adresse"
            vc.tischnummer = 10
            vc.KellnerID = "NTWigzmLBMPHf5qFeVbNgPjXGUu1"
            
            // kommentartion entfernen
//            vc.name = qrbarname
//            vc.barname = barname
//            vc.adresse = qrbaradresse
//            vc.tischnummer = tischnummer
//            vc.KellnerID = KellnerID
        }
    }
    // OTHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ca-app-pub-9477880000646212/8826370724
        self.topbanner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        self.topbanner.rootViewController = self
        self.topbanner.load(GADRequest())
        
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
        self.view.bringSubviewToFront(square)
        self.view.bringSubviewToFront(flashlight)
        session.startRunning()
        
        performSegue(withIdentifier: "scansegue", sender: self)
        //zum löschen perform anpassen und zeile diese hier drüber löshcen
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        session.startRunning()
        
        qrbarname = ""
        qrbaradresse = ""
        KellnerID = ""
        ergebnis = 0
        barnummer = 0
        tischnummer = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
