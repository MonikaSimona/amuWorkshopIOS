//
//  BaranjaKorisnikTableViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse

class BaranjaKorisnikTableViewController: UITableViewController {
    var baranjaMajstorIds = [String]()
    var baranjaDatum = [String]()
    var baranjaStatus = [String]()
    var objectIds = [String]()
    var lokacijaKorisnik: String = ""
    var koordinati: CLLocationCoordinate2D? = nil
   

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()

        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return baranjaMajstorIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baranjeKorisnikCell", for: indexPath)
//        var majstorName = ""
        let query = PFUser.query()
        query?.getObjectInBackground(withId: baranjaMajstorIds[indexPath.row], block: { (object, error) in
            if let err = error{
                print("cell")
                print(err.localizedDescription)
            }else{
                if let majstor = object {
//                    print("od cellForRowAt \(majstor["name"] as! String)")
//                    majstorName = majstor["name"] as! String
                    cell.textLabel?.text = majstor["name"] as? String
                }
                
            }
        })
//        print("majstor Name \(majstorName)")
//        cell.textLabel?.text = majstorName
        cell.detailTextLabel?.text = baranjaDatum[indexPath.row]
        let status = baranjaStatus[indexPath.row]
        if status == "aktivno"{
            cell.textLabel?.textColor = UIColor.yellow
            cell.detailTextLabel?.textColor = UIColor.yellow
        }else if status == "ponuda"{
            cell.textLabel?.textColor = UIColor.red
            cell.detailTextLabel?.textColor = UIColor.red
        }else if status == "zakazano"{
            cell.textLabel?.textColor = UIColor.blue
            cell.detailTextLabel?.textColor = UIColor.blue
        }else if status == "zavrseno"{
            cell.textLabel?.textColor = UIColor.green
            cell.detailTextLabel?.textColor = UIColor.green
        }
//        print(majstorName)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detaliBaranjeKorisnikSegue" {
            if let index  = tableView.indexPathForSelectedRow?.row{
                let baranje = segue.destination as! DetaliBaranjeKorisnikViewController
                baranje.baranjeId = objectIds[index]
                baranje.lokacijaKorisnik = lokacijaKorisnik
                baranje.koordinati = koordinati
                
            }
        }
    }
    
    func updateTable(){
        self.baranjaMajstorIds.removeAll()
        self.baranjaDatum.removeAll()
        self.baranjaStatus.removeAll()
        self.objectIds.removeAll()
        let query = PFQuery(className: "Baranje")
        query.whereKey("korisnikId", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { (objects, error) in
            if let err = error {
                print("updateTable")
                print(err.localizedDescription)
            }else{
                if let baranja = objects {
                    for baranje in baranja{
                        self.baranjaMajstorIds.append(baranje["majstorId"] as! String)
                        self.baranjaDatum.append(baranje["datum"] as! String )
                        self.baranjaStatus.append(baranje["status"] as! String)
                        self.objectIds.append(baranje.objectId!)
//                        print("Majstor \(baranje["majstorId"] as! String)")
//                        print(baranje["status"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
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
