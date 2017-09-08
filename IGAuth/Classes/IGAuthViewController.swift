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
    
    private let baseURL = "https://api.instagram.com"
    private let observerKeyPath = "estimatedProgress"
    
    private var clientID: String
    private var clientSecret: String
    private var redirectURI: String
    private var completion: (IGAuthResponse?) -> Void
    
    private var webView: WKWebView!
    private var progressView: UIProgressView!
    
    private var bundle: Bundle {
        let podBundle = Bundle(for: IGAuthViewController.self)
        let bundleURL = podBundle.url(forResource: "IGAuth", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
    
    // Custom properties
    public var authScope: String?
    public var customTitle: String?
    public var allowOnePasswordIntegration = true
    public var progressViewTintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(clientID: String, clientSecret: String, redirectURI: String, completion: @escaping (IGAuthResponse?) -> Void) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
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
            let onePasswordImage = UIImage(named: "1PasswordNavbar", in: bundle, compatibleWith: nil)
            let onePasswordButton = UIBarButtonItem(image: onePasswordImage, style: .plain, target: self, action: #selector(fillLoginUsing1Password))
            self.navigationItem.rightBarButtonItem = onePasswordButton
        }
    
        // Initialize web view
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        // Initialize progress view
        progressView = UIProgressView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 50))
        progressView.progress = 0.0
        progressView.tintColor = self.progressViewTintColor
        
        webView.addSubview(progressView)
        self.view.addSubview(webView)
        
        loadAuthorizationURL()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webView.addObserver(self, forKeyPath: self.observerKeyPath, options: .new, context: nil)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: self.observerKeyPath)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.observerKeyPath {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.progressView.alpha = 0.0
                }, completion: { (finished) in
                    self.progressView.progress = 0
                })
            }
        }
    }
    
    @objc func fillLoginUsing1Password() {
        OnePasswordExtension.shared().fillItem(intoWebView: webView, for: self, sender: nil, showOnlyLogins: false) { (success, error) in
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
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: self.authScope ?? "")
        ]
        
        let request = URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        webView.load(request)
    }
    
    func requestAccessToken(code: String) {
        let accessTokenURL = URL(string: baseURL + "/oauth/access_token/")
        var components = URLComponents(url: accessTokenURL!, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientID),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: self.redirectURI),
            URLQueryItem(name: "code", value: code)
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = components.percentEncodedQuery!.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                self.completion(nil)
                return
            }
            
            self.getAccessToken(data: data)
            }.resume()
    }
    
    private func getAccessToken(data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(IGAuthResponse.self, from: data)
            self.completion(response)
        } catch {
            self.completion(nil)
        }
    }
    
}

extension IGAuthViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.customTitle == nil {
            self.navigationItem.title = webView.title
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url!.absoluteString
        if let range = urlString.range(of: "?code=") {
            let location = range.upperBound
            let code = urlString[location...]
            requestAccessToken(code: String(code))
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
}
