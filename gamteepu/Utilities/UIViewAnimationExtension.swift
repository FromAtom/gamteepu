//
//  UIViewAnimationExtension.swift
//  gamteepu
//
//  Created by FromAtom on 2016/06/16.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation
import UIKit

enum FadeType: TimeInterval {
	case fast = 0.1
	case normal = 0.5
	case slow = 1.0
}

extension UIView {
	func fadeIn(_ type: FadeType = .fast, completion: (() -> ())? = nil) {
		fadeInWithDurasion(type.rawValue, completion: completion)
	}

	func fadeInWithDurasion(_ duration: TimeInterval = FadeType.slow.rawValue, completion: (() -> ())? = nil) {
		alpha = 0
		isHidden = false
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1
		}, completion: { finished in
			completion?()
		}) 
	}

	func fadeOut(_ type: FadeType = .fast, completion: (() -> ())? = nil) {
		fadeOutWithDuration(type.rawValue, completion: completion)
	}

	func fadeOutWithDuration(_ duration: TimeInterval = FadeType.slow.rawValue, completion: (() -> ())? = nil) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0
		}, completion: { [weak self] finished in
			self?.isHidden = true
			self?.alpha = 1
			completion?()
		}) 
	}
}
