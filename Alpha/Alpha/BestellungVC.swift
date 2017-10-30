//
//  BestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase
import Pulley

class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate, PulleyDrawerViewControllerDelegate {

    @IBOutlet weak var label: UILabel!
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 102.0
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 340.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all
    }
    

    
    var barname = ""
    
    var bars = [BarInfos]()
    var adresse = String ()
    
    
    
    @IBAction func Back(_ sender: Any) {
        
        let tableVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerVC") as UIViewController
        (parent as? PulleyViewController)?.setDrawerContentViewController(controller: tableVC, animated: true)
    }
    
    
    
    @IBOutlet weak var bestellungTableView: UITableView!
    
    var genres = [String]()
    var shishas = [String]()
    var genreDetail = [String]()

    //var getränke = [String]()
    
    
    var sections = [ExpandTVSection]()
    

    
    func fetchSpeisekarte(){
        var z = [String: Int]()
        var datref: DatabaseReference!
        datref = Database.database().reference()
//        datref.child("Speisekarten").observe(.childAdded, with: { (snapshotx) in

//        datref.child("Speisekarten").child("\(self.barname)").observe(.childAdded, with: { (snapshot) in

//            z.updateValue(Int(snapshot.childrenCount), forKey: snapshot.key)
//            print(z, "AFDSFSDF")
//
//            for (genre, number) in z {
            
            datref.child("Speisekarten").child("\(self.barname)").child("Shishas").observe(.childAdded, with: { (snapshot) in
                self.label.text = self.barname

                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let speisekarte = SpeisekarteInfos(dictionary: dictionary)
                    self.genreDetail.append(speisekarte.Name!)
                }
                self.setSections(genre: "Shishas", movies: self.genreDetail)
                print(self.genreDetail)

            }, withCancel: nil)
        

    }

    
    
    func setSections(genre: String, movies: [String]){
        self.sections.append(ExpandTVSection(genre: genre, movies: movies, expanded: false))
        self.bestellungTableView.reloadData()

    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
fetchSpeisekarte()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
            return 44
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self as ExpandableHeaderViewDelegate)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bestellungTableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].movies[indexPath.row]
        return cell
    }
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        bestellungTableView.beginUpdates()
        for i in 0..<sections[section].movies.count{
            bestellungTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        bestellungTableView.endUpdates()
        
    }
    
}



