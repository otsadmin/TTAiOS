//
//  ExploreTabTableViewCell.swift
//  Taste
//
//  Created by Asish Pant on 11/10/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit

class ExploreTabTableViewCell: UITableViewCell {
    @IBOutlet weak var exploreImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var lblrestraunt: UILabel!
    @IBOutlet weak var lblMiles: UILabel!
    @IBOutlet weak var lblCuisineName: UILabel!
    @IBOutlet weak var textLabelSuggestion: UILabel!
    @IBOutlet weak var suggestedBy: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
