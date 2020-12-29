//
//  PortfolioMajstorTableViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse
class PortfolioMajstorTableViewController: UITableViewController {
    var objectId: String = ""
    var images = [PFFileObject]()
    var dates = [String]()
    var opisDefekt: String = ""
    var lokacijaKorisnik: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(objectId)
        let query = PFQuery(className: "Rabota")
        query.whereKey("majstorId", equalTo: objectId)
        query.findObjectsInBackground { (objects, error) in
            if let raboti = objects{
                for rabota in raboti{
                    self.images.append(rabota["imageFile"] as! PFFileObject)
                    self.dates.append(rabota["datum"] as! String)
                    self.tableView.reloadData()
                }
            }
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func pobarajMajstor(_ sender: Any) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        let baranje = PFObject(className: "Baranje")
        baranje["korisnikId"] = PFUser.current()?.objectId
        baranje["majstorId"] = objectId
        baranje["opisDefekt"] = opisDefekt
        baranje["datum"] = dateString
        baranje["status"] = "aktivno"
        baranje.saveInBackground { (success, error) in
            if let err = error{
                print(err.localizedDescription)
            }else{
                print(success.description)
                print("Napraveno Baranje")
            }
        }
        
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioTableViewCell
        images[indexPath.row].getDataInBackground { (data, error) in
            if let imagedata = data {
                if let img  = UIImage(data: imagedata){
                    cell.solvedImage.image = img
                }
            }
        }

        cell.solvedDatum.text = dates[indexPath.row]

        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
