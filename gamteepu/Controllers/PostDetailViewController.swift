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
			let thumbnailImage = self.generageFilteredImage(image)
			self.imageView.hnk_setImageFromURL(largeURL, placeholder: thumbnailImage, format: nil, failure: nil, success: nil)
		}

    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	private func generageFilteredImage(image: UIImage) -> UIImage {
		guard let ciImage = CIImage(image: image), filter = CIFilter(name: "CIColorMonochrome") else {
			return image
		}

		filter.setValue(ciImage, forKey: kCIInputImageKey)
		filter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
		filter.setValue(1.0, forKey: "inputIntensity")

		let context = CIContext(options: nil)
		guard let result = filter.outputImage else {
			return image
		}

		let cgImageRef = context.createCGImage(result, fromRect: ciImage.extent)
		let filteredImage = UIImage(CGImage: cgImageRef)
		return filteredImage
	}
}

