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

	let numberOfItemsInLine: Int = 3
	let inset: CGFloat = 10
	var cellWidth: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Gamteepu"
		let width: CGFloat = collectionView?.frame.width ?? UIScreen.main.bounds.width
		cellWidth = floor((width - inset * CGFloat(numberOfItemsInLine + 1)) / CGFloat(numberOfItemsInLine))

		registerNibs()
		refresh()
    }

}

extension PostsCollectionViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionViewCell", for: indexPath) as! PostCollectionViewCell
		cell.displayWithPostModel(posts[indexPath.row])
        return cell
    }

	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard indexPath.row >= posts.count - 2 && posts.count != 0 else {
			return
		}

		loadNextPosts()
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let index = indexPath.row
		let post = posts[index]
		let vc = PostDetailViewController.viewController(post)

		navigationController?.pushViewController(vc, animated: true)
	}

}

// MARK: UICollectionView: layout
extension PostsCollectionViewController {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		return CGSize(width: cellWidth, height: cellWidth)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return inset
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return inset
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

	func fetchPosts() {
		Alamofire.request(endpoint).responseJSON { [weak self] response in
			defer {
				self?.isLoadgind = false
			}
			guard let json = response.result.value as? [[String : AnyObject]] else {
				return
			}

			for object in json {
				do {
					let post = try decodeValue(object) as PostModel
					guard let _ = post.previewFileURL, post.fileType != "gif" else {
						continue
					}

					self?.posts.append(post)
				}
				catch {
				}
			}

			self?.collectionView?.reloadData()
		}
	}

	func resetPosts() {
		page = 1
		posts = []
	}

	func registerNibs() {
		let nibNames: [String] = [
			"PostCollectionViewCell"
		]

		for name in nibNames {
			collectionView?.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
		}
	}

}
