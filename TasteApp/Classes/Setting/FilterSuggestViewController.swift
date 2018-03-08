//
//  FilterSuggestViewController.swift
//  TasteApp
//
//  Created by Aparna on 3/22/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class FilterSuggestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    
    @IBOutlet var chatsTable: UITableView!
    var chats = [String]()
    
    
    @IBAction func btnSourceClicked(_ sender: Any)
    {
    }
    
    
    
    @IBAction func btnPriceClicked(_ sender: Any) {
    }
    
    
    @IBAction func btnCuisineClicked(_ sender: Any)
    {
        
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        chatsTable.dataSource = self
        chatsTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // var rowCount = 0
        if section == 0
        {
            return 1
            // rowCount = Data1.count
        }
        if section == 1
        {
            return 1
            //  rowCount = Data2.count
        }
        if section == 2 {
            return 1
            //  rowCount = Data2.count
        }
        if section == 3 {
            return 1
            //  rowCount = Data2.count
        }
        if section == 4 {
            return 1
            //  rowCount = Data2.count
        }
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section==0)
        {
            let cell = chatsTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilterSuggestTableViewCell
            
            return cell
            
        }
        if(indexPath.section==1){
            
            let cell1 = chatsTable.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! FilterSuggestTableViewCell
            return cell1
            
        }
        if(indexPath.section==2){
            
            let cell2 = chatsTable.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! FilterSuggestTableViewCell
            return cell2
            
        }
        if(indexPath.section==3){
            
            let cell3 = chatsTable.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! FilterSuggestTableViewCell
            return cell3
            
        }
        if(indexPath.section==4){
            
            let cell4 = chatsTable.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! FilterSuggestTableViewCell
            return cell4
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section==0)
        {
            return 98
        }
        if(indexPath.section==1)
        {
            return 122
        }
        if(indexPath.section==2)
        {
            return 58
        }
        if(indexPath.section==3)
        {
            return 71
        }
        if(indexPath.section==4)
        {
            return 223
        }
        return 30
        
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
     {
        
    }
    
    
    

    @IBAction func backAction(_ sender: Any) {
           self.navigationController?.popViewController(animated: true)
    }

}
