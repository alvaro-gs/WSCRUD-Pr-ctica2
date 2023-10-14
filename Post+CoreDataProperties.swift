//
//  Post+CoreDataProperties.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 13/10/23.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}

extension Post : Identifiable {

}
