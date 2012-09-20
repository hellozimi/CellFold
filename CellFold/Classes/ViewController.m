//
//  ViewController.m
//  scrolltest
//
//  Created by Simon Andersson on 9/12/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+HCFoldTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self scrollViewDidScroll:self.tableView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDataSource Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Changes the cell height for every even cell
    return indexPath.row % 2 == 0 ? 100 : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    
    // Sets content in cell
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %i", indexPath.row + 1];
    cell.layer.transform = CATransform3DIdentity;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Implementation

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Makes it work
    [self.tableView scrollViewDidScroll:scrollView];
}

@end
