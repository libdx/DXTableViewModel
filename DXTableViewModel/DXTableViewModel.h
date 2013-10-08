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
 `DXTableViewModel` represents data for table view. Essentially it is table view's delegate and data source
 which customizes table view according to data that being provided by section and row objects.
 */
@interface DXTableViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

/// @name General methods and properties
#pragma mark - General methods and properties

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *sections;

@property (copy, nonatomic) NSArray *(^sectionIndexTitlesBlock)();

@property (copy, nonatomic) NSInteger (^sectionForSectionIndexTitleAtIndexBlock)(NSString *title, NSInteger index);

@property (copy, nonatomic) void (^moveRowToIndexPathBlock)(DXTableViewRow *row, NSIndexPath *indexPath);
@property (copy, nonatomic) NSIndexPath *(^targetIndexPathForMoveFromRowToProposedIndexPath)(DXTableViewRow *row, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^didEndDisplayingCellBlock)(DXTableViewModel *tableViewModel, id cell, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^didEndDisplayingHeaderViewBlock)(DXTableViewModel *tableViewModel, UIView *view, NSInteger index);
@property (copy, nonatomic) void (^didEndDisplayingFooterViewBlock)(DXTableViewModel *tableViewModel, UIView *view, NSInteger index);

// default is YES
@property (nonatomic) BOOL showsDefaultTitleForDeleteConfirmationButton;

/// @name Model building.
#pragma mark - Model building

- (void)addSection:(DXTableViewSection *)section;
- (void)insertSection:(DXTableViewSection *)section atIndex:(NSInteger)index;
- (void)removeSection:(DXTableViewSection *)section;

- (DXTableViewSection *)sectionWithName:(NSString *)name;
- (NSInteger)indexOfSectionWithName:(NSString *)name;

/// @name Not animated sections manipulations
#pragma mark - Not animated sections manipulations

- (NSInteger)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name;
- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name;
- (NSInteger)deleteSectionWithName:(NSString *)name;
- (NSIndexSet *)moveSectionWithName:(NSString *)name toSectionWithName:(NSString *)destinationName;

/// @name Animated sections manipulations
#pragma mark - Animated sections manipulations

- (void)beginUpdates;
- (void)endUpdates;

- (void)insertSections:(NSArray *)newSections
 afterSectionWithName:(NSString *)name
     withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertSections:(NSArray *)newSections
beforeSectionWithName:(NSString *)name
     withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSectionsWithNames:(NSArray *)names
             withRowAnimation:(UITableViewRowAnimation)animation;

- (void)moveSectionWithName:(NSString *)name animatedToSectionWithName:(NSString *)otherName;

/// @name Data binding capabilities
#pragma mark - Data binding capabilities

- (void)updateRowBoundData;
- (void)updateRowObjects;

@end

#import "DXTableViewSection.h"
#import "DXTableViewRow.h"
