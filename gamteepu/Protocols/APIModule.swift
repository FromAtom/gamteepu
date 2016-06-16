//
//  APIModule.swift
//  gamteepu
//
//  Created by FromAtom on 2016/06/16.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation

protocol APIModule {
	var limit: Int { get }
	var page: Int { get set }
	var endpoint: String { get }
}

extension APIModule {
	var limit: Int {
		return 50
	}
	var endpoint: String {
		return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=rating:s"
		// Explicit: return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=rating:e"
		// Hot:  return "https://danbooru.donmai.us/posts.json?limit=\(limit)&page=\(page)&tags=order:rank"
	}
}
