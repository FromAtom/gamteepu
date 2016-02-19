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

	var fetcher: NetworkFetcher<UIImage>?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	override func prepareForReuse() {
		postImageView.hnk_cancelSetImage()
		postImageView.image = nil
		fetcher?.cancelFetch()
	}

	class func heightWithModel(post: PostModel, inTableView tableView: UITableView) -> CGFloat {
		if let height = post.imageHeight, let width = post.imageWidth {
			return ceil((tableView.bounds.width * CGFloat(height)) / CGFloat(width)) + 1
		}

		return 100
	}

	func displayWithPostModel(post: PostModel, fetcher: NetworkFetcher<UIImage>) {
		self.fetcher = fetcher
		if let _ = self.fetcher {
			postImageView.hnk_setImageFromFetcher(self.fetcher!, placeholder: nil, format: nil, failure: nil, success: nil)
		}

		if let url = post.largeFileURL {
			let cache = Shared.imageCache
			let fetcher = NetworkFetcher<UIImage>(URL: url)

			cache.fetch(fetcher: fetcher).onSuccess { [weak self] image in
				self?.fetcher?.cancelFetch()
				self?.postImageView.hnk_cancelSetImage()
				self?.postImageView.image = image
			}
		}
	}
}


