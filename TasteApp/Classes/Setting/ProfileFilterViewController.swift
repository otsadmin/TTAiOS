//
//  ProfileFilterViewController.swift
//  TasteApp
//
//  Created by Lalit Mohan on 3/17/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit


class ProfileFilterViewController: UIViewController,UICollectionViewDelegate{
    
    
    @IBAction func goBackScreen(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    let headerViewIdentifier = "HeaderView"
  
    let reuseIdentifier = "filtercell"
    var items = ["American", "Indian", "Greek", "German", "French", "Chinese", "Cuban", "South", "Arabian", "Armenian", "Asian", "Basque"]
    
    
    var itemSection = ["Price","Cuisine"]
    
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
            }
    
    
    
    //MARK - UICOLLECTION VIEW DELEGATE
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

