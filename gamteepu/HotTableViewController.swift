//
//  PopularTableViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/19.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class HotTableViewController: PostsTableViewController {
	override var endpoint: String {
		return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=order:rank"
	}

	override func viewDidLoad() {
        super.viewDidLoad()

		title = "HOT"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
