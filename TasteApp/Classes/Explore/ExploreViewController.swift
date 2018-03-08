//
//  ExploreViewController.swift
//  TasteApp
//
//  Created by Shubhank on 28/02/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView:UITableView!
    var mapView:MKMapView!
    var whiteBarView:UIView!
    var mapWrapperView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    func goBack()
    {
       _ =  self.navigationController?.popViewController(animated: true)
    }
    
    
    func jumpToFilterView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FilterViewController")
        self.present(vc, animated: true, completion: nil)

    }
    
    

    func setupView() {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "splash_bg")
//        self.view.addSubview(imageView)
//        imageView.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
        
        self.view.backgroundColor = UIColor.white
        
//        let logoImageView = UIImageView()
//        logoImageView.image = UIImage(named: "logo-transprent")
//        self.view.addSubview(logoImageView)
//        logoImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(330 * 0.5)
//            make.height.equalTo(400 * 0.5)
//            make.centerX.equalTo(self.view)
//            make.centerY.equalTo(self.view).offset(-40)
//        }
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo-transprent")
        self.view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            //  make.top.equalTo(40)
            make.width.equalTo(490 * 0.5)//330
            make.height.equalTo(580 * 0.5)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-20)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "EXPLORE"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: K_Font_Color_Bold, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(40)
        }
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named:"ic_back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(named:"ic_filter"), for: .normal)
        filterButton.addTarget(self, action: #selector(self.jumpToFilterView), for: .touchUpInside)
        self.view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }

       
       
        let textField = UITextField()
        //textField.delegate = self
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        textField.backgroundColor = UIColor.black
        textField.layer.cornerRadius = 8
        textField.textColor = UIColor.white
        //textField.text = "Search"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
        textField.leftViewMode = .always
        let str = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName:UIColor.white])
        textField.attributedPlaceholder = str
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
            make.top.equalTo(textField.snp.bottom).offset(10)
        }
        tableView.tableFooterView = UIView()
        

        mapWrapperView = UIView()
        self.view.addSubview(mapWrapperView)
        mapWrapperView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        mapWrapperView.isHidden = true
        
        mapView = MKMapView()
        mapWrapperView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(80)
            make.bottom.equalTo(0)
        }
        
        whiteBarView = UIView()
        mapWrapperView.addSubview(whiteBarView)
        whiteBarView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(80)
        }
        whiteBarView.backgroundColor = UIColor.white
        whiteBarView.layer.shadowColor = UIColor.darkGray.cgColor
        whiteBarView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        whiteBarView.layer.shadowRadius = 1.0
        whiteBarView.layer.shadowOpacity = 0.3
        
        
        let titleLabel2 = UILabel()
        titleLabel2.text = "EXPLORE"
        titleLabel2.textAlignment = .center
        titleLabel2.numberOfLines = 2
        titleLabel2.font = UIFont(name: K_Font_Color_Bold, size: 24)
        //titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        mapWrapperView.addSubview(titleLabel2)
        titleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalTo(whiteBarView).offset(10)
        }
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setImage(UIImage(named:"ic_setting"), for: .normal)
        mapWrapperView.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(whiteBarView).offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
        let mapButton = UIButton(type: .custom)
        mapButton.setImage(UIImage(named:"map_area"), for: .normal)
        mapWrapperView.addSubview(mapButton)
        mapButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.right.equalTo(-10)
            make.bottom.equalTo(-50)
        }
        mapButton.addTarget(self, action: #selector(self.hideMap), for: .touchUpInside)
    }
    
    func hideMap() {
        self.mapWrapperView.isHidden = true
    }
    
    //MARK: TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "bankCell")
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        var images = ["dummy-img01", "dummy-img02", "dummy-img03", "dummy-img04"]
        
        let imageView = UIImageView()
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(0)
        }
        //imageView.backgroundColor = UIColor(white: 0.5, alpha: 0.8)
        imageView.image = UIImage(named: images[indexPath.row])
        imageView.clipsToBounds = true
        
        let textLabel = UILabel()
        textLabel.textColor = UIColor.black
        cell.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-20)
            make.centerY.equalTo(cell.contentView)
        }
        textLabel.font = UIFont.boldSystemFont(ofSize: 18)
        //textLabel.text = "Jim's China"
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapWrapperView.isHidden = false
        
    }

}
