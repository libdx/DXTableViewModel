//
//  DXTableViewRow.h
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewModel, DXTableViewSection;

@interface DXTableViewRow : NSObject

@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;
@property (strong, nonatomic, readonly) DXTableViewSection *section;

@property (strong, nonatomic, readonly) UITableViewCell *cell;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (unsafe_unretained, nonatomic) Class cellClass;
@property (copy, nonatomic) UINib *cellNib;
@property (nonatomic, getter=isRepeatable) BOOL repeatable;
@property (nonatomic) NSInteger repeatCount; // for how many times this row repeates

@property (nonatomic) CGFloat rowHeight;
@property (copy, nonatomic) CGFloat (^rowHeightBlock)(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath);

@property (strong, nonatomic, readonly) NSIndexPath *rowIndexPath;

@property (copy, nonatomic) void (^didSelectRowAtIndexPath)(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic) UITableViewCell *(^cellForRowAtIndexPath)(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^configureCellBlock)(DXTableViewRow *row, id cell, UITableView *tableView, NSIndexPath *indexPath);

- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier;

- (void)setDidSelectRowAtIndexPath:(void (^)(DXTableViewRow *, UITableView *, NSIndexPath *))didSelectRowAtIndexPath;
- (void)setCellForRowAtIndexPath:(UITableViewCell *(^)(DXTableViewRow *, UITableView *, NSIndexPath *))cellForRowAtIndexPath;

//- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath; // updatingCellUsingKVO:NO
//- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath updatingCellUsingKVO:(BOOL)usingKVO;
//
//- (void)updateObject;
//- (void)updateCell;

@end
