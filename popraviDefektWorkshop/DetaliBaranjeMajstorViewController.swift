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
                    self.datumBaranje.text = baranje["datum"] as? String
                    self.opis = baranje["opisDefekt"] as! String
                    self.opisDefekt.text = baranje["opisDefekt"] as? String
                    self.korisnikId = baranje["korisnikId"] as! String
                }
            
        }
        datumBaranje.text = datum
        opisDefekt.text = opis
        
        let queryMajstor = PFUser.query()
        queryMajstor?.getObjectInBackground(withId: korisnikId, block: { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let korisnik = object as? PFUser {
                    self.imePrezimeKorisnik.text = korisnik["name"] as? String
                    self.emailKorsnik.text = korisnik.email
                    self.telefonKorisnik.text = korisnik["phone"] as? String
                }
            }
        })
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ispratiPonudaPressed(_ sender: Any) {
        let queryBaranje = PFQuery(className: "Baranje")
        queryBaranje.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else if let baranje  =  object {
                 baranje["status"] = "ponuda"
                baranje.saveInBackground()
                    print("ispratena ponuda")
                }
            
        }
        let rabota = PFObject(className: "Rabota")
        rabota["majstorId"] = PFUser.current()?.objectId
        rabota["korisnikId"] = korisnikId
        rabota["baranjeId"] = baranjeId
        rabota["datumPonuda"] = datumPonuda.text
        rabota["cena"] = cenaPonuda.text
        rabota["status"] = "ponuda"
        rabota.saveInBackground()
        
        cenaPonuda.text = ""
        datumPonuda.text = ""
    }
    @IBAction func odbijBaranjePressed(_ sender: Any) {
        //baranje["status"] == "odbienoBaranje"
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
