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
 Table view model object that owns receiver.
 */
@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;

/**
 Unique identifier of section within table view model.
 */
@property (copy, nonatomic) NSString *sectionName;

/**
 Number or row in receiver.
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
 String to be displayed as title for the header of receiver.
 */
@property (copy, nonatomic) NSString *headerTitle;

/**
 String to be displayed as title for the footer of receiver.
 */
@property (copy, nonatomic) NSString *footerTitle;

/**
 View to be displayed as header of receiver
 */
@property (nonatomic, readonly) UIView *headerView;

/**
 View to be displayed as footer of receiver
 */
@property (nonatomic, readonly) UIView *footerView;

/**
 Height to use for the header of receiver. Default is `UITableViewAutomaticDimension`.
 */
@property (nonatomic) CGFloat headerHeight;

/**
 Height to use for the footer of receiver. Default is `UITableViewAutomaticDimension`.
 */
@property (nonatomic) CGFloat footerHeight;

/**
 Reuse identifier to be used for the header view of receiver in case header view is kind of class
 `UITableViewHeaderFooterView`. Ignored otherwise. Default is nil.
 */
@property (copy, nonatomic) NSString *headerReuseIdentifier;

/**
 Reuse identifier to be used for the footer view of receiver in case footer view is kind of class
 `UITableViewHeaderFooterView`. Ignored otherwise. Default is nil.
 */
@property (copy, nonatomic) NSString *footerReuseIdentifier;

/**
 Class to be registered for header view of receiver. Must be subclass of `UIView`. Default is nil.
 */
@property (unsafe_unretained, nonatomic) Class headerClass;

/**
 Class to be registered for footer view of receiver. Must be subclass of `UIView`. Default is nil.
 */
@property (unsafe_unretained, nonatomic) Class footerClass;

/**
 Nib object to be registered for header view of receiver. Default is nil.
 */
@property (strong, nonatomic) UINib *headerNib;

/**
 Nib object ot be registered for footer view of receiver. Default is nil.
 */
@property (strong, nonatomic) UINib *footerNib;

@property (copy, nonatomic) UIView *(^viewForHeaderInSectionBlock)(DXTableViewSection *section);
@property (copy, nonatomic) UIView *(^viewForFooterInSectionBlock)(DXTableViewSection *section);

/**
 Block object to be invoked on table view delegate method `tableView:willDisplayHeaderView:forSection:`
 which tells that header about to be displayed. Takes two parameters: receiver and header view. Default is nil.
 */
@property (copy, nonatomic) void (^willDisplayHeaderViewBlock)(DXTableViewSection *section, UIView *view);

/**
 Block object to be invoked on table view delegate method  `tableView:willDisplayFooterView:forSection:`
 which tells that footer about to be displayed. Takes two parameters: receiver and footer view. Default is nil.
 */
@property (copy, nonatomic) void (^willDisplayFooterViewBlock)(DXTableViewSection *section, UIView *view);

// convenience header-footer configuration methods

/**
 Block object that gives ability to configure section's header view before it will be displayed.

 To be invoked on table view delegate method `tableView:viewForHeaderInSection:`,
 which asks for view object to be displayed in header of receiver.
 Takes two parameters: section object and view object to be displayed as section's header.
 The receiver is passed as `section` parameter.
 `headerView` parameter is defined as `id` making it possible to substitue its type with appropriate `UIView` subclass.
 Default is nil.
 */
@property (copy, nonatomic) void (^configureHeaderBlock)(DXTableViewSection *section, id headerView);

/**
 Block object that gives ability to configure section's footer view before it will be displayed.

 To be invoked on table view delegate method `tableView:viewForFooterInSection:`,
 which asks for view object to be displayed in footer of receiver.
 Takes two parameters: section object and view object to be displayed as section's footer.
 The receiver is passed as `section` parameter.
 `footerView` parameter is defined as `id` making it possible to substitue its type with appropriate `UIView` subclass.
 Default is nil.
 */
@property (copy, nonatomic) void (^configureFooterBlock)(DXTableViewSection *section, id footerView);

#pragma mark - Header and Footer subclass hooks

/**
 Method that gives ability to configure section's header view before it will be displayed for subclasses.

 To be invoked on table view delegate method `tableView:viewForHeaderInSection:`,
 which asks for view object to be displayed in header of receiver. This method is called before `configureHeaderBlock`.
 You can access header view via `headerView` property.
 */
- (void)configureHeader;

/**
 Method that gives ability to configure section's footer view before it will be displayed for subclasses.

 To be invoked on table view delegate method `tableView:viewForFooterInSection:`,
 which asks for view object to be displayed in footer of receiver. This method is called before `configureFooterBlock`.
 You can access header view via `footerView` property.
 */
- (void)configureFooter;

/// @name Building section
#pragma mark Building section

/**
 Returns first `row` object with given `identifier` which is located at the greater row index than given `index`.
 Returns `nil` if appropriate object is not found.
 
 @param identifier Cell reuse identifier.
 @param index The index in the section's rows after which to search row with appropriate cell reuse identifier.
 */
- (DXTableViewRow *)nextRowWithIdentifier:(NSString *)identifier greaterRowIndexThan:(NSInteger)index;

