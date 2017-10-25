//
//  BestellungVC.swift
//  Alpha
//
//  Created by Ibrahim Akcam on 22.10.17.
//  Copyright © 2017 AM. All rights reserved.
//

import UIKit
import Firebase

class BestellungVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {

    @IBOutlet weak var bestellungTableView: UITableView!
    
    var genres = [String]()
    var shishas = [String]()
    var genreDetail = [String]()

    //var getränke = [String]()
    
    
    var sections = [ExpandTVSection]()
    

    
    func fetchSpeisekarte(){
        var z = [Int: String]()
        var datref: DatabaseReference!
        datref = Database.database().reference()
        datref.child("Speisekarten").observe(.childAdded, with: { (snapshotx) in
            

            
        datref.child("Speisekarten").child("SpeisekarteDeluxxe").observe(.childAdded, with: { (snapshot) in
            
            z.updateValue(snapshot.key, forKey: Int(snapshot.childrenCount))
            if z.count == snapshotx.childrenCount {
            for (number, genre) in z {
            
            datref.child("Speisekarten").child("SpeisekarteDeluxxe").child("\(genre)").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    let speisekarte = SpeisekarteInfos(dictionary: dictionary)
                    self.genreDetail.append(speisekarte.Name!)
                    print(self.genreDetail, "das  ist GENREDETAIL")
//                    print(self.getränke.count, "das ist getränke.count")
//                    print(self.getränke, "self.getränke")
                    print(self.genreDetail.count, "DAS ist genredetai.count")
                    if self.genreDetail.count == number {
                        self.setSections(genre: "\(genre) ", movies: self.genreDetail)
                        self.genreDetail = [String]()
                    }
                    
                }
            }, withCancel: nil)

                }
                
            }
            
        }, withCancel: nil)
    }, withCancel: nil)

        

    }
    
    func setSections(genre: String, movies: [String]){
        
        self.sections.append(ExpandTVSection(genre: genre, movies: movies, expanded: false))
        
        self.bestellungTableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchSpeisekarte()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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



