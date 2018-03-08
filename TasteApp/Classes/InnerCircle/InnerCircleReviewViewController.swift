//
//  InnerCircleReviewViewController.swift
//  Taste
//
//  Created by Lalitmohan on 5/30/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class InnerCircleReviewViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableInnerView: UITableView!
    
    
    
    @IBOutlet weak var imgRastaurant: UIImageView!
    @IBOutlet weak var btnBackClicked: UIImageView!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    
    @IBOutlet weak var lblPhone: UILabel!
    
    
    @IBOutlet weak var lblHours: UILabel!
    
    @IBOutlet weak var lblWebsite: UILabel!
    
    
    @IBOutlet weak var lblcuisine: UILabel!
    
    @IBOutlet weak var lblrating: UILabel!
    
    
    @IBOutlet weak var lblprice: UILabel!
    
    
    let textLabel = ["Jordan Smith", "Jordan Smith", "Jordan Smith", "Jordan Smith" ,"Jordan Smith" , "Jordan Smith" , "Jordan Smith"]
    
    let subLabel = ["Sales Assoc. at Google", "Sales Assoc. at Google", "Sales Assoc. at Google", "Sales Assoc. at Google" ,"Sales Assoc. at Google" , "Sales Assoc. at Google" , "Sales Assoc. at Google"]
    
    let ratingLabel = ["1", "2", "3", "4" ,"5" , "5" , "6"]
    
    let cellReuseIdentifier = "Cell"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableInnerView.delegate = self
        tableInnerView.dataSource = self
        
        btnBackClicked.isUserInteractionEnabled = true
        btnBackClicked.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goBack)))
        
        
        imgRastaurant.isUserInteractionEnabled = true
        imgRastaurant.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.goForward)))
    }
    
    @IBAction func btnRateClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnReadMoreClicked(_ sender: Any)
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InnerCircleReviewList")
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    func goBack()
    {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goForward()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RastaurantImageViewController")
        self.navigationController?.pushViewController(vc, animated: true)

//        let vc = RastaurantImageViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.textLabel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableInnerView.dequeueReusableCell(withIdentifier:cellReuseIdentifier, for: indexPath) as! InnerCircleCell
        
        cell.titleLabel.text = textLabel[indexPath.row]
        cell.titleSubLabel.text = subLabel[indexPath.row]
        cell.imageView?.image = UIImage(named:"profile")
       // cell.titleRating.text = ratingLabel[indexPath.row]
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

    

    
}
