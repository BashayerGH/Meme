//
//  memeTableViewController.swift
//  Meme
//
//  Created by Bashooora on 22/03/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit


class memeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!{
        let obj = UIApplication.shared.delegate
        let appDelegate = obj as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var memeTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation title
        self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        // add meme button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(AddMeme))
    }
    
    
    @objc func AddMeme() {
        if let navigationController = navigationController {
            
            let addMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "addMemeViewController") as! ViewController
            self.navigationController!.pushViewController(addMemeViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let memeForRow = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView?.image = memeForRow.memedImage
        cell.textLabel?.text = memeForRow.topText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailsController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //Populate view controller with data from the selected item
        detailsController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailsController, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.memeTV.reloadData()
    }

}
