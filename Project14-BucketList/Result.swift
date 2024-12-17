//
//  Result.swift
//  Project14-BucketList
//
//  Created by suhail on 15/12/24.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

                    
struct Page: Codable {
   
    let pageid: Int
    let title: String
    let terms: Term?
    
//    static func < (lhs: Page, rhs: Page) -> Bool{
//        lhs.title < rhs.title
//    }
}
struct Term: Codable{
    var description: [String]?
}
