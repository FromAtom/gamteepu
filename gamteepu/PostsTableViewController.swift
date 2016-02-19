//
//  PostsTableViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/18.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

import Alamofire
import Himotoki
import Haneke

class PostsTableViewController: UITableViewController {
	let limit = 20
	var page = 1
	var posts: [PostModel] = []
	var fetchers: [NetworkFetcher<UIImage>] = []
	var isLoadgind = false

	private func appendPost(post: PostModel) {
		guard let url = post.previewFileURL else {
			return
		}

		let fetcher = NetworkFetcher<UIImage>(URL: url)
		self.posts.append(post)
		self.fetchers.append(fetcher)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		registerNibs()

		let endpoint = "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)"

		Alamofire.request(.GET, endpoint).responseJSON { response in
			guard let json = response.result.value as? [[String : AnyObject]] else {
				return
			}

			for object in json {
				do {
					let post = try decode(object) as PostModel
					self.appendPost(post)
				}
				catch {
				}
			}

			self.tableView.reloadData()
		}
	}

	private func registerNibs() {
		let nibNames: [String] = [
			"PostImageTableViewCell"
		]

		for name in nibNames {
			tableView.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
	}

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCellWithIdentifier("PostImageTableViewCell", forIndexPath: indexPath) as? PostImageTableViewCell else {
			return UITableViewCell()
		}

		let row = indexPath.row
		cell.displayWithPostModel(posts[row], fetcher: fetchers[row])

        return cell
    }

}

// UITableViewDelegate
extension PostsTableViewController {
	private func loadNextPosts() {
		guard !isLoadgind else {
			return
		}

		isLoadgind = true
		page += 1
		let endpoint = "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)"

		Alamofire.request(.GET, endpoint).responseJSON { response in
			guard let json = response.result.value as? [[String : AnyObject]] else {
				return
			}

			for object in json {
				do {
					let post = try decode(object) as PostModel
					self.appendPost(post)
				}
				catch {
				}
			}

			self.isLoadgind = false
			self.tableView.reloadData()
		}
	}

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		guard indexPath.row >= posts.count - 1 && posts.count != 0 else {
			return
		}

		loadNextPosts()
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let post = posts[indexPath.row]
		return PostImageTableViewCell.heightWithModel(post, inTableView: tableView)
	}
}


enum FadeType: NSTimeInterval {
	case Fast = 0.1
	case Normal = 0.5
	case Slow = 1.0
}

extension UIView {
	func fadeIn(type: FadeType = .Fast, completion: (() -> ())? = nil) {
		fadeInWithDurasion(type.rawValue, completion: completion)
	}

	func fadeInWithDurasion(duration: NSTimeInterval = FadeType.Slow.rawValue, completion: (() -> ())? = nil) {
		alpha = 0
		hidden = false
		UIView.animateWithDuration(duration, animations: {
			self.alpha = 1
			}) { finished in
				completion?()
		}
	}

	func fadeOut(type: FadeType = .Fast, completion: (() -> ())? = nil) {
		fadeOutWithDuration(type.rawValue, completion: completion)
	}

	func fadeOutWithDuration(duration: NSTimeInterval = FadeType.Slow.rawValue, completion: (() -> ())? = nil) {
		UIView.animateWithDuration(duration, animations: {
			self.alpha = 0
			}) { [weak self] finished in
				self?.hidden = true
				self?.alpha = 1
				completion?()
		}
	}
}

