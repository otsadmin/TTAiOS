//
//  ExploreTasteViewController.swift
//  Taste
//
//  Created by Lalit Mohan on 18/05/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class ExploreTasteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    
    @IBOutlet weak var tableExplore: UITableView!
    
    let textLabel = ["Georgian", "Japanese", "Italian American", "Kurdish" ,"Russian" , "Slovak", "Ukrainian"]
    let cellReuseIdentifier = "Cell"

    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableExplore.delegate = self
        tableExplore.dataSource = self
        self.tableExplore.separatorStyle = .none
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.textLabel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableExplore.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath) as! FilterExploreTasteCell
        
        cell.titleLabel.text = textLabel[indexPath.row]
        cell.innerImageView?.image = UIImage(named:"checkbox_unchecked")
        
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
