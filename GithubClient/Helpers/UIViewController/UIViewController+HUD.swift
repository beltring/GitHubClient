//
//  UIViewController+HUD.swift
//  GithubClient
//
//  Created by user on 4/7/21.
//

import Foundation
import PKHUD
import UIKit

extension UIViewController {
    func presentHUD(content: HUDContentType, delay: TimeInterval = 0.5) {
        HUD.flash(content, delay: delay)
    }
}
