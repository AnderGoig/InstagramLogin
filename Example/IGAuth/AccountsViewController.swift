//
//  AccountsTableViewController.swift
//  IGAuth
//
//  Created by AnderGoig on 09/08/2017.
//  Copyright (c) 2017 AnderGoig. All rights reserved.
//

import UIKit
import IGAuth

class AccountsViewController: UITableViewController {
    
    var accounts = [IGAuthResponse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccount))
    }
    
    func addAccount() {
        let vc = IGAuthViewController(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI) { (response) in
            guard let response = response else {
                print("An error occurred while login in Instagram")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                
                self.accounts.append(response)
                self.tableView.reloadData()
            }
        }
        
        vc.authScope = "basic+public_content"
        
        show(vc, sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IGAccountCell", for: indexPath)
        
        let account = accounts[indexPath.row]
        
        cell.textLabel?.text = account.user.full_name
        cell.detailTextLabel?.text = "@" + account.user.username
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

