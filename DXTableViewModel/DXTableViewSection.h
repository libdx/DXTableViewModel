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

@property (strong, nonatomic) UITableViewHeaderFooterView *headerView;
@property (strong, nonatomic) UITableViewHeaderFooterView *footerView;

@property (nonatomic) CGFloat headerHeight;
@property (nonatomic) CGFloat footerHeight;

@property (copy, nonatomic, readonly) NSArray *rows;

- (instancetype)initWithName:(NSString *)name;

/// @name Building section
#pragma mark Building section

- (NSIndexPath *)addRow:(DXTableViewRow *)row;
- (NSIndexPath *)insertRow:(DXTableViewRow *)row atIndex:(NSInteger)index;
- (NSIndexPath *)removeRow:(DXTableViewRow *)row;

/// @name Animated row manupulations

//- (void)insertRows:(NSArray *)rows

//- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
//- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
//- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
//- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_AVAILABLE_IOS(5_0);

// support UITableViewHeaderFooterView for iOS 6.0 and above

// @property (nonatomic, readonly) NSInteger sectionIndex;

@end