/**
 Returns first `row` object with given `identifier`.
 Returns `nil` if appropriate object is not found.
 Same as `nextRowWithIdentifier:greaterRowIndexThan:` with `index` parameter equals 0.
 
 @param identifier Cell reuse identifier.
 */
- (DXTableViewRow *)rowWithIdentifier:(NSString *)identifier;

/**
 Inserts `row` object at the end of the section's rows contents and returns index path object that represents location
 of row in table view model and cell in table view. If section object is not inserted to model, section value of index path
 object is `NSNotFound`.
 @param row The row object to be inserted to section.
 */
- (NSIndexPath *)addRow:(DXTableViewRow *)row;

/**
 Inserts `row` object at the given `index` into the section's rows contents and returns index path object that represents location
 of row in table view model and cell in table view. If section object is not inserted to model, section value of index path
 object is `NSNotFound`.
 
 @param row The row object to be inserted to section. Raises an `NSInvalidArgumentException` if `row` is nil.

 @param index The index at which to insert `row` object. This value must not be greater than the number of rows in section.
 Raises an NSRangeException if index is greater than the number of elements in the array.
 */
- (NSIndexPath *)insertRow:(DXTableViewRow *)row atIndex:(NSInteger)index;

/**
 Removes given `row` object from section's rows contents and returns index path object that represents location
 of row in table view model and cell in table view. If section object is not inserted to model, section value of index path
 object is `NSNotFound`.
 @param row The row object to be removed from section.
 */
- (NSIndexPath *)removeRow:(DXTableViewRow *)row;

/**
 Inserts `row` object at the index next to `otherRow` object and returns index path object that represents location
 of row in table view model and cell in table view. If section object is not inserted to model, section value of index path
 object is `NSNotFound`.
 
 @param row The row object to be inserted in section.
 @param otherRow The row object. Must be already inserted into section and must not be `nil`.
 */
- (NSIndexPath *)insertRow:(DXTableViewRow *)row afterRow:(DXTableViewRow *)otherRow;

/**
 Inserts `row` object at the index previous to `otherRow` object and returns index path object that represents location 
 of row in table view model and cell in table view. If section object is not inserted to model, section value of index path
 object is `NSNotFound`.

 @param row The row object to be inserted in section.
 @param otherRow The row object to be shifted by adding 1 to its index. Must be already inserted into section and must be not `nil`.
 */
- (NSIndexPath *)insertRow:(DXTableViewRow *)row beforeRow:(DXTableViewRow *)otherRow;

/**
 Moves `row` object to the given `destinationIndexPath` and returns array containing `row`s index path at the first position
 and `destinationIndexPath` at the second position. If section object is not inserted to model, section value of both index path
 objects is `NSNotFound`.
 
 @param row The row object to be moved. Must be already inserted to section.
 @param destinationIndexPath Index path object that represents row that is destination of `row` object.
 */
- (NSArray *)moveRow:(DXTableViewRow *)row toIndexPath:(NSIndexPath *)destinationIndexPath;

/// @name Building section convenience methods
#pragma mark Building section convenience methods

/**
 Inserts `rows` objects at the end of the section's rows contents.
 @param rows An array of `DXTableViewRow` objects to be inserted to section.
 */
- (void)addRows:(NSArray *)rows;

/// @name Animated row manupulations
#pragma mark Animated row manupulations

/**
 Inserts `rows` objects starting at the index next to `otherRow` object to the receiver and appropriate cells to 
 the associated table view with an option to animate the insertion.

 @param rows An array of rows objects to be inserted in section.
 @param row The row object. Must be already inserted into section and must not be `nil`.
 @param animation A constant that specifies type of animation when performing cells insertion.
 */
- (void)insertRows:(NSArray *)rows afterRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Inserts `rows` objects in such way that last row appears at the index previous to `otherRow` object to the receiver and
 appropriate cells to the associated table view with an option to animate the insertion.

 @param rows An array of rows objects to be inserted in section.
 @param row The row object. Must be already inserted into section and must not be `nil`.
 @param animation A constant that specifies type of animation when performing cells insertion.
 */
- (void)insertRows:(NSArray *)rows beforeRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Removes given `rows` objects from receiver and appropriate cells from associated table view with an option to animate
 the deletion.
 
 @param rows An array of rows objects to be inserted in section.
 @param animation A constant that specifies type of animation when performing cells deletion.
 */
- (void)deleteRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Reloads given `rows` objects from receiver and appropriate cells from associated table view with an option to animate
 the reload.
 
 Reloading rows causes to invoke its blocks and methods involved into cell creation and configuration: `configureCell`,
 `willConfigureCell`, `didConfigureCell`, `cellForRowBlock`, `configureCellBlock`.

 @param rows An array of rows objects to be inserted in section.
 @param animation A constant that specifies type of animation when performing cells reload.
 */
- (void)reloadRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Moves `row` object to the specified location in the receiver and coresponding cell in the table view with default
 animation for move operation of table view.
 
 @param row The row object to be moved. Must be already inserted to section.
 @param destinationIndexPath Index path object that represents row that is destination of `row` object.
 */
- (void)moveRow:(DXTableViewRow *)row animatedToIndexPath:(NSIndexPath *)destinationIndexPath;

@end
