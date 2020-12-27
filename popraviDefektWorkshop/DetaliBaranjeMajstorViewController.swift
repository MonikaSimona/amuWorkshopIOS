//
//  DetaliBaranjeMajstorViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import MapKit

class DetaliBaranjeMajstorViewController: UIViewController {

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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func konBaranja(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func ispratiPonudaPressed(_ sender: Any) {
        //baranje["status"] = "ponuda"
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
