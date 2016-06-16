//
//  PostModel.swift
//  gamteepu
//
//  Created by FromAtom on 2016/02/18.
//  Copyright © 2016年 Atom. All rights reserved.
//

import Foundation
import UIKit

import Himotoki
import Haneke

struct PostModel: Decodable {
	let id: Int
	let imageWidth: Int
	let imageHeight: Int
	let fileType: String

	let previewFilePath: String?
	let largeFilePath: String?
	let originalFilePath: String?
	let previewFileURL: NSURL?
	let largeFileURL: NSURL?
	let originalFileURL: NSURL?


	let artist: String?
	static let endpoint = "https://danbooru.donmai.us"

	static func decode(e: Extractor) throws -> PostModel {
		let previewFilePath: String? = try e <|? "preview_file_url"
		let previewFileURL = PostModel.benri(previewFilePath)

		let largeFilePath: String? = try e <|? "large_file_url"
		let largeFileURL = PostModel.benri(largeFilePath)

		let originalFilePath: String? = try e <|? "file_url"
		let originalFileURL = PostModel.benri(originalFilePath)

		return try PostModel(
			id: e <| "id",
			imageWidth: e <| "image_width",
			imageHeight: e <| "image_height",
			fileType: e <| "file_ext",
			previewFilePath: previewFilePath,
			largeFilePath: largeFilePath,
			originalFilePath: originalFilePath,
			previewFileURL: previewFileURL,
			largeFileURL: largeFileURL,
			originalFileURL: originalFileURL,
			artist: e <|? "tag_string_artist"
		)
	}

	static func benri(path: String?) -> NSURL? {
		if let path = path {
			return NSURL(string: PostModel.endpoint + path)
		}
		return nil
	}
}























