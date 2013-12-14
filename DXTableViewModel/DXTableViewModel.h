//
//  DXTableViewModel.h
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewSection, DXTableViewRow;

/**
 `DXTableViewModel` represents data for table view. Essentially it is table view's delegate and datasource
 which customizes table view according to data that being provided by section and row objects.
 */
@interface DXTableViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

/// @name General methods and properties
#pragma mark - General methods and properties

/**
 An table view object to be configured by receiver.
 
 Setter sets data source and delegate properties of given table view to the receiver.
 */
@property (strong, nonatomic) UITableView *tableView;

/**
 Array of inserted section objects
 */
@property (copy, nonatomic) NSArray *sections;

/**
 Block object to be invoked on table view data source method `tableView:sectionIndexTitlesForTableView:`
 which asks the datasource to return titles for a sections. Takes no parameters. Result of block invocation is used
 as result of data source method.
 
 @see sectionForSectionIndexTitleAtIndexBlock
 */
@property (copy, nonatomic) NSArray *(^sectionIndexTitlesBlock)();

/**
 Block object to be invoked on table view data source method `tableView:sectionForSectionIndexTitle:`
 which asks data source to return corresponding index of the section. Takes two parameters:
 `title` - the title of the section index, `index` - an index number of the section title. Result of block invocation
 is used as result of data source method.
 Block won't be invoked unless [DXTableViewModel sectionIndexTitlesBlock] is provided.
 
 @see sectionIndexTitlesBlock
 */
@property (copy, nonatomic) NSInteger (^sectionForSectionIndexTitleAtIndexBlock)(NSString *title, NSInteger index);

/**
 Block object to be invoked on table view data source method `tableView:moveRowAtIndexPath:toIndexPath:`
 which tells data source to move row at the given position to another position. Takes two parameters:
 `row` - row object that represents row in table view to be moved, `indexPath` - index path object that represents
 new position for the row.
 
 Default implementation of data source method `tableView:moveRowAtIndexPath:toIndexPath:` moves row deleting it from
 receiver's contents and inserting it again at the new position represented by the given `destinationIndexPath`.
 This block gives you ability to perform any additional actions (e.g. make appropriate manipulations with model).
 */
@property (copy, nonatomic) void (^moveRowToIndexPathBlock)(DXTableViewRow *row, NSIndexPath *indexPath);

/**
 Block object to be invoked on table view delegate method `tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:`
 which asks delegate to return new index path to retarget row's move to the another position. Takes two parameters:
 `row` - row object that represents row in table view, `indexPath` - index path object that represents proposed position.
 The result of the block will be used as the result of the delegate method.
 */
@property (copy, nonatomic) NSIndexPath *(^targetIndexPathForMoveFromRowToProposedIndexPath)(DXTableViewRow *row, NSIndexPath *indexPath);

/**
 Block object to be invoked on table view delegate method `tableView:didEndDisplayingCell:forRowAtIndexPath:`
 which tells delegate that given cell was removed from table view.
 Takes three parameters: `tableViewModel` - table view model object (the receiver is passed as `tableViewModel` parameter),
 `cell` - cell object that was removed from table view, `indexPath` - index path object that represets position of removed cell.
 */
@property (copy, nonatomic) void (^didEndDisplayingCellBlock)(DXTableViewModel *tableViewModel, id cell, NSIndexPath *indexPath);

/**
 Block object to be invoked on table view delegate method `tableView:didEndDisplayingHeaderView:forSection:`
 which tells delegate that given header view was removed from table view.
 Takes three parameters: `tableViewModel` - table view model object (the receiver is passed as `tableViewModel` parameter),
 `view` - view that was removed from table view, `index` - index that represents position of removed header.
 */
@property (copy, nonatomic) void (^didEndDisplayingHeaderViewBlock)(DXTableViewModel *tableViewModel, UIView *view, NSInteger index);

/**
 Block object to be invoked on table view delegate method `tableView:didEndDisplayingHeaderView:forSection:`
 which tells delegate that given footer view was removed from table view.
 Takes three parameters: `tableViewModel` - table view model object (the receiver is passed as `tableViewModel` parameter),
 `view` - view that was removed from table view, `index` - index that represents position of removed footer.
 */
@property (copy, nonatomic) void (^didEndDisplayingFooterViewBlock)(DXTableViewModel *tableViewModel, UIView *view, NSInteger index);

/**
 Boolean value that indicates should table view show default title for confirmation button or not. Default is YES.
 
 If set to NO delete confirmation button will have empty title, so you need to provide localized titles for each row
 via [DXTableViewRow titleForDeleteConfirmationButton].
 */
@property (nonatomic) BOOL showsDefaultTitleForDeleteConfirmationButton;

/**
 Designated initializer. Returns configured table view model object.
 
 @param tableView A table view object to be configured by the receiver.
 
 This method sets data source and delegate properties of given `tableView` to the receiver.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/// @name Model building.
#pragma mark - Model building

/**
 Inserts section object at the end of receiver's contents.
 
 @param section A section object to be inserted into the model.
 */
- (void)addSection:(DXTableViewSection *)section;

