//
//  PostLocalManager.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 13/10/23.
//

import Foundation
import CoreData

class PostLocalManager{
    private var postsLocal: [Post] = []
    private var context: NSManagedObjectContext
    
    init(context:NSManagedObjectContext){
        self.context = context
    }
    
    func fetch(){
        do{
            self.postsLocal = try self.context.fetch(Post.fetchRequest())
        }catch let error{
            print("error: ", error)
        }
    }
    
    func getLocalPost(at index: Int) -> Post{
        return postsLocal[index]
    }
    
    func countLocalPosts() -> Int{
        return postsLocal.count
    }
    
    
}
