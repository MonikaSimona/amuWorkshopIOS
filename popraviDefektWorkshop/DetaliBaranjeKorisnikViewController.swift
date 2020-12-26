//
//  DetaliBaranjeKorisnikViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit

class DetaliBaranjeKorisnikViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func otkaziPressed(_ sender: Any) {
        //izbrisi baranje od baza
    }
    
    @IBAction func prifatiPressed(_ sender: Any) {
        //vo bazata vo klasata Baranje da ima pole status
        //baranje["status"] = "prifatenaPonuda"
    }
    @IBAction func odbijPressed(_ sender: Any) {
        //baranje["status"] = "odbienaPonuda"
    }
    @IBAction func konBaranja(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
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
