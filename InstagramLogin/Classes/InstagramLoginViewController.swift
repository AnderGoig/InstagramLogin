//
//  InstagramLoginViewController.swift
//  InstagramLogin
//
//  Created by Ander Goig on 8/9/17.
//  Copyright © 2017 Ander Goig. All rights reserved.
//

import UIKit
import WebKit

open class InstagramLoginViewController: UIViewController {

    public typealias CompletionHandler = (_ accesToken: String?, _ error: InstagramError?) -> Void

    // MARK: - Properties

    private var client: (id: String, redirectURI: String)
    private var completion: CompletionHandler

    private var progressView: UIProgressView!
    private var webViewObservation: NSKeyValueObservation!

    // MARK: - Custom Properties

    public var scopes: [InstagramScope] = [.basic]
    public var customTitle: String?
    public var progressViewTintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)

    // MARK: - Initializers

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(clientID: String, redirectURI: String, completion: @escaping CompletionHandler) {
        client.id = clientID
        client.redirectURI = redirectURI
        self.completion = completion

        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - View Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()

        if customTitle != nil {
            navigationItem.title = customTitle
        }

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        // Initializes progress view
        setupProgressView()

        // Initializes web view
        let webView = setupWebView()

        // Starts authorization
        loadAuthorizationURL(webView: webView)
    }

    private func setupProgressView() {
        let navBar = navigationController!.navigationBar

        progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progress = 0.0
        progressView.tintColor = progressViewTintColor
        progressView.translatesAutoresizingMaskIntoConstraints = false

        navBar.addSubview(progressView)

        let bottomConstraint = navBar.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 1)
        let leftConstraint = navBar.leadingAnchor.constraint(equalTo: progressView.leadingAnchor)
        let rightConstraint = navBar.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)

        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint])
    }

    private func setupWebView() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()

        let webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.navigationDelegate = self

        webViewObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)

        view.addSubview(webView)

        return webView
    }

    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView.alpha = 1.0
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)

        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView.progress = 0
            })
        }
    }

    deinit {
        progressView.removeFromSuperview()
        webViewObservation.invalidate()
    }

    // MARK: -

    private func loadAuthorizationURL(webView: WKWebView) {
        var components = URLComponents(string: "https://api.instagram.com/oauth/authorize/")!

        components.queryItems = [
            URLQueryItem(name: "client_id", value: client.id),
            URLQueryItem(name: "redirect_uri", value: client.redirectURI),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopes.joined(separator: "+"))
        ]

        webView.load(URLRequest(url: components.url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }

    func endAuthentication(accessToken: String?, error: InstagramError?) {
        self.completion(accessToken, error)
    }

}

// MARK: - WKNavigationDelegate

extension InstagramLoginViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if self.customTitle == nil {
            self.navigationItem.title = webView.title
        }
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlString = navigationAction.request.url!.absoluteString

        guard let range = urlString.range(of: "#access_token=") else {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)

        DispatchQueue.main.async {
            self.endAuthentication(accessToken: String(urlString[range.upperBound...]), error: nil)
        }
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse,
                        decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let httpResponse = navigationResponse.response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 400:
                decisionHandler(.cancel)
                DispatchQueue.main.async {
                    self.endAuthentication(accessToken: nil, error: InstagramError(kind: .invalidRequest, message: "Invalid request"))
                }
                return
            default:
                break
            }
        }

        decisionHandler(.allow)
    }

}
