//
//  WebView.swift
//  GitHubUsers
//
//  Created by Landon Mann on 4/3/24.
//
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    // Create and configure the WKWebView
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        
        // Add a UIActivityIndicatorView as a subview
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        wkwebView.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: wkwebView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: wkwebView.centerYAnchor)
        ])
        
        // Set navigation delegate to self
        wkwebView.navigationDelegate = context.coordinator
        
        // Load the URLRequest
        let request = URLRequest(url: url)
        wkwebView.load(request)
        
        return wkwebView
    }
    
    // Update the WKWebView if needed
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Implementation not needed for now
    }
    
    // Coordinator to handle navigation events
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Remove the spinner when navigation is complete
            for subview in webView.subviews {
                if let spinner = subview as? UIActivityIndicatorView {
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()
                }
            }
        }
    }
}
