//
//  QRController.swift
//  shisha
//
//  Created by Alper Maraz on 14.08.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import Pulley

var ergebnis = 0
var barnummer = 0



class QRController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()

    @IBOutlet weak var square: UIImageView!
    
    var qrbar = [QRBar]()
    var qrbarname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        }
        catch{
            print("ERROR!!")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codescan"{
        let vc = segue.destination as! ScanDetailVC
            vc.scannummer = barnummer
        }
    }
    
    func fetchNumber(){
        
        print (barnummer+12232)
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("QRBereich").child("\(barnummer)").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
//                for a in (dict.keys){
//                    print(a)
//                }
                let qrbar = QRBar(dictionary: dict)
                qrbar.setValuesForKeys(dict)
                
                self.qrbarname.append(qrbar.Name!)
                
               print(self.qrbarname)
                
                let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.qrbarname)!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "codescan", sender: self)}))
                
                self.present(alert, animated: true, completion: nil)

                
            }
        }
            
            , withCancel: nil)
        
        
        

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObjectTypeQRCode {
                   self.session.stopRunning()
                 ergebnis = Int(object.stringValue)!
                    
                 barnummer = ergebnis/1000*1000
                    
                    qrbar = [QRBar]()
                    qrbarname = ""
                  
                fetchNumber()

            
               //print(barnummer)
                    

                    
//                    if qrbarnamen.count != 0 {
//                        print("gibt")
//                    }else {
//                        print ("gibtnicht")
//                    }
//                
//                let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(qrbarnamen)", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "codescan", sender: self)}))
//                
//                self.present(alert, animated: true, completion: nil)
//                    
                
                    //session.stopRunning()
                    
              //  performSegue(withIdentifier: "codescan", sender: self)
                    
                    
                                    }
            }
        }
        
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
