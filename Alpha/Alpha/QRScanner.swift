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

var ergebnis = 0
var barnummer = 0

class QRScanner: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    /*var name = ""

    @IBOutlet weak var square: UIImageView!
    
    var qrbar = [QRBereich]()
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
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
   
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        if metadataObjects != nil && metadataObjects.count != 0 {
            
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                
                if object.type == AVMetadataObject.ObjectType.qr {
                    self.session.stopRunning()
                    ergebnis = Int(object.stringValue!)!
                    
                    barnummer = ergebnis/1000*1000
                    
                    qrbar = [QRBar]()
                    qrbarname = ""
                    
                    fetchData()
                    
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codescan"{
            let vc = segue.destination as! ScanDetailVC
            vc.scannummer = barnummer
        }
    }
    
    func fetchData() {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("QRBereich").child("\(barnummer)").observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let qrbar = QRBereich(dictionary: dict)
               // qrbar.setValuesForKeys(dict)
                
                self.name.append(qrbar.Name!)
                
                
                print(self.qrbarname)
                
                let alert = UIAlertController(title: "Erfolgreich", message: "Du bist bei \(self.qrbarname)!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Weiter", style: .default, handler:{ (action) in self.performSegue(withIdentifier: "codescan", sender: self)}))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
            
            , withCancel: nil)
        
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

*/
}

