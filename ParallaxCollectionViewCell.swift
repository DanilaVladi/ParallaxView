//
//  ParallaxCollectionViewCell.swift
//  Vladimir Danila
//
//  Created by Vladimir Danila on 1/21/16.
//  Copyright © 2016 Vladimir Danila. All rights reserved.
//

import UIKit
import Foundation

let CellFocusHeight: CGFloat = 240.0
let CellCompactHeight: CGFloat = 88.0
let TextPadding: CGFloat = 20.0

let MenuCompactImageCoverAlpha: CGFloat = 0.5
let MenuFocusedImageCoverAlpha: CGFloat = 0.2


class ParallaxCollectionViewCell: UICollectionViewCell {
    
    let textLabel: UILabel = UILabel()
    let detailTextLabel: UILabel = UILabel()
    
    let backgroundImageView: UIImageView = UIImageView()
    let imageCover: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.setupTextLabel()
        self.setupDetailLabel()
        self.setupImageView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Label and ImageView setups
    
    func setupTextLabel() {
        let screenRect = self.contentView.frame
        textLabel.frame = CGRectMake(0, 0, screenRect.size.width, self.contentView.frame.size.height)
        textLabel.center = self.contentView.center
        textLabel.font = UIFont.boldSystemFontOfSize(32)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Center
        self.contentView.addSubview(textLabel)
    }
    
    
    func setupDetailLabel() {
        let screenRect = self.contentView.frame
        let startY = textLabel.frame.origin.y + textLabel.frame.size.height - 40
        detailTextLabel.frame = CGRectMake(TextPadding, startY, screenRect.size.width - (TextPadding * 2), self.contentView.frame.size.height - startY)
        detailTextLabel.lineBreakMode = .ByWordWrapping
        detailTextLabel.numberOfLines = 0
        detailTextLabel.font = UIFont.boldSystemFontOfSize(12)
        detailTextLabel.textColor = UIColor.whiteColor()
        detailTextLabel.textAlignment = .Center
        self.contentView.addSubview(detailTextLabel)
    }
    
    func setupImageView() {
        let screenRect = self.contentView.frame
        backgroundImageView.frame = CGRectMake(0, 0, screenRect.size.width, CellFocusHeight)
        backgroundImageView.clipsToBounds = true
        backgroundImageView.center = self.contentView.center
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin]
        
        // Add a cover taht we can fade in a black tint
        imageCover.frame = backgroundImageView.frame
        imageCover.backgroundColor = UIColor.blackColor()
        imageCover.alpha = 0.6
        imageCover.autoresizingMask = self.backgroundImageView.autoresizingMask
        backgroundImageView.addSubview(imageCover)
        self.contentView.insertSubview(backgroundImageView, atIndex: 0)
        self.contentView.insertSubview(imageCover, atIndex: 1)
    }
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        
        super.applyLayoutAttributes(layoutAttributes)
        
        let focusNormaHeightDifference: CGFloat = CellFocusHeight - CellCompactHeight
        
        // How much its grown from normal to feature
        let amountGrown: CGFloat = CellFocusHeight - self.frame.size.height
        
        // Percent of growth from compact to focus
        var percentOfGrowth: CGFloat = 1 - (amountGrown / focusNormaHeightDifference)
        
        // Curve the percent so that the animation move smoother
        percentOfGrowth = sin(percentOfGrowth * CGFloat(M_PI_2))
        
        let scaleAndAlpha: CGFloat = max(percentOfGrowth, 0.5)
    
        // Scale title as it collapses but keep origin x the same and the y location proportional to view height.  Also fade in alpha
        textLabel.transform = CGAffineTransformMakeScale(scaleAndAlpha, scaleAndAlpha)
        textLabel.center = self.contentView.center
        
        // keep detail just under text label
        detailTextLabel.center = CGPointMake(self.center.x, textLabel.center.y + 40)
        
        // Its convenient to set the alpha of the fading controls to the percent of growth value
        detailTextLabel.alpha = percentOfGrowth

        // When focused, alpha of imageCover should be 20%, when collapsed should be 90%
        imageCover.alpha = MenuCompactImageCoverAlpha - (percentOfGrowth * MenuCompactImageCoverAlpha - MenuFocusedImageCoverAlpha)
    }
    
}
