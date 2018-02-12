//
//  ViewController.swift
//  InstagramLogin
//
//  Created by AnderGoig on 11/03/2017.
//  Copyright (c) 2017 AnderGoig. All rights reserved.
//

import UIKit
import InstagramLogin

class ViewController: UIViewController {

    // MARK: - Properties
    
    var instagramLogin: InstagramLoginViewController!

    // MARK: - Actions

    @IBAction func login() {
        instagramLogin = InstagramLoginViewController(clientId: Constants.clientId, redirectUri: Constants.redirectUri)
        instagramLogin.delegate = self
        instagramLogin.scopes = [.all]

        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))

        present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }

    func showAlertView(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertView, animated: true)
    }

    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }

    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }
}

// MARK: - InstagramLoginViewControllerDelegate

extension ViewController: InstagramLoginViewControllerDelegate {

    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {
        dismissLoginViewController()

        if accessToken != nil {
            showAlertView(title: "Successfully logged in! 👍", message: "")
        } else {
            showAlertView(title: "\(error!.localizedDescription) 👎", message: "")
        }
    }
}
