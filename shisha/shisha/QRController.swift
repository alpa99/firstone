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

var ergebnis = 0
var barnummer = 0

var qrbarname = [QRBar]()
var qrbarnamen = [String]()

class QRController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()

    @IBOutlet weak var square: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         qrbarname = [QRBar]()
         qrbarnamen = [String]()

        
        
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
    
    func fetchNumber(){
        
        print (barnummer+12)
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("QRBereich").child("1000").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let qrbarname = QRBar(dictionary: dictionary)
                qrbarnamen.append(qrbarname.Name!)
                
                print(qrbarnamen)
                
                

                
            }
        }
            
            , withCancel: nil)
        
        let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(qrbarnamen)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "codescan", sender: self)}))
        
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObjectTypeQRCode {
                   
                 ergebnis = Int(object.stringValue)!
                    
                 barnummer = ergebnis/1000*1000
                  
                fetchNumber()

            
               print(barnummer)
                    

                    
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