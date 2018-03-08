//
//  RTermsVc.swift
//  Taste
//
//  Created by Ranjit Singh on 22/02/18.
//  Copyright © 2018 Ots. All rights reserved.
//

import UIKit

class RTermsVc: UIViewController {

    // MARK: LOAD TERMS AND CONDITION PAGE
    @IBOutlet weak var rWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let url = Bundle.main.url(forResource: "Term", withExtension: "htm")
        rWebView.loadRequest(URLRequest(url: url!) )

    }
    
    @IBAction func goBack(_ sender: Any) {
        _ =  self.navigationController?.popViewController(animated: true)
    }
}
