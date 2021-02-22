//
//  UITableViewCell+Table.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    //MARK: - Dequeue
    class func dequeueReusableCell(in tableView: UITableView, for indexPath: IndexPath, reuseIdentifier identifier: String? = nil) -> Self {
        return dequeueReusableCellPrivate(in: tableView, for: indexPath, reuseIdentifier: identifier ?? name)
    }
    
    
    private class func dequeueReusableCellPrivate<T>(in tableView: UITableView, for indexPath: IndexPath, reuseIdentifier: String) -> T {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        return cell as! T
    }
    
    
    //Mark: Register
    
    class func registerCellNib(_ nibName: String? = nil,
                               bundle bundleOrNil: Bundle? = nil,
                               forCellReuseIdentifier identifier: String? = nil,
                               in tableView: UITableView) {
        
        let nib = UINib(nibName: nibName ?? name, bundle: bundleOrNil)
        tableView.register(nib, forCellReuseIdentifier: identifier ?? name)
    }
    
    class func registerCellClass(forCellReuseIdentifier identifier: String? = nil,
                                 in tableView: UITableView) {
        
        tableView.register(self, forCellReuseIdentifier: identifier ?? name)
    }
}
