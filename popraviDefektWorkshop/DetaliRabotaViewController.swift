//
//  DetaliRabotaViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse

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

    @IBOutlet weak var datumRabota: UILabel!
    
    @IBOutlet weak var zavrsenaRabotaSlika: UIImageView!
    @IBOutlet weak var datumZavrsuvanjeField: UITextField!
    @IBOutlet weak var adresaDefekt: UILabel!
    @IBOutlet weak var statusRabota: UILabel!
    @IBOutlet weak var imePrezimeKorisnik: UILabel!
    @IBOutlet weak var emailKorisnik: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func konLokacijaPressed(_ sender: Any) {
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
        if let image = zavrsenaRabotaSlika.image{
            let rabota = PFObject(className: "Rabota")
            rabota["datum"] = datumZavrsuvanjeField.text
            rabota["majstorId"] = PFUser.current()?.objectId
            if let imagedata = image.jpeg(.medium){
                let imageFile = PFFileObject(name: "image.jpg", data: imagedata)
                rabota["imageFile"] = imageFile
                
                rabota.saveInBackground { (success, error) in
                    if success {
                        self.datumZavrsuvanjeField.text = ""
                        self.zavrsenaRabotaSlika.image = nil
                    }else{
                        print("\(error ?? "" as! Error)")
                    }
                }
            }
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
