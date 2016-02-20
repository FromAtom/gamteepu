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

protocol APIModule {
	var limit: Int { get }
	var page: Int { get set }
	var endpoint: String { get }
}

class PostsTableViewController: UITableViewController, APIModule {
	let limit = 20
	var page = 1
	var posts: [PostModel] = []
	var fetchers: [NetworkFetcher<UIImage>] = []
	var isLoadgind = false

	var endpoint: String {
		return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)"
	}

	private func appendPost(post: PostModel) {
		guard let url = post.previewFileURL else {
			return
		}

		let fetcher = NetworkFetcher<UIImage>(URL: url)
		posts.append(post)
		fetchers.append(fetcher)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "POSTS"
		registerNibs()

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
			self.isLoadgind = false
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

