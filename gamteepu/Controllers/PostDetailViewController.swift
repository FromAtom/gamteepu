//
//  PostDetailViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/08/17.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit
import Haneke

final class PostDetailViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView!

	var targetPost: PostModel!

	class func viewController(post: PostModel) -> PostDetailViewController {
		let storyboard = UIStoryboard(name: "PostDetailViewController", bundle: NSBundle.mainBundle())
		let viewController = storyboard.instantiateInitialViewController() as! PostDetailViewController

		viewController.targetPost = post

		return viewController
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let previewURL = targetPost.previewFileURL, largeURL = targetPost.largeFileURL else {
			return
		}

		let cache = Shared.imageCache
		let fetcher = NetworkFetcher<UIImage>(URL: previewURL)
		cache.fetch(fetcher: fetcher).onSuccess { image in
			self.imageView.hnk_setImageFromURL(largeURL, placeholder: image, format: nil, failure: nil, success: nil)
		}

    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}


}

