//
//  DXTableViewModel.h
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewSection;

@interface DXTableViewModel : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSArray *sections;

/// @name Model Building.

- (void)addSection:(DXTableViewSection *)section;
- (void)insertSection:(DXTableViewSection *)section atIndex:(NSInteger)index;
- (void)removeSection:(DXTableViewSection *)section;

- (DXTableViewSection *)sectionWithName:(NSString *)name;
- (NSInteger)indexForSectionWithName:(NSString *)name;

- (NSInteger)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name;
- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name;

- (NSInteger)deleteSectionWithName:(NSString *)name;

- (NSInteger)moveSectionWithName:(NSString *)name afterSectionWithName:(NSString *)name;
- (NSInteger)moveSectionWithName:(NSString *)name beforeSectionWithName:(NSString *)name;

/// @name Animated sections manipulations

- (void)beginUpdates;
- (void)endUpdates;

- (void)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name withRowAnimation:(UITableViewRowAnimation)animation;
- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSectionWithName:(NSString *)name withRowAnimation:(UITableViewRowAnimation)animation;

- (void)moveSectionWithName:(NSString *)name afterSectionWithName:(NSString *)name withRowAnimation:(UITableViewRowAnimation)animation;
- (void)moveSectionWithName:(NSString *)name beforeSectionWithName:(NSString *)name withRowAnimation:(UITableViewRowAnimation)animation;

@end
