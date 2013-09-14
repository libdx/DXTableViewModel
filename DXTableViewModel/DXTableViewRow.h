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
@property (strong, nonatomic, readonly) UITableView *tableView;

@property (strong, nonatomic, readonly) UITableViewCell *cell;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (unsafe_unretained, nonatomic) Class cellClass;
@property (copy, nonatomic) UINib *cellNib;
@property (nonatomic, getter=isRepeatable) BOOL repeatable;
@property (nonatomic) NSInteger repeatCount; // for how many times this row repeates

@property (nonatomic) CGFloat rowHeight;
@property (copy, nonatomic) CGFloat (^rowHeightBlock)(DXTableViewRow *row);

@property (nonatomic) UITableViewCellEditingStyle editingStyle;
@property (copy, nonatomic) NSString *titleForDeleteConfirmationButton; // not implemented

@property (strong, nonatomic, readonly) NSIndexPath *rowIndexPath;

@property (copy, nonatomic) void (^didSelectRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) UITableViewCell *(^cellForRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^configureCellBlock)(DXTableViewRow *row, id cell);
@property (copy, nonatomic) void (^commitEditingStyleForRowBlock)(DXTableViewRow *row);

- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier;

//- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath; // updatingCellUsingKVO:NO
//- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath updatingCellUsingKVO:(BOOL)usingKVO;
//
//- (void)updateObject;
//- (void)updateCell;

@end
