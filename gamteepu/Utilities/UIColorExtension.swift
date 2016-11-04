//
//  UIColorExtension.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/19.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	convenience init?(hexString: String, alpha: CGFloat = 1.0) {
		let validatedHexColorCode = hexString.replacingOccurrences(of: "#", with: "")
		let scanner = Scanner(string: validatedHexColorCode)
		var colorCode: UInt32 = 0

		guard scanner.scanHexInt32(&colorCode) else {
			print("ERROR: 色変換に失敗しました。")
			return nil
		}

		let R = CGFloat((colorCode & 0xFF0000) >> 16) / 255.0
		let G = CGFloat((colorCode & 0x00FF00) >> 8) / 255.0
		let B = CGFloat(colorCode & 0x0000FF) / 255.0
		self.init(red: R, green: G, blue: B, alpha: alpha)
	}
}

// 色設定
enum ColorSet: String {
	case Background   = "F9F5EF"
	case Primary      = "E66C9F"
	case White        = "FFFFFF"
	case Gray         = "D0CAC1"
	case LightGray    = "E4E1DE"
	case Black        = "111D22"
	case Resnap       = "E5893D"
	case R15          = "9577CB"
	case R18          = "D95F92"

	var UIColor: UIKit.UIColor {
		return UIKit.UIColor(hexString: self.rawValue)!
	}

	var CGColor: UIKit.CGColor {
		return self.UIColor.cgColor
	}
}
