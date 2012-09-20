//
//  UITableView+HCFoldTableView.m
//  scrolltest
//
//  Created by Simon Andersson on 9/20/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import "UITableView+HCFoldTableView.h"
#import <QuartzCore/QuartzCore.h>

// Shading tag
#define kHCShadingViewTag 0xff66

// Clamp values between min and max
#define clamp(min, max, value) (MIN(max, MAX(min, value)))

/**
 * Anchor Point 
 * Sets the anchor point for a layer and properly resets the position.
 */

@interface UIView (AnchorPoint)
- (void)setAnchorPoint:(CGPoint)anchorPoint;
@end

@implementation UIView (AnchorPoint)

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

@end

@interface UITableView (Extend)
- (id)shaderForView:(UITableViewCell *)view;
@end


@implementation UITableView (HCFoldTableView)
@dynamic shadingColor;

- (id)shaderForView:(UITableViewCell *)view {
    
    UIView *shading = [view viewWithTag:kHCShadingViewTag];
    if (!shading) {
        shading = [[UIView alloc] init];
        shading.backgroundColor = self.shadingColor;
        shading.tag = kHCShadingViewTag;
        [view.contentView addSubview:shading];
    }
    shading.frame = view.bounds;
    
    return shading;
}

static UIColor *SHADER_COLOR = nil;

- (void)setShadingColor:(UIColor *)shadingColor {
    SHADER_COLOR = shadingColor;
}

- (UIColor *)shadingColor {
    if (!SHADER_COLOR) {
        SHADER_COLOR = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return SHADER_COLOR;
}

- (CATransform3D)rotationTransform:(float)progress angle:(float)angle {
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -1000;
    transform = CATransform3DRotate(transform, M_PI_2*progress, angle, 0, 0);
    
    return transform;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray *visibleCells = [self visibleCells];
    
    float offset = scrollView.contentOffset.y;
    
    [visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITableViewCell *cell = obj;
        
        // Resets the transform
        cell.layer.transform = CATransform3DIdentity;
        
        // Gets the height of the cell
        float cellHeight = cell.bounds.size.height;
        
        // Gets progress between 0-1
        float progress = clamp(0, 1, (offset-cell.frame.origin.y) / cellHeight);
        
        // Gets reference for shading and sets alpha
        UIView *shading = [self shaderForView:cell];
        shading.alpha = progress;
        
        // Sets the anchor point to bottom - center
        [cell setAnchorPoint:CGPointMake(0.5, 1)];
        
        cell.layer.transform = [self rotationTransform:progress angle:1];
        
        
        // Reverse rotation for the last cell
        UITableViewCell *lastCell = [visibleCells lastObject];
        if (obj == lastCell) {
            
            // Gets the height of the last cell
            cellHeight = lastCell.bounds.size.height;
            
            // Reverses progress to 1-0
            progress = 1.0-clamp(0, 1, ((offset + self.bounds.size.height) - lastCell.frame.origin.y) / cellHeight);
            
            // Gets reference for shading and sets alpha
            UIView *shading = [self shaderForView:lastCell];
            shading.alpha = progress;
            
            // Sets the anchor point to top - center
            [lastCell setAnchorPoint:CGPointMake(0.5, 0)];
            
            // Applies the perspective and rotation
            lastCell.layer.transform = [self rotationTransform:progress angle:-1];
        }
    }];
    
    
}

@end
