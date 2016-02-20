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
		postsTableViewController.title = "SAFE"
		let hotTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HotTableViewController") as! HotTableViewController
		hotTableViewController.title = "HOT"
		let explicitTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ExplicitTableViewController") as! ExplicitTableViewController
		explicitTableViewController.title = "R18"

		let viewControllers = [postsTableViewController, hotTableViewController, explicitTableViewController]

		let options = PagingMenuOptions()
		options.menuHeight = 40
		options.font = UIFont.systemFontOfSize(14)
		options.selectedFont = UIFont.systemFontOfSize(14, weight: 1.1)
		options.selectedTextColor = ColorSet.White.UIColor
		options.menuDisplayMode = .SegmentedControl
		options.menuItemMode = .RoundRect(radius: 15, horizontalPadding: 20.0, verticalPadding: 5.0, selectedColor: ColorSet.R18.UIColor)

		let pagingMenuController = self.childViewControllers.first as! PagingMenuController
		pagingMenuController.delegate = self
		pagingMenuController.setup(viewControllers: viewControllers, options: options)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override func prefersStatusBarHidden() -> Bool {
		return true
	}

}

extension MainViewController: PagingMenuControllerDelegate {
	func willMoveToMenuPage(page: Int) { }
	func didMoveToMenuPage(page: Int) { }
}