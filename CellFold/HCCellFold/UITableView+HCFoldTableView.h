//
//  UITableView+HCFoldTableView.h
//  scrolltest
//
//  Created by Simon Andersson on 9/20/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HCFoldTableView) <UIScrollViewDelegate>
@property (nonatomic, readwrite) UIColor *shadingColor;
@end
