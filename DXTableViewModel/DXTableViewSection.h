//
//  DXTableViewSection.h
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewModel, DXTableViewRow;

@interface DXTableViewSection : NSObject

@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;

@property (copy, nonatomic) NSString *sectionName; // sectionIdentifier

@property (nonatomic) NSInteger numberOfRows;

@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) NSString *footerTitle;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;

@property (copy, nonatomic, readonly) NSArray *rows;

- (void)addRow:(DXTableViewRow *)row;

// support UITableViewHeaderFooterView for iOS 6.0 and above

// @property (nonatomic, readonly) NSInteger sectionIndex;

@end
