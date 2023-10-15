//
//  DetailPost.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 13/10/23.
//

import UIKit

class DetailPost: UIViewController {

    @IBOutlet weak var postId: UITextField!
    @IBOutlet weak var postUserId: UITextField!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postBody: UITextField!
    var post: Post?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var postLocalManager : PostLocalManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postLocalManager = PostLocalManager(context: context)
        if post != nil{
            postId.text = post?.id.description
            postUserId.text = post?.userId.description
            postTitle.text = post?.title
            postBody.text = post?.body
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ViewController
        let id : Int64? = Int64(postId.text!)
        let userId : Int64? = Int64(postUserId.text!)
        let title = postTitle.text
        let body = postBody.text
        if post == nil{
            post = Post(context: context)
        }
        postLocalManager?.fetch()
        post?.id = id ?? Int64((postLocalManager?.countLocalPosts())!)
        post?.userId = userId ?? 0
        post?.title = title
        post?.body = body
        
        destination.post = post
        
    }
    

}
