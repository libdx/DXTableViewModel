//
//  DXTableViewSection.h
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewModel, DXTableViewRow;

/**
 `DXTableViewSection` represents section in table view.
 It encapsulates `DXTableViewRow` objects, data that being used to customize header and footer of section
 and methods for rows (cells) manipulations: adding, removing, reordering with animated counterparts.
 Each section object in model must have unique `sectionName`.
 */
@interface DXTableViewSection : NSObject

/// @name General methods and properties
#pragma mark - General methods and properties

/**
 Table view model object that owns this section object.
 */
@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;

/**
 Unique identifier of section within table view model.
 */
@property (copy, nonatomic) NSString *sectionName;

/**
 Number or row in this section object.
 */
@property (nonatomic, readonly) NSInteger numberOfRows;

/**
 An index number that identifies a section in table view model and table view.
 */
@property (nonatomic, readonly) NSInteger sectionIndex;

/**
 Array of `DXTableViewRow` objects
 */
@property (copy, nonatomic, readonly) NSArray *rows;

/**
 Designated initializer. Returns configured section object.
 @param name String identifier of section. Must be unique within one table view model.
 */
- (instancetype)initWithName:(NSString *)name;

/// @name Header and Footer support
#pragma mark - Header and Footer support

/**
 String to be displayed as title for the header of this section.
 */
@property (copy, nonatomic) NSString *headerTitle;

/**
 String to be displayed as title for the footer of this section.
 */
@property (copy, nonatomic) NSString *footerTitle;

/**
 View to be displayed as header of this section
 */
@property (nonatomic, readonly) UIView *headerView;

/**
 View to be displayed as footer of this section
 */
@property (nonatomic, readonly) UIView *footerView;

/**
 Height to use for the header of this section. Default is `UITableViewAutomaticDimension`.
 */
@property (nonatomic) CGFloat headerHeight;

/**
 Height to use for the footer of this section. Default is `UITableViewAutomaticDimension`.
 */
@property (nonatomic) CGFloat footerHeight;

/**
 Reuse identifier to be used for the header view of this section in case header view is kind of class
 `UITableViewHeaderFooterView`. Ignored otherwise. Default is nil.
 */
@property (copy, nonatomic) NSString *headerReuseIdentifier;

/**
 Reuse identifier to be used for the footer view of this section in case footer view is kind of class
 `UITableViewHeaderFooterView`. Ignored otherwise. Default is nil.
 */
@property (copy, nonatomic) NSString *footerReuseIdentifier;

/**
 Class to be registered for header view of this section. Must be subclass of `UIView`. Default is nil.
 */
@property (unsafe_unretained, nonatomic) Class headerClass;

/**
 Class to be registered for footer view of this section. Must be subclass of `UIView`. Default is nil.
 */
@property (unsafe_unretained, nonatomic) Class footerClass;

/**
 Nib object to be registered for header view of this section. Default is nil.
 */
@property (strong, nonatomic) UINib *headerNib;

/**
 Nib object ot be registered for footer view of this section. Default is nil.
 */
@property (strong, nonatomic) UINib *footerNib;

@property (copy, nonatomic) UIView *(^viewForHeaderInSectionBlock)(DXTableViewSection *section);
@property (copy, nonatomic) UIView *(^viewForFooterInSectionBlock)(DXTableViewSection *section);

/**
 Block object to be invoked on table view delegate method `tableView:willDisplayHeaderView:forSection:`
 which tells that header about to be displayed. Takes two parameters: this section object and header view. Default is nil.
 */
@property (copy, nonatomic) void (^willDisplayHeaderViewBlock)(DXTableViewSection *section, UIView *view);

/**
 Block object to be invoked on table view delegate method  `tableView:willDisplayFooterView:forSection:`
 which tells that footer about to be displayed. Takes two parameters: this section object and footer view. Default is nil.
 */
@property (copy, nonatomic) void (^willDisplayFooterViewBlock)(DXTableViewSection *section, UIView *view);

// convenience header-footer configuration methods

@property (copy, nonatomic) void (^configureHeaderBlock)(DXTableViewSection *section, id headerView);
@property (copy, nonatomic) void (^configureFooterBlock)(DXTableViewSection *section, id headerView);

#pragma mark - Header and Footer subclass hooks

- (void)configureHeader;
- (void)configureFooter;

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
- (NSArray *)moveRow:(DXTableViewRow *)row toIndexPath:(NSIndexPath *)destinationIndexPath;

/// @name Animated row manupulations
#pragma mark Animated row manupulations

- (void)insertRows:(NSArray *)rows afterRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRows:(NSArray *)rows beforeRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;
- (void)moveRow:(DXTableViewRow *)row animatedToIndexPath:(NSIndexPath *)destinationIndexPath withRowAnimation:(UITableViewRowAnimation)animation;

@end
