//
//  ViewController.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 07/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postTable: UITableView!
    let postService = PostServiceManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var postLocalManager : PostLocalManager?
    var post: Post?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        postTable.dataSource = self
        postTable.delegate = self
        postLocalManager = PostLocalManager(context: self.context)
        
        postLocalManager?.fetch()
        
        
        // Condición para que haga consulta a la API solo la primera vez que ejecuta la aplicación
        if postLocalManager?.countLocalPosts() == 0{
            print("No hay registros, hice consulta a API")
            postService.getPostsAPI { postsAPI in
                DispatchQueue.main.async{
                    if postsAPI?.isEmpty != nil {
                        
                        for postAPI in postsAPI!{
                            let postLocal = Post(context: self.context)
                            postLocal.id = postAPI.id
                            postLocal.userId = postAPI.userId
                            postLocal.title = postAPI.title
                            postLocal.body = postAPI.body
                            do{
                                try self.context.save()
                            }catch let error {
                                print("error: ",error)
                            }
                        }
                        self.postLocalManager?.fetch()
                        self.postTable.reloadData()
                    }
                }
            }
        }else{
            print("Hay registros, no hice consulta a API")
        }
                
        
        
        
        // Pruebas sin interfaz
        /*// Crear el post
        postService.createPost(post: myPost){ createdPost in
            
            if let createdPost = createdPost{
                 print("created Post:",createdPost)
            }
            else{
                print("Error: Failed to create post")
            }
            
        }
        
        // Actualizar el post
        myPost = PostResponse(id: 50, title: "updated post", body: "New content", userId: 5)
        postService.updatePost(post: myPost){ updatedPost in
            
            if let updatedPost = updatedPost{
                print("updated Post:",updatedPost)
            }
            else{
                print("Error: Failed to update post")
            }
        }
        
        
        // Eliminar el post
        
        postService.deletePost(id: 50){ statusCode in
            
            if statusCode == 200 {
                print("deleted post")
            }
            else{
                print("Error: Failed to delete post")
            }
            
        }*/
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailPost
        if segue.identifier == "detailPost"{
            destination.post = post
        }
        
    }
    
    @IBAction func unWindFromDetailPost(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailPost
        post = source.post
        do {
            try context.save()
        }catch let error {
            print("Error: ",error)
        }
        postLocalManager?.fetch()
        postTable.reloadData()
    }


}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return postService.countPosts()
        return (postLocalManager?.countLocalPosts())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        //cell.postTitle.text = postService.getPost(at: indexPath.row).title
        cell.postTitle.text = "id: " + (postLocalManager?.getLocalPost(at: indexPath.row).id.description)!
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        post = postLocalManager?.getLocalPost(at: indexPath.row)
        performSegue(withIdentifier: "detailPost", sender: self.self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            post = postLocalManager?.getLocalPost(at: indexPath.row)
            context.delete(post!)
            postLocalManager?.fetch()
            postTable.reloadData()
        }
    }
}

