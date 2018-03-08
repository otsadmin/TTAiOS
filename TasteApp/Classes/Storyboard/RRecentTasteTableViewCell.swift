//
//  RRecentTasteTableViewCell.swift
//  Taste
//
//  Created by Ranjit Singh on 29/09/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class RRecentTasteTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var lblrestraunt: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblCuisineName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
