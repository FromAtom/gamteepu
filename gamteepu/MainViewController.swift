//
//  MainViewController.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/19.
//  Copyright © 2016年 Atom. All rights reserved.
//

import UIKit
import PagingMenuController

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		navigationController?.navigationBarHidden = true

		let postsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PostsTableViewController") as! PostsTableViewController
		postsTableViewController.title = "POSTS"
		let hotTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HotTableViewController") as! HotTableViewController
		hotTableViewController.title = "HOT"
		let viewControllers = [postsTableViewController, hotTableViewController]

		let options = PagingMenuOptions()
		options.menuHeight = 40
		options.font = UIFont.systemFontOfSize(14)
		options.selectedFont = UIFont.systemFontOfSize(16, weight: 1.2)
		options.selectedTextColor = ColorSet.Primary.UIColor
		options.menuDisplayMode = .SegmentedControl
		options.menuItemMode = .Underline(height: 3.0, color: ColorSet.Primary.UIColor, horizontalPadding: 0, verticalPadding: 0)

		let pagingMenuController = self.childViewControllers.first as! PagingMenuController
		pagingMenuController.delegate = self
		pagingMenuController.setup(viewControllers: viewControllers, options: options)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController: PagingMenuControllerDelegate {
	func willMoveToMenuPage(page: Int) {

	}

	func didMoveToMenuPage(page: Int) {

	}
}