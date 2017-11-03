//
//  ViewController.swift
//  InstagramLogin
//
//  Created by AnderGoig on 11/03/2017.
//  Copyright (c) 2017 AnderGoig. All rights reserved.
//

import UIKit
import InstagramLogin

class ViewController: UITableViewController {

    var accessTokens = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccount))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func addAccount() {
        let vc = InstagramLoginViewController(clientID: clientID, redirectURI: redirectURI) { accessToken, error in
            guard let accessToken = accessToken else {
                print("Failed login: " + error!.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)

                self.accessTokens.append(accessToken)
                self.tableView.reloadData()
            }
        }

        vc.scopes = [.basic, .publicContent]

        show(vc, sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessTokens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstagramLoginCell", for: indexPath)

        let accessToken = accessTokens[indexPath.row]

        cell.textLabel?.text = accessToken

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
