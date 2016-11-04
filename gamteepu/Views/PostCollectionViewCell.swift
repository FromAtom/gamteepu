//
//  PostCollectionViewCell.swift
//  gamteepu
//
//  Created by FromAtom on 2016/06/16.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit
import Haneke

final class PostCollectionViewCell: UICollectionViewCell {
	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var containerView: UIView!

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		containerView.layer.cornerRadius = 6.0
		thumbnailImageView.layer.cornerRadius = 4.0
		thumbnailImageView.layer.masksToBounds = true
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		thumbnailImageView.hnk_cancelSetImage()
		thumbnailImageView.image = nil
	}

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		return layoutAttributes
	}

	func displayWithPostModel(_ post: PostModel) {
		if let url = post.previewFileURL {
			thumbnailImageView.hnk_setImageFromURL(url)
		}
	}

}
