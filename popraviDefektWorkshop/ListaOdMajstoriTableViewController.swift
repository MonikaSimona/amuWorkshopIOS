//
//  ListaOdMajstoriTableViewController.swift
//  popraviDefektWorkshop
//
//  Created by simona on 12/19/20.
//  Copyright © 2020 simona. All rights reserved.
//

import UIKit
import Parse

class ListaOdMajstoriTableViewController: UITableViewController {
    
    var majstori = [String]()
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
        return majstori.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = majstori[indexPath.row]

        return cell
    }
    func updateTable () {
        self.majstori.removeAll()
        self.objectIds.removeAll()
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: "%@"+"_majstori")
//        query?.whereKey("username" ,notEqualTo: PFUser.current()?.username ?? "")
        query?.findObjectsInBackground(block: { (users, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }else if let users = users{
                for object in users {
                    if let user = object as? PFUser{
                        if let username = user.username{
                            if let objectId = user.objectId{
                                self.majstori.append(username)
                                self.objectIds.append(objectId)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        });
        
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
