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
        override init() {
            super.init()
            reachability = try! Reachability()
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
        static func stopNotifier() -> Void {
            do {
                try (NetworkReachabilityManager.sharedInstance.reachability).startNotifier()
            } catch {
                print("Error stopping notifier")
            }
        }

        // Network is reachable
        static func isReachable(completed: @escaping (NetworkReachabilityManager) -> Void) {
            if (NetworkReachabilityManager.sharedInstance.reachability).connection != .unavailable {
                completed(NetworkReachabilityManager.sharedInstance)
            }
        }
        // Network is unreachable
        static func isUnreachable(completed: @escaping (NetworkReachabilityManager) -> Void) {
            if (NetworkReachabilityManager.sharedInstance.reachability).connection == .unavailable {
                completed(NetworkReachabilityManager.sharedInstance)
            }
        }
        // Network is reachable via WWAN/Cellular
        static func isReachableViaWWAN(completed: @escaping (NetworkReachabilityManager) -> Void) {
            if (NetworkReachabilityManager.sharedInstance.reachability).connection == .cellular {
                completed(NetworkReachabilityManager.sharedInstance)
            }
        }
        // Network is reachable via WiFi
        static func isReachableViaWiFi(completed: @escaping (NetworkReachabilityManager) -> Void) {
            if (NetworkReachabilityManager.sharedInstance.reachability).connection == .wifi {
                completed(NetworkReachabilityManager.sharedInstance)
            }
        }
}
