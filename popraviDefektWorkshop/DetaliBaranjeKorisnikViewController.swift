//
//  DetaliBaranjeKorisnikViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse

class DetaliBaranjeKorisnikViewController: UIViewController {
    
    var baranjeId: String = ""
    var datum: String = ""
    var opis: String = ""
    var majstorId: String = "" //name,email,phone,tip
    var status: String = ""

    
    @IBOutlet weak var datumBaranje: UILabel!
    @IBOutlet weak var tipMajstor: UILabel!
    @IBOutlet weak var opisDefekt: UILabel!
    @IBOutlet weak var imePrezimeMajstor: UILabel!
    @IBOutlet weak var emailMajstor: UILabel!
    @IBOutlet weak var telefonMajstor: UILabel!
    @IBOutlet weak var statusBaranje: UILabel!
    @IBOutlet weak var otkaziKopce: UIButton!
    @IBOutlet weak var cenaDatumPonuda: UILabel!
    @IBOutlet weak var prifatiKopce: UIButton!
    @IBOutlet weak var odbijKopce: UIButton!
    @IBOutlet weak var zakazana_ZavrsenaRabota: UILabel!
    @IBOutlet weak var zavrsenaRabotaSlika: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("baranje id \(baranjeId)")
       getBaranje()
      
        print("majstor id \(majstorId)")
        
//        datumBaranje.text = datum
//        opisDefekt.text = opis
//        let queryMajstor = PFUser.query()
//        queryMajstor?.getObjectInBackground(withId: majstorId, block: { (object, error) in
//            if let err = error {
//                print(err.localizedDescription)
//            }else{
//                if let majstor = object as? PFUser {
//                    self.tipMajstor.text = majstor["type"] as? String
//                    self.imePrezimeMajstor.text = majstor["name"] as? String
//                    self.emailMajstor.text = majstor.email
//                    self.telefonMajstor.text = majstor["phone"] as? String
//                }
//            }
//        })
//
//        otkaziKopce.isHidden = true
//        cenaDatumPonuda.isHidden = true
//        prifatiKopce.isHidden = true
//        odbijKopce.isHidden = true
//        zakazana_ZavrsenaRabota.isHidden = true //datum
//        zavrsenaRabotaSlika.isHidden = true
//        if status == "aktivno" {
//            datumBaranje.text = datum
//            otkaziKopce.isHidden = false
//        }else if status == "ponuda"{
//            cenaDatumPonuda.isHidden = false
//            prifatiKopce.isHidden = false
//            odbijKopce.isHidden = false
//        }else if status == "zakazano" {
//            zakazana_ZavrsenaRabota.isHidden = false
//        }else if status == "zavrseno"{
//            zakazana_ZavrsenaRabota.isHidden = false
//            zavrsenaRabotaSlika.isHidden = false
//        }
    }
    
    @IBAction func otkaziPressed(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje.deleteInBackground()
                }
            }
        }
    }
    
    @IBAction func prifatiPressed(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje["status"] = "zakazano"
                    baranje.saveInBackground()
                }
            }
        }
        let queryRabota = PFQuery(className: "Rabota")
        queryRabota.whereKey("baranjeId", equalTo: baranjeId)
        
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje = object {
                    baranje["status"] = "zakazano"
                    baranje.saveInBackground()
                }
            }
        }
    }
    @IBAction func odbijPressed(_ sender: Any) {
        //baranje["status"] = "odbienaPonuda"
    }
    func getBaranje () {
        let query = PFQuery(className: "Baranje")
        query.whereKey("objectId", equalTo: baranjeId)
        
        query.getFirstObjectInBackground { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else if let baranje = object{
                self.datum = (baranje["datum"] as? String)!
                print(baranje["datum"] as! String)
                self.opis = (baranje["opisDefekt"] as? String)!
                print(baranje["opisDefekt"] as! String)
                self.majstorId = baranje["majstorId"] as! String
                print(baranje["majstorId"] as! String)
                self.status = baranje["status"] as! String
                print(baranje["status"] as! String)
                
                
                self.datumBaranje.text = self.datum
                self.opisDefekt.text = self.opis
                let queryMajstor = PFUser.query()
                queryMajstor?.getObjectInBackground(withId: self.majstorId, block: { (object, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }else{
                        if let majstor = object as? PFUser {
                            self.tipMajstor.text = majstor["type"] as? String
                            self.imePrezimeMajstor.text = majstor["name"] as? String
                            self.emailMajstor.text = majstor.email
                            self.telefonMajstor.text = majstor["phone"] as? String
                        }
                    }
                })
                
                self.otkaziKopce.isHidden = true
                self.cenaDatumPonuda.isHidden = true
                self.prifatiKopce.isHidden = true
                self.odbijKopce.isHidden = true
                self.zakazana_ZavrsenaRabota.isHidden = true //datum
                self.zavrsenaRabotaSlika.isHidden = true
                if self.status == "aktivno" {
                    self.statusBaranje.text = self.status
                    self.datumBaranje.text = self.datum
                    self.otkaziKopce.isHidden = false
                }else if self.status == "ponuda"{
                    self.statusBaranje.text = self.status
                    self.cenaDatumPonuda.isHidden = false
                    self.prifatiKopce.isHidden = false
                    self.odbijKopce.isHidden = false
                }else if self.status == "zakazano" {
                    self.zakazana_ZavrsenaRabota.isHidden = false
                }else if self.status == "zavrseno"{
                    self.statusBaranje.text = self.status
                    self.zakazana_ZavrsenaRabota.isHidden = false
                    self.zavrsenaRabotaSlika.isHidden = false
                }
                

            }else{
                print("nema rezultat")
            }
        }
    }
   
  

}
