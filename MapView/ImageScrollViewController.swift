//
//  ImageScrollViewController.swift
//  DemoSecondScreen
//
//  Created by Tejashree Khedkar on 2/6/16.
//  Copyright © 2016 Tejashree Khedkar. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, iCarouselDelegate, iCarouselDataSource{

    @IBOutlet weak var carousel: iCarousel!
    
    var images = [UIImage(named: "lalbaug1"),UIImage(named: "lalbaug2"),UIImage(named: "lalbaug3"),UIImage(named: "lalbaug4"),UIImage(named: "lalbaug5"),UIImage(named: "lalbaug6")]

    var items: [Int] = []
    override func awakeFromNib()
    {
        super.awakeFromNib()
        for i in 0...99
        {
            items.append(i)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.dataSource = self
        carousel.delegate = self
        // Do any additional setup after loading the view.
         carousel.type = .CoverFlow2
        carousel.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int
    {
        return images.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView
    {
        var label: UILabel
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
 //           don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:250, height:150))
            itemView.image = images[index]
            itemView.contentMode = .Redraw
            
            label = UILabel(frame:itemView.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Left
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            //itemView.addSubview(label)
        }
        else
        {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView;
            label = itemView.viewWithTag(1) as! UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(images[index])"
        
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing)
        {
            return value * 1.1
        }
        return value
    }
    

    
//     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 5
//    }
//    
//     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
//        
//        // Configure the cell
//        
//        return cell
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
