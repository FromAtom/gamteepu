//
//  UIViewAnimationExtension.swift
//  gamteepu
//
//  Created by FromAtom on 2016/06/16.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation
import UIKit

enum FadeType: NSTimeInterval {
	case Fast = 0.1
	case Normal = 0.5
	case Slow = 1.0
}

extension UIView {
	func fadeIn(type: FadeType = .Fast, completion: (() -> ())? = nil) {
		fadeInWithDurasion(type.rawValue, completion: completion)
	}

	func fadeInWithDurasion(duration: NSTimeInterval = FadeType.Slow.rawValue, completion: (() -> ())? = nil) {
		alpha = 0
		hidden = false
		UIView.animateWithDuration(duration, animations: {
			self.alpha = 1
		}) { finished in
			completion?()
		}
	}

	func fadeOut(type: FadeType = .Fast, completion: (() -> ())? = nil) {
		fadeOutWithDuration(type.rawValue, completion: completion)
	}

	func fadeOutWithDuration(duration: NSTimeInterval = FadeType.Slow.rawValue, completion: (() -> ())? = nil) {
		UIView.animateWithDuration(duration, animations: {
			self.alpha = 0
		}) { [weak self] finished in
			self?.hidden = true
			self?.alpha = 1
			completion?()
		}
	}
}
