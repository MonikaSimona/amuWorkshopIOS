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
    var lokacijaKorisnik: String  = ""
    var datum: String = ""
    var opis: String = ""
    var majstorId: String = "" //name,email,phone,tip
    var status: String = ""
    var cenaPonuda: String = ""
    var datumPonuda: String = ""
    var datumZavrsuvanje: String = ""
    var lat:Double = 0
    var long:Double = 0
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

       getBaranje()
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
        queryRabota.getFirstObjectInBackground { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let rabota = object {
                    rabota["status"] = "zakazano"
                    rabota.saveInBackground()
                }
            }
        }
    }
    
    @IBAction func odbijPressed(_ sender: Any) {
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
        let queryRabota = PFQuery(className: "Rabota")
        queryRabota.whereKey("baranjeId", equalTo: baranjeId)
        queryRabota.getFirstObjectInBackground { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let rabota = object {
                    rabota.deleteInBackground()
                }
            }
        }
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
                
                let queryMajstor = PFUser.query()
                queryMajstor?.getObjectInBackground(withId: self.majstorId, block: { (object, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }else{
                        if let majstor = object as? PFUser {
                            self.tipMajstor.text = majstor["type"] as? String
                            self.imePrezimeMajstor.text = majstor["name"] as? String
                            self.emailMajstor.text = majstor.username?.components(separatedBy: "_")[0]
                            self.telefonMajstor.text = majstor["phone"] as? String
                            self.otkaziKopce.isHidden = true
                            self.cenaDatumPonuda.isHidden = true
                            self.prifatiKopce.isHidden = true
                            self.odbijKopce.isHidden = true
                            self.zakazana_ZavrsenaRabota.isHidden = true //datum
                            self.zavrsenaRabotaSlika.isHidden = true
                            if self.status == "aktivno" {
                                self.statusBaranje.text = "Status: \(self.status)"
                                self.datumBaranje.text = self.datum
                                self.otkaziKopce.isHidden = false
                            }else if self.status == "ponuda"{
                                self.statusBaranje.text = "Status: \(self.status)"
                                self.cenaDatumPonuda.isHidden = false
                                self.cenaDatumPonuda.text = "Cena: \(self.cenaPonuda) , \(self.datumPonuda)"
                                self.prifatiKopce.isHidden = false
                                self.odbijKopce.isHidden = false
                            }else if self.status == "zakazano" {
                                self.statusBaranje.text = "Status: \(self.status)"
                                self.zakazana_ZavrsenaRabota.isHidden = false
                                self.zakazana_ZavrsenaRabota.text = "Zakazana rabota na \(self.datumPonuda)"
                            }else if self.status == "zavrseno"{
                                self.statusBaranje.text = "Status: \(self.status)"
                                self.zakazana_ZavrsenaRabota.isHidden = false
                                self.zavrsenaRabotaSlika.isHidden = false
                                self.zakazana_ZavrsenaRabota.text = "Zavrsena rabota na \(self.datumZavrsuvanje)"
                            }
                            
                            let queryRabota = PFQuery(className: "Rabota")
                            queryRabota.whereKey("baranjeId", equalTo: self.baranjeId)
                            queryRabota.getFirstObjectInBackground(block: { (object, error) in
                                if let err =  error {
                                    print(err.localizedDescription)
                                }else if let rabota = object{
                                    if let cena = rabota["cena"] as? String{
                                        if let datumPonuda = rabota["datumPonuda"] as? String{
                                            if let datumZavr = rabota["datumZavrsuvanje"] as? String{
                                                self.cenaPonuda = cena
                                                self.datumPonuda = datumPonuda
                                                self.datumZavrsuvanje = datumZavr
                                            }
                                        }
                                    }
                                    
                                    self.datumBaranje.text = "Pobarano na: \(self.datum)"
                                    self.opisDefekt.text = "Opis: \(self.opis)"
                                    
                                }else{
                                    print("nema rezultat")
                                }
                            })
                        }
                    }
                })
            }
        }
    }
}


