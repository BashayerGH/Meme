//
//  memeCollectionViewController.swift
//  Meme
//
//  Created by Bashooora on 22/03/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit

class memeCollectionViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!{
        let obj = UIApplication.shared.delegate
        let appDelegate = obj as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var memeCV: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation title
        self.navigationController?.navigationBar.topItem?.title = "Sent Memes"
        // add meme button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(AddMeme))
        
        //The style of collection cells
        cells()
    }
    
    @objc func AddMeme() {
        if let navigationController = navigationController {
            
            let addMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "addMemeViewController") as! ViewController
            self.navigationController!.pushViewController(addMemeViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell2", for: indexPath) as! CollectionViewCell
        let memeForRow = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView.image = memeForRow.memedImage
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailsController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //Populate view controller with data from the selected item
        detailsController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailsController, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.memeCV.reloadData()
    }
    
    func cells() {
        let space:CGFloat = 1.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        // space between cells
        flowLayout.minimumInteritemSpacing = space
        // space between rows
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    

}
