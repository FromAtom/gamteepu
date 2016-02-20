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
	var gifRefreshControl: GIFRefreshControl!

	var endpoint: String {
		return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=rating:s"
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		registerNibs()
		setupPullToRefresh()

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

	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	private func appendPost(post: PostModel) {
		guard let url = post.previewFileURL where post.fileType != "gif" else {
			return
		}

		let fetcher = NetworkFetcher<UIImage>(URL: url)
		posts.append(post)
		fetchers.append(fetcher)
	}

	private func resetPosts() {
		page = 1
		posts = []
		fetchers = []
	}

	private func registerNibs() {
		let nibNames: [String] = [
			"PostImageTableViewCell",
			"LoadingCell"
		]

		for name in nibNames {
			tableView.registerNib(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
		}
	}

	private func setupPullToRefresh() {
		let URL = NSURL(string: "https://dl.dropboxusercontent.com/u/14483152/progress.gif")
		let data = NSData(contentsOfURL: URL!)

		gifRefreshControl = GIFRefreshControl()
		gifRefreshControl.animatedImage = GIFAnimatedImage(data: data!)
		gifRefreshControl.contentMode = .ScaleAspectFit

		gifRefreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
		tableView.addSubview(gifRefreshControl)
	}

	func refresh() {
		resetPosts()
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
			self.gifRefreshControl.endRefreshing()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
	}

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let row = indexPath.row

		if row > posts.count - 1 {
			let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath) as! LoadingTableViewCell
			cell.loadingIndicator.startAnimating()
			return cell
		}

		guard let cell = tableView.dequeueReusableCellWithIdentifier("PostImageTableViewCell", forIndexPath: indexPath) as? PostImageTableViewCell else {
			return UITableViewCell()
		}


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
		guard indexPath.row >= posts.count - 2 && posts.count != 0 else {
			return
		}

		loadNextPosts()
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		let row = indexPath.row
		if row > posts.count - 1 {
			return 60
		}

		let post = posts[row]
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

