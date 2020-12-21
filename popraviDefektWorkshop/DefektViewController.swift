//
//  DefektViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/13/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import MapKit
import Parse

class DefektViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var defektLocLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var opisZaDefekt: UITextField!
    @IBOutlet weak var tipNaMjastorKopce: UIButton!
    var tipNaMajstorString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DefektViewController.longpress(gestureReg:)))
        longPress.minimumPressDuration = 1
        map.addGestureRecognizer(longPress)
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
   
  
    @IBAction func tipNaMajstorPressed(_ sender: UIButton) {
        tipNaMajstorString =  (sender.titleLabel?.text)! + "i"
        tipNaMjastorKopce.titleLabel!.text = tipNaMajstorString
    }
    @IBAction func konListaOdMajstori(_ sender: UIButton) {
//        print(sender.titleLabel?.text)
    }
    
    @IBAction func odjava(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func longpress(gestureReg: UILongPressGestureRecognizer){
        if gestureReg.state == UILongPressGestureRecognizer.State.began{
            let touchPoint = gestureReg.location(in:self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
                print(newCoordinate)
            
            
            var title = ""
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: {(placemarks, error) in
                if error != nil{
                    print(error!)
                }else{
                    if let placemark = placemarks?[0]{
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                            print("sub \(title)")
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                            print("subTho \(title)")
                        }
                    }
                    if title == ""{
                        title = "Added \(NSDate())"
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = self.title
                    self.map.addAnnotation(annotation)
                    self.defektLocLabel.text = title
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
