//
//  ViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/12/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var userPIckSwitch: UISwitch!
    @IBOutlet weak var ObicenLabel: UILabel!
    @IBOutlet weak var MajstorLabel: UILabel!
    @IBOutlet weak var nameSurnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var elektricarButton: UIButton!
    @IBOutlet weak var stolarButton: UIButton!
    @IBOutlet weak var bravarButton: UIButton!
    @IBOutlet weak var mehanicarButton: UIButton!
    @IBOutlet weak var molerButton: UIButton!
    var signUpMode = false
    var tipNaMajstor = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if !signUpMode{
            ObicenLabel.isHidden = false
            MajstorLabel.isHidden = false
            userPIckSwitch.isHidden = false
            nameSurnameTextField.isHidden = false
            phoneTextField.isHidden = false
            tipLabel.isHidden = false
            elektricarButton.isHidden = false
            stolarButton.isHidden = false
            bravarButton.isHidden = false
            mehanicarButton.isHidden = false
            molerButton.isHidden = false
        }
        
    }
   

    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func tipNaMajstorPressed(_ sender: Any) {
    }
    @IBAction func topButtonPressed(_ sender: Any) {
        
        if emailTextField.text == "" && passwordTextField.text == "" {
            displayAlert(title: "Greska vo formata", message: "Treba da vneses email i password")
        }else {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode {
                if userPIckSwitch.isOn{
                    // kje se registrira majstor
                    let user = PFUser()
                    user.username = emailTextField.text! + "_majstor"
                    user.password = passwordTextField.text
                    user.email = emailTextField.text
                    
                    
                    user.signUpInBackground { (success, error) in
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if let error = error {
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Greska vo Registracijata", message: errorString)
                        } else {
                            print("Uspesna Registracija!")
                            self.performSegue(withIdentifier: "majstorSegue", sender: self)
                        }
                    }
                    
                }else{
                    // kje se registrira obicen korisnik
                    let user = PFUser()
                    user.username = emailTextField.text! + "_defekt"
                    user.password = passwordTextField.text
                    user.email = emailTextField.text
                    
                    
                    user.signUpInBackground { (success, error) in
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if let error = error {
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Greska vo Registracijata", message: errorString)
                        } else {
                            print("Uspesna Registracija!")
                            self.performSegue(withIdentifier: "defektSegue", sender: self)
                        }
                    }
                }
               
            } else {
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error {
                        let errorString = error.localizedDescription
                        self.displayAlert(title: "Greska vo Najavata", message: errorString)
                    } else {
                        print("Uspesna Najava")
                        if user?.username?.components(separatedBy: "_")[1] == "majstor"{
                            self.performSegue(withIdentifier: "majstorSegue", sender: self)
                        }else{
                            self.performSegue(withIdentifier: "defektSegue", sender: self)
                        }
                        
                    }
                }
                
            }
        }
        
    }
    @IBAction func bottomButtonPressed(_ sender: Any) {
        if signUpMode {
            signUpMode = false
            topButton.setTitle("Najava", for: .normal)
            bottomButton.setTitle("Premini kon Registracija", for: .normal)
            if userPIckSwitch.isOn{
                ObicenLabel.isHidden = true
                MajstorLabel.isHidden = true
                userPIckSwitch.isHidden = true
                nameSurnameTextField.isHidden = true
                phoneTextField.isHidden = true
                tipLabel.isHidden = true
                elektricarButton.isHidden = true
                stolarButton.isHidden = true
                bravarButton.isHidden = true
                mehanicarButton.isHidden = true
                molerButton.isHidden = true
            }else{
                tipLabel.isHidden = false
                elektricarButton.isHidden = false
                stolarButton.isHidden = false
                bravarButton.isHidden = false
                mehanicarButton.isHidden = false
                molerButton.isHidden = false
            }
            
          
            
        
        }else {
            signUpMode = true
            topButton.setTitle("Registracija", for: .normal)
            bottomButton.setTitle("Premini kon Najava", for: .normal)
            ObicenLabel.isHidden = false
            MajstorLabel.isHidden = false
            userPIckSwitch.isHidden = false
            nameSurnameTextField.isHidden = false
            phoneTextField.isHidden = false
            tipLabel.isHidden = false
            elektricarButton.isHidden = false
            stolarButton.isHidden = false
            bravarButton.isHidden = false
            mehanicarButton.isHidden = false
            molerButton.isHidden = false
        }
        
    }
}

