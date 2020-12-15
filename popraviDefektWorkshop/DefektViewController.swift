//
//  DefektViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/13/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import MapKit

class DefektViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var opisZaDefekt: UITextField!
    @IBOutlet weak var tipNaMajstorKopce: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tipNaMjastorPick(_ sender: UIButton) {
        if sender.titleLabel?.text == "Elektricar"{
            tipNaMajstorKopce.titleLabel!.text = "Elektricar"
        }else if sender.titleLabel?.text == "Stolar" {
            tipNaMajstorKopce.titleLabel!.text = "Stolar"
        }else if sender.titleLabel?.text == "Bravar" {
            tipNaMajstorKopce.titleLabel!.text = "Bravar"
        }else if sender.titleLabel?.text == "Mehanicar" {
            tipNaMajstorKopce.titleLabel!.text = "Mehanicar"
        }else if sender.titleLabel?.text == "Moler" {
            tipNaMajstorKopce.titleLabel!.text = "Moler"
        }
    }
    @IBAction func konListaOdMajstori(_ sender: Any) {
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
