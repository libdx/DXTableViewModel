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

@property (nonatomic, readonly) NSInteger numberOfRows;

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

- (DXTableViewRow *)nextRowWithIdentifier:(NSString *)identifier greaterRowIndexThan:(NSInteger)index;

// same as nextRowWithIdentifier:greaterThanRowIndex: where index = 0
- (DXTableViewRow *)rowWithIdentifier:(NSString *)identifier;

- (NSIndexPath *)addRow:(DXTableViewRow *)row;
- (NSIndexPath *)insertRow:(DXTableViewRow *)row atIndex:(NSInteger)index;
- (NSIndexPath *)removeRow:(DXTableViewRow *)row;

- (NSIndexPath *)insertRow:(DXTableViewRow *)row afterRow:(DXTableViewRow *)otherRow;
- (NSIndexPath *)insertRow:(DXTableViewRow *)row beforeRow:(DXTableViewRow *)otherRow;
- (NSArray *)moveRow:(DXTableViewRow *)row toRow:(DXTableViewRow *)destinationRow;

/// @name Animated row manupulations

- (void)insertRows:(NSArray *)rows afterRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRows:(NSArray *)rows beforeRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)moveRow:(DXTableViewRow *)row animatedToRow:(DXTableViewRow *)destinationRow withRowAnimation:(UITableViewRowAnimation)animation;

// @property (nonatomic, readonly) NSInteger sectionIndex;

@end
