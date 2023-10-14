//
//  PostServiceManager.swift
//  WSCRUD
//
//  Created by Álvaro Gómez Segovia on 07/10/23.
//

import Foundation


class PostServiceManager{
    static let shared = PostServiceManager()
    private var postsAPI: [PostResponse] = []
        
    init () {
        
    }
    
    func countPosts() -> Int{
        return postsAPI.count
    }
    
    
    func getPost(at index: Int) -> PostResponse{
        return postsAPI[index]
    }
    
    

    
    func getPostsAPI(completion: @escaping ([PostResponse]?) -> Void){
        let url = URL(string: Constants.apiDomain + Constants.getPostURL)!
        let session = URLSession.shared
        var httpResponse = HTTPURLResponse()
        
        // Creates a data task with a URL request
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Invalid response")
                httpResponse = (response as? HTTPURLResponse)!
                print("statusCode: ", httpResponse.statusCode)
                completion([])
                return
            }
            
            // Check if there is any data
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do{
                
                let decodedResponse = try JSONDecoder().decode([PostResponse].self, from: data)
                for post in decodedResponse{
                    self.postsAPI.append(post)
                }
                completion(self.postsAPI)
                
            } catch let error{
                completion([])
                print("JSON parsing error: \(error)")
                
            }
            
        }
        // Start the task
        task.resume()
        
    }
    
    func createPost(post : PostResponse, completion: @escaping (PostResponse?) -> Void) {
            guard let url = URL(string: Constants.postURL) else {
                completion(nil)
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key es para mandar como si fuera mandando en Params con postman (get)
            
            do {
                //Encode our post
                let jsonData = try JSONEncoder().encode(post)
                
                print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        //Handle response data
                        if let createdPost = try? JSONDecoder().decode(PostResponse.self, from: data) {
                            completion(createdPost)
                        }
                    } else if let error = error {
                        print("Error:", error)
                        completion(nil)
                    }
                }
                task.resume()
            } catch let error{
                print("Error:", error)
                completion(nil)
            }
        }
    
    func updatePost(post : PostResponse, completion: @escaping (PostResponse?) -> Void) {
            let urlString = Constants.postURL + String(post.id)
            print("urlString:", urlString)
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type") //value - key
        
            do {
                //Encode our post
                let jsonData = try JSONEncoder().encode(post)
                print("JSON:", try JSONSerialization.jsonObject(with: jsonData) )
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        //Handle response data
                        if let updatedPost = try? JSONDecoder().decode(PostResponse.self, from: data) {
                            completion(updatedPost)
                        }
                    } else if let error = error {
                        print("Error:", error)
                        completion(nil)
                    }
                }
                task.resume()
            } catch let error{
                print("Error:", error)
                completion(nil)
            }
        }
    
    func deletePost(id: Int, completion: @escaping (Int) -> Void) {
            let urlString = Constants.postURL + String(id)
            print("urlString:", urlString)
                
            guard let url = URL(string: urlString) else {
                completion(0)
                return
            }
                
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
                
            let task = URLSession.shared.dataTask(with: request) { (data, response,   error) in
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(response.statusCode)
                } else if let error = error {
                    print("Error:", error)
                    completion(0)
                }
            }
            task.resume()
        }

}
