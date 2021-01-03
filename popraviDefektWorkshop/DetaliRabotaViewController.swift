//
//  DetaliRabotaViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse
import MapKit

extension UIImage{
    enum JPEGQuality: CGFloat{
        case lowest  = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    func jpeg(_ jpegQuality:JPEGQuality)->Data?{
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

class DetaliRabotaViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var rabotaId: String = ""
    var baranjeId: String = ""
    var korisnikId: String = ""
    var koordinati: CLLocationCoordinate2D? = nil
    @IBOutlet weak var datumRabota: UILabel!
    
    @IBOutlet weak var zavrsenaRabotaSlika: UIImageView!
    @IBOutlet weak var datumZavrsuvanjeField: UITextField!
    @IBOutlet weak var adresaDefekt: UILabel!
    @IBOutlet weak var statusRabota: UILabel!
    @IBOutlet weak var imePrezimeKorisnik: UILabel!
    @IBOutlet weak var emailKorisnik: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let query  = PFQuery(className: "Rabota")
        query.getFirstObjectInBackground { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let rabota = object{
                    self.datumRabota.text = "Datum na rabotenje: \(String(describing: rabota["datumPonuda"] as? String))"
                    self.statusRabota.text = "Status: \(String(describing: rabota["status"] as? String))"
                    self.adresaDefekt.text = "Lokacija \(String(describing: rabota["korisnikLokacija"]))"
                    self.korisnikId = rabota["korisnikId"] as! String
                    self.koordinati = rabota["koordinati"] as? CLLocationCoordinate2D
                    print(self.koordinati!)
                    
                    let korisnik = PFUser.query()
                    korisnik?.getObjectInBackground(withId: self.korisnikId, block: { (object, error) in
                        if let err = error {
                            print(err.localizedDescription)
                        }else{
                            if let korisnik = object as? PFUser{
                                self.imePrezimeKorisnik.text = korisnik["name"] as? String
                                self.emailKorisnik.text = korisnik.email
                            }
                        }
                    })
                    
                    
                }
            }
        }
    }
    

    @IBAction func konLokacijaPressed(_ sender: Any) {
        let latitude:CLLocationDegrees = (koordinati?.latitude)!
        let longitude:CLLocationDegrees = (koordinati?.longitude)!
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude,longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
        let options = [ MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapCenterKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Defekt"
        mapItem.openInMaps(launchOptions: options)
    }
    @IBAction func izberiSlikaPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            zavrsenaRabotaSlika.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func zavrsiRabotaPressed(_ sender: Any) {
//        var baranjeId = ""
        if let image = zavrsenaRabotaSlika.image{
//            let rabota = PFObject(className: "Rabota")
//            rabota["datum"] = datumZavrsuvanjeField.text
//            rabota["majstorId"] = PFUser.current()?.objectId
//            if let imagedata = image.jpeg(.medium){
//                let imageFile = PFFileObject(name: "image.jpg", data: imagedata)
//                rabota["imageFile"] = imageFile
//
//                rabota.saveInBackground { (success, error) in
//                    if success {
//                        self.datumZavrsuvanjeField.text = ""
//                        self.zavrsenaRabotaSlika.image = nil
//                    }else{
//                        print("\(error ?? "" as! Error)")
//                    }
//                }
//            }
            let query = PFQuery(className: "Rabota")
            query.getObjectInBackground(withId: rabotaId) { (object, error) in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    if let rabota  = object{
                        rabota["datumZavrsuvanje"] = self.datumZavrsuvanjeField.text
                        rabota["status"] = "zavrseno"
                        rabota["majstorId"] = PFUser.current()?.objectId
                        if let imagedata = image.jpeg(.medium){
                            let imageFile = PFFileObject(name: "image.jpg", data: imagedata)
                            rabota["imageFile"] = imageFile
                            self.datumZavrsuvanjeField.text = ""
                            self.zavrsenaRabotaSlika.image = nil
                            rabota.saveInBackground()
                           
                        }
                    }
                }
            }
        }
        
//        let queryRabota = PFQuery(className: "Rabota")
//        queryRabota.getObjectInBackground(withId: rabotaId) { (object, error) in
//            if let err = error {
//                print(err.localizedDescription)
//            }else{
//                if let rabota =  object {
//                    baranjeId = rabota["baranjeId"] as! String
//
//                }
//            }
//        }
        
        let queryBaranje = PFQuery(className: "Baranje")
        queryBaranje.getObjectInBackground(withId: baranjeId) { (object, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranje  =  object {
                    baranje["status"] = "zavrseno"
                    baranje.saveInBackground()
                }
            }
        }
    }
 

}
