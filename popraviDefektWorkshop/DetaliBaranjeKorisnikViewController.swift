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
    var datum = ""
    var opis = ""
    var majstorId = "" //name,email,phone,tip
    var status = ""
    
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

        let query = PFQuery(className: "Baranja")
        query.getObjectInBackground(withId: baranjeId, block: { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let baranje  = object{
                    self.datum = baranje["datum"] as! String
                    self.opis = baranje["opis"] as! String
                    self.majstorId = baranje["majstorId"] as! String
                    self.status = baranje["status"] as! String
                }
            }
        })
        
        datumBaranje.text = datum
        opisDefekt.text = opis
        let queryMajstor = PFUser.query()
        queryMajstor?.getObjectInBackground(withId: majstorId, block: { (object, error) in
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
        
        otkaziKopce.isHidden = true
        cenaDatumPonuda.isHidden = true
        prifatiKopce.isHidden = true
        odbijKopce.isHidden = true
        zakazana_ZavrsenaRabota.isHidden = true //datum
        zavrsenaRabotaSlika.isHidden = true
        if status == "aktivno" {
            datumBaranje.text = datum
            otkaziKopce.isHidden = false
        }else if status == "ponuda"{
            cenaDatumPonuda.isHidden = false
            prifatiKopce.isHidden = false
            odbijKopce.isHidden = false
        }else if status == "zakazano" {
            zakazana_ZavrsenaRabota.isHidden = false
        }else if status == "zavrseno"{
            zakazana_ZavrsenaRabota.isHidden = false
            zavrsenaRabotaSlika.isHidden = false
        }
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
                }
            }
        }
    }
    @IBAction func odbijPressed(_ sender: Any) {
        //baranje["status"] = "odbienaPonuda"
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
