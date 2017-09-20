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

    var accessTokens = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccount))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    func addAccount() {
        let vc = IGAuthViewController(clientID: clientID, redirectURI: redirectURI) { (accessToken) in
            guard let accessToken = accessToken else {
                print("Failed login")
                return
            }

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)

                self.accessTokens.append(accessToken)
                self.tableView.reloadData()
            }
        }

        vc.authScope = "basic+public_content"

        show(vc, sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessTokens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IGAccountCell", for: indexPath)

        let accessToken = accessTokens[indexPath.row]

        cell.textLabel?.text = accessToken

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
