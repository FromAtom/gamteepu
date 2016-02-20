//
//  ExplicitTableViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/20.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit

class ExplicitTableViewController: PostsTableViewController {
	override var endpoint: String {
		return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=rating:e"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
