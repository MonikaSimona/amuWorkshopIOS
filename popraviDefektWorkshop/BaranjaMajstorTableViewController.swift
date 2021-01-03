//
//  BaranjaMajstorTableViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/24/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse
class BaranjaMajstorTableViewController: UITableViewController {
    var baranjaKorisnikIds = [String]()
    var baranjaDatum = [String]()
    var baranjaStatus = [String]()
    var objectIds = [String]()
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
        return baranjaKorisnikIds.count
    }
    
    @IBAction func odjava(_ sender: Any) {
        PFUser.logOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func raboti(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "baranjeCell", for: indexPath)
        if baranjaStatus[indexPath.row] == "aktivno"{
            print("aktivno")
            let query = PFUser.query()
            query?.getObjectInBackground(withId: baranjaKorisnikIds[indexPath.row], block: { (object, error) in
                if let err = error{
                    print(err.localizedDescription)
                }else{
                    print("pred da zeme ime")
                    if let korisnik = object {
//                         print("od tabela \(korisnik["name"] as! String)")
                        cell.textLabel?.text = korisnik["name"] as? String
                       
                    }
                    
                }
            })
            cell.detailTextLabel?.text = baranjaDatum[indexPath.row]
        }else{
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            print("Greska")
        }
        
        return cell
    }
    func updateTable(){
        self.baranjaKorisnikIds.removeAll()
        self.baranjaDatum.removeAll()
        self.baranjaStatus.removeAll()
        self.objectIds.removeAll()
        let query = PFQuery(className: "Baranje")
        query.whereKey("majstorId", equalTo: PFUser.current()?.objectId ?? "")
        query.findObjectsInBackground { (objects, error) in
            if let err = error {
                print(err.localizedDescription)
            }else{
                if let baranja = objects {
                    for baranje in baranja{
                        self.baranjaKorisnikIds.append(baranje["korisnikId"] as! String)
                        self.baranjaDatum.append(baranje["datum"] as! String )
                        self.baranjaStatus.append(baranje["status"] as! String)
                        self.objectIds.append(baranje.objectId!)
                        print(baranje["korisnikId"] as! String)
                        print(baranje["status"] as! String)
                        print(baranje["datum"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detaliBaranjeMajstorSegue" {
            if let index  = tableView.indexPathForSelectedRow?.row{
                let baranje = segue.destination as! DetaliBaranjeMajstorViewController
                baranje.baranjeId = objectIds[index]
                
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
