//
//  InstagramLoginViewController.swift
//  InstagramLogin
//
//  Created by Ander Goig on 8/9/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

import UIKit
import WebKit

public protocol InstagramLoginViewControllerDelegate: class {
    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?)
}

open class InstagramLoginViewController: UIViewController {

    // MARK: - Properties

    private var client: (id: String, redirectUri: String)

    private var webView: WKWebView!
    private var progressView: UIProgressView?
    private var webViewObservation: NSKeyValueObservation?

    // MARK: - Public Properties

    public weak var delegate: InstagramLoginViewControllerDelegate?

    public var scopes: [InstagramScope] = [.basic]
    public var progressViewTintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)

    // MARK: - Initializers

    public init(clientId: String, redirectUri: String) {
        self.client.id = clientId
        self.client.redirectUri = redirectUri

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Initializes progress view
        setupProgressView()

        // Initializes web view
        setupWebView()

        // Starts authorization
        loadAuthorizationURL()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let progressView = progressView { progressView.removeFromSuperview() }
        if let webViewObservation = webViewObservation { webViewObservation.invalidate() }
    }

    private func setupProgressView() {
        if let navBar = navigationController?.navigationBar {
            let progressView = UIProgressView(progressViewStyle: .bar)
            progressView.progress = 0.0
            progressView.tintColor = progressViewTintColor

            navBar.addSubview(progressView)

            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor).isActive = true
            progressView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor).isActive = true
            progressView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 1).isActive = true

            self.progressView = progressView
        }
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)
        webView.navigationDelegate = self

        view.addSubview(webView)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        webView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        if progressView != nil {
            webViewObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)
        }
    }

    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView!.alpha = 1.0
        progressView!.setProgress(Float(webView.estimatedProgress), animated: true)

        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView!.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView!.progress = 0
            })
        }
    }

    // MARK: -

    private func loadAuthorizationURL() {
        var components = URLComponents(string: "https://api.instagram.com/oauth/authorize/")!

        components.queryItems = [
            URLQueryItem(name: "client_id", value: client.id),
            URLQueryItem(name: "redirect_uri", value: client.redirectUri),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: "+"))
        ]

        webView.load(URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }

    // MARK: - Public methods

    public func reloadPage(fromOrigin: Bool = false) {
        let _ = fromOrigin ? webView.reloadFromOrigin() : webView.reload()
    }
}

// MARK: - WKNavigationDelegate

extension InstagramLoginViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if navigationItem.title == nil {
            navigationItem.title = webView.title
        }
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url?.absoluteString, let range = url.range(of: "#access_token=") {
            self.delegate?.instagramLoginDidFinish(accessToken: String(url[range.upperBound...]), error: nil)
        }

        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        if let response = navigationResponse.response as? HTTPURLResponse, response.statusCode == 400 {
            self.delegate?.instagramLoginDidFinish(accessToken: nil, error: InstagramError(kind: .invalidRequest, message: "Invalid request"))
        }

        decisionHandler(.allow)
    }
}
