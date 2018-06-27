//
//  EinstellungenVCViewController.swift
//  SMOLO
//
//  Created by Alper Maraz on 07.06.18.
//  Copyright © 2018 AM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin

class EinstellungenVC: UIViewController, UITextFieldDelegate {

    // Outlets
    @IBOutlet var visualEffekt: UIVisualEffectView!
    
    @IBOutlet var passwortView: UIView!
    @IBOutlet weak var passwortTextfield1: UITextField!
    @IBOutlet weak var passwortTextfield2: UITextField!
    @IBOutlet weak var altesPasswortTextfield: UITextField!
    
    @IBOutlet var AccountLoeschen: UIView!
    

    // Actions
    @IBAction func passwortAbbrechen(_ sender: Any) {
        animateOutPasswort()
    }
    
    
    @IBAction func passwortAendern(_ sender: Any) {
        let currentuser = Auth.auth().currentUser
        if currentuser != nil {
    if passwortTextfield1.text == passwortTextfield2.text && passwortTextfield1.text != "" && passwortTextfield2.text != "" {

        if currentuser?.email != nil {
            
            Auth.auth().fetchProviders(forEmail: (currentuser?.email)!) { (loginProvider, error) in
                if error != nil {
                    self.alert(title: "Feler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                    
                } else {
                    
                    if loginProvider != nil && loginProvider![0] == "password"{
                        currentuser?.updatePassword(to: self.passwortTextfield1.text!, completion: { (error) in
                            if error != nil {
                                self.alert(title: "Fehler", message: (error?.localizedDescription)!, actiontitle: "Ok")

                                
                            } else {
                                let email = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email!)!, password: self.altesPasswortTextfield.text!)
                                Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: email, completion: { (result, error) in
                                    if error != nil {
                                        self.animateOutPasswort()
                                        self.alert(title: "Erfolgreich", message: "Dein Passwort wurde aktualisiert. Bitte melde dich erneut an", actiontitle: "Ok")
                                        if Auth.auth().currentUser?.uid != nil {
                                            do
                                            { try Auth.auth().signOut()
                                                
                                            }
                                            catch let error as NSError
                                            { print(error.localizedDescription) }
                                        }
                                        // zurück zum Login ALPER
                                        
                                        self.performSegue(withIdentifier: "unwind", sender: self)
                                        
                                    } else {
                                        self.alert(title: "Feler", message: (error?.localizedDescription)!, actiontitle: "Ok")
                                        
                                    }
                                })

                            }
                        })
                    } else {
                        self.alert(title: "Fehler", message: "Du hast dich bisher über Facebook eingeloggt. Wenn du dein Passwort ändern möchtest, musst du dies auf Faceboom tun.", actiontitle: "Ok")
                    }
                    
                }
            }
        } else {
            alert(title: "Feler", message: "Deine Email-Adresse ist ungültig. Bitte informeire info@madapp.de", actiontitle: "Ok")
            } }
            else {
                alert(title: "Fehler", message: "Das Passwörter stimmen nicht überein", actiontitle: "Ok")
            }
        } else {
            alert(title: "Fehler", message: "Du bist scheinbar kein autorisierter Nutzer. Bitte informiere info@madapp.de", actiontitle: "Ok")
        }
        
    }
    
    
    @IBAction func AccAbbrechen(_ sender: Any) {
        animateOutAcc()
    }
    
    @IBAction func accLoeschen(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        var ref: DatabaseReference?
        ref = Database.database().reference()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let DayOne = formatter.date(from: "2018/05/15 12:00")
        let timestamp = Double(NSDate().timeIntervalSince(DayOne!))
        ref?.child((user?.uid)!).updateChildValues(["Enabled" : false, "timeStamp": timestamp])
        ref?.child("userLoeschen").updateChildValues([(user?.uid)!: "Acc Löschen"])
        
        animateOutAcc()
        alert(title: "Dein Account wird gelöscht", message: "Dein Account wird in einigen Stunden gelöscht. Um dies zu verhindern, kannst du dich erneut einloggen.", actiontitle: "OK")
    }
    
    // Funcs
    
    func animateInPasswort(){
        self.view.addSubview(visualEffekt)
        visualEffekt.center = self.view.center
        visualEffekt.bounds.size = self.view.bounds.size
        self.view.addSubview(passwortView)
        passwortView.center = self.view.center
        passwortView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        passwortView.alpha = 0
        passwortTextfield2.keyboardType = UIKeyboardType.default
        passwortTextfield2.becomeFirstResponder()
        
        passwortTextfield1.keyboardType = UIKeyboardType.default
        passwortTextfield1.becomeFirstResponder()
        altesPasswortTextfield.keyboardType = UIKeyboardType.default
        altesPasswortTextfield.becomeFirstResponder()

        
        UIView.animate(withDuration: 0.2) {
            self.passwortView.alpha = 1
            self.passwortView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutPasswort(){
        
        UIView.animate(withDuration: 0.1, animations: {
            self.passwortTextfield1.resignFirstResponder()
            self.passwortTextfield2.resignFirstResponder()

            self.passwortView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.passwortView.alpha = 0
        }) { (sucess:Bool) in
            self.passwortView.removeFromSuperview()
            self.visualEffekt.removeFromSuperview()
        }
        
    }
    
    func animateInAcc(){
        self.view.addSubview(visualEffekt)
        visualEffekt.center = self.view.center
        visualEffekt.bounds.size = self.view.bounds.size
        self.view.addSubview(AccountLoeschen)
        AccountLoeschen.center = self.view.center
        AccountLoeschen.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        AccountLoeschen.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.AccountLoeschen.alpha = 1
            self.AccountLoeschen.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutAcc(){
        
        UIView.animate(withDuration: 0.1, animations: {
            self.AccountLoeschen.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.AccountLoeschen.alpha = 0
        }) { (sucess:Bool) in
            self.AccountLoeschen.removeFromSuperview()
            self.visualEffekt.removeFromSuperview()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


func alert(title: String, message: String, actiontitle: String) {
    let alertNichtRegistriert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertNichtRegistriert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
    self.present(alertNichtRegistriert, animated: true, completion: nil)
}
    override func viewDidLoad() {
        super.viewDidLoad()
        passwortTextfield1.keyboardAppearance = UIKeyboardAppearance.dark
        passwortTextfield2.keyboardAppearance = UIKeyboardAppearance.dark
        passwortView.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        AccountLoeschen.backgroundColor = UIColor(patternImage: UIImage(named: "hintergrund")!)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Einstellungen"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        if Auth.auth().currentUser?.uid != nil {
            do
            { try Auth.auth().signOut()
                
            }
            catch let error as NSError
            { print(error.localizedDescription) }
        }
    }
    @IBAction func accloeschenTapped(_ sender: Any) {
        animateInAcc()
        
    }
    
    @IBAction func passwortaendernTapped(_ sender: Any) {
        animateInPasswort()
    }
   

}
