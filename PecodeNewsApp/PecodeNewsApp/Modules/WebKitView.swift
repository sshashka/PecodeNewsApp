//
//  WebKitView.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 29.11.2022.
//


import WebKit


class WebKitView: UIViewController {
    var urlString: String?
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let urlString = urlString else {
            handleError()
            return
        }
        
        
        let url = URL(string: urlString)
        guard let url = url else {
            handleError()
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func handleError() {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
        
    }
}