/**
 Inserts section object at the given `index` into the receiver's contents.
 
 @param section A section object to be inserted into the model. Raises NSInvalidArgumentException if `section` is nil.
 
 @param index The index in the receiver's content at which to insert `section` object.
 This values must not be greater that number of section in the contents. Raises NSRangeException if `index` is greater
 that number of section in the contents.
 */
- (void)insertSection:(DXTableViewSection *)section atIndex:(NSInteger)index;

/**
 Removes section object from the receiver's contents.
 
 @param section A section object to be removed from contents.
 */
- (void)removeSection:(DXTableViewSection *)section;

/**
 Returns section object with given `name` from the receiver's contents.
 
 @param name Unique whithin the receiver's contents section name.
 */
- (DXTableViewSection *)sectionWithName:(NSString *)name;

/**
 Returns `index` in receiver's contents of the section object with given `name`. If section with given name doesn't not
 exists returns NSNotFound.

 @param name Unique whithin the receiver's contents section name.
 */
- (NSInteger)indexOfSectionWithName:(NSString *)name;

/// @name Model building convenience methods
#pragma mark - Model building convenience methods

/**
 Inserts section objects from given `sections` array at the end of the receiver's contents.
 
 @param sections An array containing section objects.
 */
- (void)addSections:(NSArray *)sections;

/// @name Not animated sections manipulations
#pragma mark - Not animated sections manipulations

/**
 Inserts `newSection` object into the receiver's contents on the next position after section with given `name`.
 
 @param newSection A section object to be inserted into the contents.
 
 @param name Unique within the receiver's contents section name.
 */
- (NSInteger)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name;

/**
 Inserts `newSection` object into the receiver's contents on the previous position before section with given `name`

 @param newSection A section object to be inserted into the contents.
 
 @param name Unique within the receiver's contents section name.
 */
- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name;

/**
 Deletes section object with given `name` from the receiver's contents.

 @param name Unique within the receiver's contents section name.
 */
- (NSInteger)deleteSectionWithName:(NSString *)name;

/**
 Moves section with given `name` on the position that was occupied by section with given `destinationName`.

 @param name Unique within the receiver's contents section name that refers to section object to be moved.

 @param destinationName Unique within the receiver's contents section name that refers to section object to be shifted
 on one position up or down.
 
 First section object with the given `name` will be removed and inserted at the new position that was occupied by second
 section object with the given `destinationName`, which in its turn will be shifted on one position up or down depending
 on initial position of first section.
 */
- (NSIndexSet *)moveSectionWithName:(NSString *)name toSectionWithName:(NSString *)destinationName;

/// @name Animated sections manipulations
#pragma mark - Animated sections manipulations

/**
 Begins series of method calls that manipulates sections with animation. Calls table view's beginUpdates method.
 
 @see endUpdates
 */
- (void)beginUpdates;

/**
 Ends series of method calls that manipulates sections with animation. Calls table view's endUpdates method.
 
 @see beginUpdates
 */
- (void)endUpdates;

/**
 Inserts `newSection` object into receiver's contents after section with `name` and appropriate section into table view 
 with given `animation`.
 
 @param newSections Section object to be inserted into receivers contents.
 @param name Name of already inserted into contents section object.
 @param animation Animation type to be used for inserting new section into the table view managed by the receiver.
 */
- (void)insertSections:(NSArray *)newSections
 afterSectionWithName:(NSString *)name
     withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Inserts `newSection` object into receiver's contents before section with `name` and appropriate section into table view
 with given `animation`.

 @param newSections Section object to be inserted into receivers contents.
 @param name Name of already inserted into contents section object.
 @param animation Animation type to be used for inserting new section into the table view managed by the receiver.
 */
- (void)insertSections:(NSArray *)newSections
beforeSectionWithName:(NSString *)name
     withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Deletes section objects with given `names` from receiver's contents with deleting appropriate sections from table view.
 
 @param names An array of strings that represents names of existed in receiver's contents section objects.
 @param animation Animation type to be used for deleting sections from the table view managed by the receiver.
 */
- (void)deleteSectionsWithNames:(NSArray *)names
             withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Reload specified sections with given `names` using provided animation.
 
 @param names An array of section names (strings) that exist in receiver's contents.
 */
- (void)reloadSectionsWithNames:(NSArray *)names withRowAnimation:(UITableViewRowAnimation)animation;

/**
 Moves section with given `name` on position of section with `otherName` calling `moveSectionWithName:toSectionWithName:`
 method.
 
 @param name Name of the section to be moved. Sectionm must be already exists in receiver's contents.
 
 @param otherName Name of the section to be shifted on one position up or down depending on mutual positioning of
 involved sections.
 */
- (void)moveSectionWithName:(NSString *)name animatedToSectionWithName:(NSString *)otherName;

/// @name Data binding capabilities
#pragma mark - Data binding capabilities

/**
 Reloads data from boud object for each row.
 */
- (void)reloadRowBoundData;

/**
 Updates bound object of each row.
 */
- (void)updateRowObjects;

@end

#import "DXTableViewSection.h"
#import "DXTableViewRow.h"
