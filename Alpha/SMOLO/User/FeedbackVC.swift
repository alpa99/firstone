//
//  FeedbackVC.swift
//  SMOLO
//
//  Created by Ibrahim Akcam on 26.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FeedbackVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var feedbackTextview: UITextView!
    @IBAction func sendFeedback(_ sender: Any) {
        
        if feedbackTextview.text != nil {
        let user = Auth.auth().currentUser
        var ref: DatabaseReference?
        ref = Database.database().reference()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let DayOne = formatter.date(from: "2018/05/15 12:00")
            let timestamp = Double(NSDate().timeIntervalSince(DayOne!))
            
            ref?.child("Feedback").child((user?.uid)!).childByAutoId().updateChildValues(["Feedback" : feedbackTextview.text!, "timeStamp": timestamp])
            let alertFeedbacksend = UIAlertController(title: "Feedback", message: "Vielen Dank für dein Feedback.", preferredStyle: .alert)
            alertFeedbacksend.addAction(UIAlertAction(title: "Bitteschön :)", style: .default, handler: { (alert) in
                
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alertFeedbacksend, animated: true, completion: nil)

            
        } else {
            let alertFeedbackleer = UIAlertController(title: "Feedback", message: "Bitte schreibe zunächst das Feedback", preferredStyle: .alert)
            alertFeedbackleer.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertFeedbackleer, animated: true, completion: nil)
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackTextview.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Feedback"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
