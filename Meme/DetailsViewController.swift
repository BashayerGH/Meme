//
//  DetailsViewController.swift
//  Meme
//
//  Created by Bashooora on 22/03/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    
    var meme: Meme!
    
    @IBOutlet weak var memeimageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeimageView!.image = meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    

}
