//
//  DetaliBaranjeMajstorViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DetaliBaranjeMajstorViewController: UIViewController {
    var baranjeId: String = ""
    var korisnikId = ""
    var datum = ""
    var opis = ""
    @IBOutlet weak var datumBaranje: UILabel!
    @IBOutlet weak var opisDefekt: UILabel!
    @IBOutlet weak var imePrezimeKorisnik: UILabel!
    @IBOutlet weak var emailKorsnik: UILabel!
    @IBOutlet weak var telefonKorisnik: UILabel!
    @IBOutlet weak var defektMapa: MKMapView!
    @IBOutlet weak var cenaPonuda: UITextField!
    @IBOutlet weak var datumPonuda: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("baranjeID \(baranjeId)")
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            } else if let baranje = object{
                    self.datum = baranje["datum"] as! String
                self.datumBaranje.text = "Pobarano na: \(String(describing: baranje["datum"] as? String))"
                    self.opis = baranje["opisDefekt"] as! String
                self.opisDefekt.text = " Opis: \(String(describing: baranje["opisDefekt"] as? String))"
                    self.korisnikId = baranje["korisnikId"] as! String
                
                self.datumBaranje.text = self.datum
                self.opisDefekt.text = self.opis
                
                let queryMajstor = PFUser.query()
                queryMajstor?.getObjectInBackground(withId: self.korisnikId, block: { (object, error) in
                    if let err = error {
                        print(err.localizedDescription)
                    }else{
                        if let korisnik = object as? PFUser {
                            self.imePrezimeKorisnik.text = "Pobaral: \(String(describing: korisnik["name"] as? String))" 
                            self.emailKorsnik.text = korisnik.email
                            self.telefonKorisnik.text = korisnik["phone"] as? String
                        }
                    }
                })
                }
            
        }
//        datumBaranje.text = datum
//        opisDefekt.text = opis
//
//        let queryMajstor = PFUser.query()
//        queryMajstor?.getObjectInBackground(withId: korisnikId, block: { (object, error) in
//            if let err = error {
//                print(err.localizedDescription)
//            }else{
//                if let korisnik = object as? PFUser {
//                    self.imePrezimeKorisnik.text = korisnik["name"] as? String
//                    self.emailKorsnik.text = korisnik.email
//                    self.telefonKorisnik.text = korisnik["phone"] as? String
//                }
//            }
//        })
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ispratiPonudaPressed(_ sender: Any) {
        let queryBaranje = PFQuery(className: "Baranje")
        queryBaranje.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else if let baranje  =  object {
                 baranje["status"] = "ponuda"
                baranje["datumPonuda"] = self.datumPonuda.text
                baranje.saveInBackground()
                    print("ispratena ponuda")
                let rabota = PFQuery(className: "Rabota")
                rabota.whereKey("baranjeId", equalTo: self.baranjeId)
                rabota.getFirstObjectInBackground(block: { (object, err) in
                    if let error = err {
                        print(error.localizedDescription)
                    }else if let rabota = object{
                        rabota["majstorId"] = PFUser.current()?.objectId
                                    rabota["korisnikId"] = self.korisnikId
                                    rabota["baranjeId"] = self.baranjeId
                                    rabota["datumPonuda"] = self.datumPonuda.text
                                    rabota["cena"] = self.cenaPonuda.text
                                    rabota["status"] = "ponuda"
                        rabota.saveInBackground()
                    }
                })

                
                self.cenaPonuda.text = ""
                self.datumPonuda.text = ""
                }
            
        }
        
    }
    @IBAction func odbijBaranjePressed(_ sender: Any) {
        let query = PFQuery(className: "Baranje")
        query.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err =  error{
                print(err.localizedDescription)
            }else if let baranje = object  {
                baranje.deleteInBackground()
            }
            let rabota = PFQuery(className: "Rabota")
            rabota.whereKey("baranjeId", equalTo: self.baranjeId)
            rabota.getFirstObjectInBackground(block: { (object, error) in
                if let err = error {
                    print(err.localizedDescription)
                }else if let rabota = object {
                    rabota.deleteInBackground()
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
