//
//  ViewController.swift
//  WKDemo
//
//  Created by Arnab on 29/01/18.
//  Copyright © 2018 Arnab Hore. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet var wkWebView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var customUrl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        let myUrl = URL(string: customUrl ?? "https://www.apple.com")
        let myUrlRequest = URLRequest(url: myUrl!)
        wkWebView.load(myUrlRequest)
        
        wkWebView.addObserver(self, forKeyPath: "title", options: .new, context: nil);
        wkWebView.addObserver(self, forKeyPath: "loading", options: .new, context: nil);
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if wkWebView.canGoForward {
            wkWebView.goForward()
        }
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        if !wkWebView.isLoading {
            wkWebView.reload()
        } else {
            wkWebView.stopLoading()
            finishedLoading()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Methods
    func enableButton(button: UIButton, shouldEnable: Bool) {
        button.isEnabled = shouldEnable
        button.tintColor = shouldEnable ? UIColor.init(red: 25/255.0, green: 125/255.0, blue: 241/255.0, alpha: 1.0) : UIColor.gray
    }
    
    func finishedLoading() {
        DispatchQueue.main.async {
            self.progressView.progress = 0
            
            self.enableButton(button: self.backButton, shouldEnable: self.wkWebView.canGoBack)
            self.enableButton(button: self.nextButton, shouldEnable: self.wkWebView.canGoForward)
            self.reloadButton.setImage(#imageLiteral(resourceName: "reload.png"), for: .normal)
        }
    }
    
    //MARK: - WKUIDelegate (for target=“_blank”)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print(navigationAction.targetFrame ?? "no target")
        print(navigationAction.targetFrame?.isMainFrame ?? "no main")
        
        if navigationAction.targetFrame == nil {
            wkWebView.load(navigationAction.request)
        }
        return nil
    }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed with error: \(error.localizedDescription)")
        finishedLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish")
        finishedLoading()
    }
    
    
    //MARK: - Observe Value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            print(change ?? "No title")
            if change != nil, let currentTitle = change?[.newKey] as? String {
                titleLabel.text = currentTitle
            }
        } else if keyPath == "loading" {
            print("Loading")
            reloadButton.setImage(#imageLiteral(resourceName: "cancel.png"), for: .normal)
        } else if keyPath == "estimatedProgress" {
            print(wkWebView.estimatedProgress);
            progressView.progress = Float(wkWebView.estimatedProgress)
        }
    }

}

