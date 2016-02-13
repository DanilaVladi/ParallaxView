//
//  ParallaxCollectionViewController.swift
//  Vladimir Danila
//
//  Created by Vladimir Danila on 1/21/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


/**
 ParallaxCollectionViewController is a subclass of UICollectionViewController that is supplies methods that can be overridden to supply the number of items in the menu, customize the menu cell and also to react to a menu item being tapped.
 */
class ParallaxCollectionViewController: UICollectionViewController, ParallaxLayoutDelegate {

    
    var focusedHeight: CGFloat?
    var compactHeight: CGFloat?
    
    var scrollsToCompactRowsOnSelection: Bool?
    
    var itemsInParallaxView: Int?
    
    
    
    convenience init() {
        self.init()
        
        focusedHeight = CellFocusHeight
        compactHeight = CellCompactHeight
        scrollsToCompactRowsOnSelection = true
    }
    
    override func awakeFromNib() {
        self.focusedHeight = CellFocusHeight
        self.compactHeight = CellCompactHeight
        self.scrollsToCompactRowsOnSelection = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.collectionViewLayout = ParallaxLayout(withDelegate: self)
        
        // Register cell classes
        self.collectionView!.registerClass(ParallaxCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Don't have it scroll content below nav bar and status bar
        if self.respondsToSelector(Selector("setAutomaticallyAdjustsScrollViewInsets:")) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Overridables
    
    func numberOfItemsInParallaxView() -> Int {
        return 0
    }
    
    func customizeCell(cell parallaxCell: ParallaxCollectionViewCell, forRow row: Int) {
        
    }
    
    func parallaxView(slidingView: ParallaxCollectionViewController, didSelectItemAtRow row: Int) {
        if (scrollsToCompactRowsOnSelection != nil) {
           scroll(toRow: row, animate: true)
        }
    }
    
    func scroll(toRow row: NSInteger, animate animated: Bool) {
        
        let rowOffset = NSInteger(CellDragInterval) * row
        
        // Do not need to flip to that row if already on it
        if self.collectionView?.contentOffset.y == CGFloat(rowOffset) {
            return
        }
        
        // Show the category they picked
        self.collectionView?.setContentOffset(CGPointMake(0, CGFloat(rowOffset)), animated: animated)
        
    }
    

    
    // MARK: - ParallaxLayoutDelegate
    
    func heightForFocusedCell() -> CGFloat {
        return self.focusedHeight!
    }
    
    func heightForCompactCell() -> CGFloat {
        return self.compactHeight!
    }

    
    

    // MARK: UICollectionViewDataSource Methods

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInParallaxView()
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ParallaxCollectionViewCell
        
        if indexPath.item % 2 == 0 {
            cell.textLabel.text = "Something Special"
            cell.detailTextLabel.text = "For your loved ones!"
            cell.backgroundImageView.image = UIImage(named: "image1_320x210")
        }
        else {
            cell.textLabel.text = "This Thing Too"
            cell.detailTextLabel.text = "This thing will blow your mind."
            cell.backgroundImageView.image = UIImage(named: "image2_320x210")
        }
        
        self.customizeCell(cell: cell, forRow: indexPath.row)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.parallaxView(self, didSelectItemAtRow: indexPath.row)
    }
    

}
