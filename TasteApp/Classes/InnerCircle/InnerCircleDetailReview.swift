//
//  InnerCircleDetailReview.swift
//  Taste
//
//  Created by Lalitmohan on 5/31/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class InnerCircleDetailReview: UIViewController
{

    
    @IBOutlet weak var lblTitleHeading: UILabel!
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDesignation: UILabel!
    
    
    
    @IBOutlet weak var lblMettingType: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var descriptionLbl: UITextView!
    @IBOutlet weak var imageview: UIImageView!
    
     var updateTitleLabel: String?
     var updateDesignationLabel: String?
     var updateDescriptionLabel: String?
     var updateRatingLabel: String?
     var image: UIImage?
    @IBAction func btnBackClicked(_ sender: Any)
    {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text=updateTitleLabel!
        lblDesignation.text=updateDesignationLabel!
        descriptionLbl.text=updateDescriptionLabel!
        rating.text=updateRatingLabel!
       // imageview.image=image!
        
    }

    
    

    
}
