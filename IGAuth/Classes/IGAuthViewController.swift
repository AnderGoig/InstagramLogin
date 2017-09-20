//
//  IGAuthViewController.swift
//  IGAuth
//
//  Created by Ander Goig on 8/9/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

import UIKit
import WebKit
import OnePasswordExtension

public class IGAuthViewController: UIViewController {

    // MARK: - Constants

    private let baseURL = "https://api.instagram.com"
    private let observerKeyPath = "estimatedProgress"

    // MARK: - Properties

    private var clientID: String
    private var redirectURI: String
    private var completion: (String?) -> Void

    private var webView: WKWebView!
    private var progressView: UIProgressView!
    private var webViewObservation: NSKeyValueObservation!

    private var bundle: Bundle {
        let podBundle = Bundle(for: IGAuthViewController.self)
        let bundleURL = podBundle.url(forResource: "IGAuth", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }

    // MARK: - Custom Properties

    public var authScope: String?
    public var customTitle: String?
    public var allowOnePasswordIntegration = true
    public var progressViewTintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)

    // MARK: - Initializers

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(clientID: String, redirectURI: String, completion: @escaping (_ accessToken: String?) -> Void) {
        self.clientID = clientID
        self.redirectURI = redirectURI
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - View Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        if self.customTitle != nil {
            self.navigationItem.title = self.customTitle
        }

        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }

        // 1Password integration
        if allowOnePasswordIntegration && OnePasswordExtension.shared().isAppExtensionAvailable() {
            let icon = UIImage(named: "1PasswordNavbar", in: bundle, compatibleWith: nil)
            let rightBarButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(fillLogin))
            self.navigationItem.rightBarButtonItem = rightBarButton
        }

        let navBar = navigationController!.navigationBar

        // Initialize progress view
        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.tintColor = self.progressViewTintColor
        progressView.translatesAutoresizingMaskIntoConstraints = false

        navBar.addSubview(progressView)

        let bottomConstraint = NSLayoutConstraint(item: navBar, attribute: .bottom, relatedBy: .equal,
                                                  toItem: progressView, attribute: .bottom, multiplier: 1, constant: 1)
        let leftConstraint = NSLayoutConstraint(item: navBar, attribute: .leading, relatedBy: .equal,
                                                toItem: progressView, attribute: .leading, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: navBar, attribute: .trailing, relatedBy: .equal,
                                                 toItem: progressView, attribute: .trailing, multiplier: 1, constant: 0)

        navigationController!.view.addConstraints([bottomConstraint, leftConstraint, rightConstraint])

        // Initialize web view
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self

        webViewObservation = webView.observe(\.estimatedProgress) { (view, _ change) in
            self.progressView.alpha = 1.0
            self.progressView.setProgress(Float(view.estimatedProgress), animated: true)
            if view.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressView.alpha = 0.0
                }, completion: { (_ finished) in
                    self.progressView.progress = 0
                })
            }
        }

        self.view.addSubview(webView)

        // Start authorization
        loadAuthorizationURL()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        progressView.removeFromSuperview()
        webViewObservation.invalidate()
    }

    // MARK: -

    @objc func fillLogin() {
        OnePasswordExtension
            .shared()
            .fillItem(intoWebView: webView, for: self, sender: nil, showOnlyLogins: false) { (success, error) in
            if success == false {
                print("Failed to fill into webview: <\(error!)>")
            }
        }
    }

    private func loadAuthorizationURL() {
        let authorizationURL = URL(string: baseURL + "/oauth/authorize/")
        var components = URLComponents(url: authorizationURL!, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "redirect_uri", value: self.redirectURI),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: self.authScope ?? "")
        ]

        let request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

    func endAuthentication(accessToken: String?) {
        self.completion(accessToken)
    }

}

// MARK: -

extension IGAuthViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.customTitle == nil {
            self.navigationItem.title = webView.title
        }
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url!.absoluteString

        if let range = urlString.range(of: "#access_token=") {
            let location = range.upperBound
            let code = urlString[location...]
            endAuthentication(accessToken: String(code))
            decisionHandler(.cancel)
            return
        }

        decisionHandler(.allow)
    }

}
