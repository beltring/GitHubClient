//
//  NetworkReachabilityManager.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/4/21.
//

import Foundation
import Reachability

class NetworkReachabilityManager: NSObject {
    
    var reachability: Reachability!
    
    static let sharedInstance: NetworkReachabilityManager = {
        return NetworkReachabilityManager()
    }()
    
    private override init() {
        super.init()
        reachability = try? Reachability()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        print("network status changed")
    }
    
    static func stopNotifier() {
        do {
            try (NetworkReachabilityManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
}
