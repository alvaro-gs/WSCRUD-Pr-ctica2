//
//  Post.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 07/10/23.
//

import Foundation

struct PostResponse : Codable {
    let id : Int?
    let title : String
    let body : String
    let userId : Int
}
