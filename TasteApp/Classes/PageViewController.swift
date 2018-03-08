//
//  PageViewController.swift
//  TasteApp
//
//  Created by Anuj Singh on 3/1/17.
//  Copyright © 2017 Ots. All rights reserved.
//

import UIKit


class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate
{
   
    var pageViewController: UIPageViewController!
    
        
    var arrPageTitle: NSArray = NSArray()
    var arrButtonTitle : NSArray = NSArray()
    
    override func viewDidLoad() {
    super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Tansition Style in pageview controller
        
    
        
        arrPageTitle = ["RECEIVE \n SUGGESTIONS \n FROM YOUR \n DINING HISTORY \n AND TENDENCIES.", "CONNECT BANK \n ACCOUNT TO \n APP FOR \n PERSONAL \n DINING \n ANALYTICS."];
        
        
        arrButtonTitle = ["Next","SignIn"]
        
        self.dataSource = self
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    
    
    
    // MARK:- UIPageViewControllerDataSource Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: SplashViewNextController = viewController as! SplashViewNextController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: SplashViewNextController = viewController as! SplashViewNextController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(_ index: NSInteger) -> SplashViewNextController
    {
        // Create a new view controller and pass suitable data.
//        let SplashViewNextController = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewNextController") as! SplashViewNextController
        
        
        let vc = SplashViewNextController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        
        
        //self.present(navVC, animated: true, completion: nil) no use
        
        
        
        
        vc.strTitle = "\(arrPageTitle[index])"
        vc.strButtonName = "\(arrButtonTitle[index])"
        vc.pageIndex = index
        
        return vc
    }
    
   

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
