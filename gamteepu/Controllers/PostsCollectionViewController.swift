//
//  PostsCollectionViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/06/16.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

import Alamofire
import Himotoki

class PostsCollectionViewController: UICollectionViewController, APIModule {
	var page: Int = 1
	var posts: [PostModel] = []
	var isLoadgind = false

    override func viewDidLoad() {
        super.viewDidLoad()

		registerNibs()
		refresh()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
		cell.displayWithPostModel(posts[indexPath.row])
        return cell
    }

	override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		guard indexPath.row >= posts.count - 2 && posts.count != 0 else {
			return
		}

		loadNextPosts()
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let countPerLine: CGFloat = 2
		let padding: CGFloat = 5.0
		let spacing = padding * 2 + CGFloat(countPerLine - 1) * padding
		let cellSize = floor((view.frame.size.width - spacing) / countPerLine)

		return CGSize(width: cellSize, height: cellSize)
	}
}

extension PostsCollectionViewController {

	func refresh() {
		resetPosts()

		isLoadgind = true
		fetchPosts()
	}

	func loadNextPosts() {
		guard !isLoadgind else {
			return
		}

		isLoadgind = true
		page += 1
		fetchPosts()
	}

}

private extension PostsCollectionViewController {

	private func fetchPosts() {
		Alamofire.request(.GET, endpoint).responseJSON { [weak self] response in
			defer {
				self?.isLoadgind = false
			}
			guard let json = response.result.value as? [[String : AnyObject]] else {
				return
			}

			for object in json {
				do {
					let post = try decodeValue(object) as PostModel
					guard let _ = post.previewFileURL where post.fileType != "gif" else {
						return
					}

					self?.posts.append(post)
				}
				catch {
				}
			}

			self?.collectionView?.reloadData()
		}
	}

	private func resetPosts() {
		page = 1
		posts = []
	}

	private func registerNibs() {
		let nibNames: [String] = [
			"PostCollectionViewCell"
		]

		for name in nibNames {
			collectionView?.registerNib(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
		}
	}

}