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
    var long: Double = 0
    var lat: Double = 0
    @IBOutlet weak var datumRabota: UILabel!
    
    @IBOutlet weak var zavrsenaRabotaSlika: UIImageView!
    @IBOutlet weak var datumZavrsuvanjeField: UITextField!
    @IBOutlet weak var adresaDefekt: UILabel!
    @IBOutlet weak var statusRabota: UILabel!
    @IBOutlet weak var imePrezimeKorisnik: UILabel!
    @IBOutlet weak var emailKorisnik: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(baranjeId)
        print(rabotaId)
        let query  = PFQuery(className: "Rabota")
        query.whereKey("baranjeId", equalTo: baranjeId)
        query.getFirstObjectInBackground { (object, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                if let rabota = object{
                    if let datumRabota = rabota["datumPonuda"] as? String{
                        if let status = rabota["status"] as? String{
                            if let adresa = rabota["korisnikLokacija"] {
                                if let korisnikId = rabota["korisnikId"] as? String{
                                    if let lat = rabota["lat"] as? Double{
                                        if let long = rabota["long"] as? Double{
                                            self.datumRabota.text = "Datum na rabotenje: \(datumRabota)"
                                            self.statusRabota.text = "Status: \(status)"
                                            self.adresaDefekt.text = "Lokacija \(adresa)"
                                            self.korisnikId = korisnikId
                                            self.lat = lat
                                            self.long = long
                                            print(lat, long)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
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
        let latitude:CLLocationDegrees = lat
        let longitude:CLLocationDegrees = long 
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude,longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates,latitudinalMeters: regionDistance,longitudinalMeters: regionDistance)
        let options = [ MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
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
