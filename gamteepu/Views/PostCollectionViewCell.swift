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

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		layer.cornerRadius = 6.0
		layer.masksToBounds = true
		thumbnailImageView.layer.cornerRadius = 4.0
		thumbnailImageView.layer.masksToBounds = true
	}

	override func prepareForReuse() {
		thumbnailImageView.image = nil
	}

	override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		return layoutAttributes
	}

	func displayWithPostModel(post: PostModel) {
		if let url = post.previewFileURL {
			thumbnailImageView.hnk_setImageFromURL(url)
		}
	}

}
