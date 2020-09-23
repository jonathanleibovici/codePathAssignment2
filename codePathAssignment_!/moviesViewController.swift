//
//  moviesViewController.swift
//  codePathAssignment_!
//
//  Created by Jonathan Leibovici on 9/11/20.
//  Copyright © 2020 jonathanleibovici. All rights reserved.
//

import UIKit
import AlamofireImage
class moviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String//cast as a string
        //cell.textLabel!.text = title
        let synopsis = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let PosterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + PosterPath)
        cell.posterView.af_setImage(withURL: posterUrl!)
        return cell
    }
    
    
    @IBOutlet weak var MovieTableView: UITableView!
    var movies = [[String:Any]]()//this is an array of dictionarys
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MovieTableView.dataSource = self
        MovieTableView.delegate = self
        
        // Do any additional setup after loading the view.
        print("hello")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
               // self.MovieTableView.reloadData()
                self.MovieTableView.reloadData()
                print(dataDictionary)
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
    }
    
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        
        
        //lets find the selected movies the sender passes the selected movies
        let cell = sender as! UITableViewCell
        let indexPath = MovieTableView.indexPath(for:cell)!
        let movie = movies[indexPath.row]
    
    
    
    // Pass the selected object to the new view controller.
    
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        print(movie["title"])
        
         MovieTableView.deselectRow(at:indexPath,animated:true)
    }
    
    
}

