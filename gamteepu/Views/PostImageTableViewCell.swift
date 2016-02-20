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

	var previewImageFetcher: NetworkFetcher<UIImage>?
	var largeImageFetcher: NetworkFetcher<UIImage>?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	override func prepareForReuse() {
		postImageView.hnk_cancelSetImage()
		postImageView.image = nil

		previewImageFetcher?.cancelFetch()
		previewImageFetcher = nil

		largeImageFetcher?.cancelFetch()
		largeImageFetcher = nil
	}

	class func heightWithModel(post: PostModel, inTableView tableView: UITableView) -> CGFloat {
		let height = post.imageHeight
		let width = post.imageWidth

		return ceil((tableView.bounds.width * CGFloat(height)) / CGFloat(width))
	}

	func startLargeImageFetch() {
		guard let fetcher = largeImageFetcher else {
			return
		}

		let cache = Shared.imageCache
		cache.fetch(fetcher: fetcher).onSuccess { [weak self] image in
			self?.previewImageFetcher?.cancelFetch()
			self?.postImageView.hnk_cancelSetImage()
			self?.postImageView.image = image
		}
	}

	func stopLargeImageFetch() {
		largeImageFetcher?.cancelFetch()
	}

	func displayWithPostModel(post: PostModel, fetcher: NetworkFetcher<UIImage>) {
		previewImageFetcher = fetcher
		if let previewImageFetcher = previewImageFetcher {
			postImageView.hnk_setImageFromFetcher(previewImageFetcher, placeholder: nil, format: nil, failure: nil, success: nil)
		}

		if let url = post.largeFileURL {
			let cache = Shared.imageCache
			let fetcher = NetworkFetcher<UIImage>(URL: url)
			largeImageFetcher = fetcher

			cache.fetch(fetcher: fetcher).onSuccess { [weak self] image in
				self?.previewImageFetcher?.cancelFetch()
				self?.postImageView.hnk_cancelSetImage()
				self?.postImageView.image = image
			}
		}
	}
}


