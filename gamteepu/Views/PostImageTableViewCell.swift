//
//  PostImageTableViewCell.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/18.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit
import Haneke

class PostImageTableViewCell: UITableViewCell {
	@IBOutlet weak var postImageView: UIImageView!

	var targetPost: PostModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	override func prepareForReuse() {
		backgroundColor = UIColor.clearColor()
		postImageView.hnk_cancelSetImage()
		postImageView.image = nil
	}

	class func heightWithModel(post: PostModel, inTableView tableView: UITableView) -> CGFloat {
		let height = post.imageHeight
		let width = post.imageWidth

		return ceil((tableView.bounds.width * CGFloat(height)) / CGFloat(width))
	}

	func displayWithPostModel(post: PostModel) {
		targetPost = post
		if let url = post.previewFileURL {
			postImageView.hnk_setImageFromURL(url)
		}
	}
}
