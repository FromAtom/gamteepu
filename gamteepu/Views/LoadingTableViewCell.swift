//
//  LoadingTableViewCell.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/20.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

	@IBOutlet weak var loadingContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

		loadingContainerView.backgroundColor = ColorSet.White.UIColor
		loadingContainerView.layer.cornerRadius = 25.0
		loadingIndicator.color = ColorSet.Primary.UIColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
