//
//  ParallaxLayout.swift
//  Vladimir Danila
//
//  Created by Vladimir Danila on 1/21/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit

protocol ParallaxLayoutDelegate {
    func heightForFocusedCell() -> CGFloat
    func heightForCompactCell() -> CGFloat
}

let CellDragInterval: CGFloat = 180


class ParallaxLayout: UICollectionViewLayout {

    var delegate: ParallaxLayoutDelegate!
    var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    
    convenience init(withDelegate delegate: ParallaxLayoutDelegate) {
        self.init()
        
        self.delegate = delegate

    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let screenWidth = self.collectionView!.frame.size.width
        let topFocusIndex = Int(currentCellIndex())
        
        let topCellsInterpolation = currentCellIndex() - CGFloat(topFocusIndex)
        
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        var indexPath: NSIndexPath?
        
        // Last rect will be used to calculate frames past the first one.  We initialize it to a non junk 0 value
        var lastRect = CGRectMake(0, 0, screenWidth, CellCompactHeight)
        let numItems: Int = self.collectionView!.numberOfItemsInSection(0)
        
        let expandedHeight = focusHeight()
        let littleHeight = compactHeight()
        
        
        for itemIndex in 0...numItems - 1 {
            indexPath = NSIndexPath(forItem: itemIndex, inSection: 0)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath!)
            attributes.zIndex = itemIndex
            var yValue: CGFloat = 0
            
            if indexPath?.row == Int(topFocusIndex) {
                // Our top focused cell
                let yOffset = littleHeight * topCellsInterpolation
                let yValue = (self.collectionView?.contentOffset.y)! - yOffset
                attributes.frame = CGRectMake(0, yValue, screenWidth, expandedHeight)
            }
            else if (indexPath?.row)! == (topFocusIndex + 1) && (indexPath?.row)! != numItems {
                // The cell after the focused which frows into one as it goes up unless its the last cell (back to top)
                yValue = lastRect.origin.y + lastRect.size.height
                let bottomYValue = CGFloat(yValue) + littleHeight
                let ammountToGrow = max((expandedHeight - littleHeight) * topCellsInterpolation, 0)
                let newHeight = littleHeight + ammountToGrow
                attributes.frame = CGRectMake(0, bottomYValue - newHeight, screenWidth, newHeight)
            }
            else {
                // All other cells above or below those on screen
                yValue = lastRect.origin.y + lastRect.size.height
                attributes.frame = CGRectMake(0, yValue, screenWidth, littleHeight)
            }
            
            lastRect = attributes.frame
            layoutAttributes.insert(attributes, atIndex: itemIndex)
            
        }
        
        
        self.layoutAttributes = layoutAttributes
    }

    
    func currentCellIndex() -> CGFloat {
        return self.collectionView!.contentOffset.y / CellDragInterval
    }
    
    func focusHeight() -> CGFloat {
        return delegate.heightForFocusedCell()
    }
    
    func compactHeight() -> CGFloat {
        return delegate.heightForCompactCell()
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        let numberOfItems: CGFloat = CGFloat(self.collectionView!.numberOfItemsInSection(0))
        let height = (numberOfItems * CellDragInterval) + (self.collectionView!.frame.size.height - CellDragInterval)
        return CGSizeMake(self.collectionView!.frame.size.width, height)
    }
    
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesInRect: [UICollectionViewLayoutAttributes] = []
        for (_, attributes) in layoutAttributes.enumerate() {
            if CGRectIntersectsRect(rect, attributes.frame) {
                attributesInRect.append(attributes)
            }
        }
        
        return attributesInRect
    }
    
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedPageIndex: CGFloat = ceil(proposedContentOffset.y / CellDragInterval)
        let nearestPageOffset = CGFloat(proposedPageIndex) * CellDragInterval
        
        return CGPointMake(0, nearestPageOffset)
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    // Bounds change causes prepareLayout if ture 
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}
