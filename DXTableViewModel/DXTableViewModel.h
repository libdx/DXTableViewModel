//
//  DXTableViewModel.h
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewSection, DXTableViewRow;

@interface DXTableViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *sections;

@property (copy, nonatomic) NSArray *(^sectionIndexTitles)();

// @property (copy, nonatomic) DXTableViewSection *(^sectionForSectionIndexTitleAtIndex)(NSString *title, NSInteger index);

@property (copy, nonatomic) void (^moveRowToIndexPathBlock)(DXTableViewRow *row, NSIndexPath *indexPath);
@property (copy, nonatomic) NSIndexPath *(^targetIndexPathForMoveFromRowToProposedIndexPath)(DXTableViewRow *row, NSIndexPath *indexPath);

/// @name Model building.
#pragma mark - Model building

- (void)addSection:(DXTableViewSection *)section;
- (void)insertSection:(DXTableViewSection *)section atIndex:(NSInteger)index;
- (void)removeSection:(DXTableViewSection *)section;

- (DXTableViewSection *)sectionWithName:(NSString *)name;
- (NSInteger)indexOfSectionWithName:(NSString *)name;

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

/// @name Data binding
#pragma mark - Data binding

- (void)updateBoundObjectsFromCellsValues;

@end

#import "DXTableViewSection.h"
#import "DXTableViewRow.h"
