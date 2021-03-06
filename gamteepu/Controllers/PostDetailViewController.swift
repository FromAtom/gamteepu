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
	@IBOutlet weak var thumbnailImageView: UIImageView!
	@IBOutlet weak var imageView: UIImageView!

	var targetPost: PostModel!

	class func viewController(_ post: PostModel) -> PostDetailViewController {
		let storyboard = UIStoryboard(name: "PostDetailViewController", bundle: Bundle.main)
		let viewController = storyboard.instantiateInitialViewController() as! PostDetailViewController

		viewController.targetPost = post

		return viewController
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		guard let previewURL = targetPost.previewFileURL, let largeURL = targetPost.largeFileURL else {
			return
		}

		setupImageView()
		let cache = Shared.imageCache
		let fetcher = NetworkFetcher<UIImage>(URL: previewURL)
		cache.fetch(fetcher: fetcher).onSuccess { [weak self] image in
			guard let thumbnailImage = self?.generageFilteredImage(image) else {
				return
			}

			cache.set(value: thumbnailImage, key: fetcher.key)
			self?.thumbnailImageView.image = thumbnailImage

			self?.imageView.hnk_setImageFromURL(largeURL, placeholder: nil, format: nil, failure: nil) { [weak self] image in
				self?.imageView.image = image
				self?.imageView.fadeIn(.normal)
			}
		}

    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}

	fileprivate func setupImageView() {
		imageView.isHidden = true
		imageView.alpha = 0.0
	}

	fileprivate func generageFilteredImage(_ image: UIImage) -> UIImage {
		guard let ciImage = CIImage(image: image), let filter = CIFilter(name: "CIGaussianBlur") else {
			return image
		}

		filter.setValue(ciImage, forKey: kCIInputImageKey)
		filter.setValue(1.0, forKey: "inputRadius")

		let context = CIContext(options: nil)
		guard let result = filter.outputImage else {
			return image
		}

		let cgImageRef = context.createCGImage(result, from: ciImage.extent)
		let filteredImage = UIImage(cgImage: cgImageRef!)
		return filteredImage
	}
}

