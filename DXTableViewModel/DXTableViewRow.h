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

@property (strong, nonatomic, readonly) id cell;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (unsafe_unretained, nonatomic) Class cellClass;
@property (copy, nonatomic) UINib *cellNib;
@property (nonatomic, getter=isRepeatable) BOOL repeatable; // not implemented
@property (nonatomic) NSInteger repeatCount; // how many times this row repeates. not implemented

@property (nonatomic) CGFloat rowHeight;
@property (copy, nonatomic) CGFloat (^rowHeightBlock)(DXTableViewRow *row);

@property (nonatomic) BOOL shouldHighlightRow;

@property (nonatomic) UITableViewCellEditingStyle editingStyle;
@property (copy, nonatomic) NSString *titleForDeleteConfirmationButton; // not implemented
@property (copy, nonatomic) void (^willBeginEditingRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^didEndEditingRowBlock)(DXTableViewRow *row);

@property (nonatomic) BOOL canMoveRow;
@property (nonatomic) BOOL canEditRow;

@property (nonatomic) BOOL shouldIndentWhileEditingRow;
@property (nonatomic) NSInteger indentationLevelForRow;

@property (strong, nonatomic, readonly) NSIndexPath *rowIndexPath;

@property (copy, nonatomic) void (^didHighlightRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^didUnhighlightRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) NSIndexPath *(^willSelectRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) NSIndexPath *(^willDeselectRowBlock)(DXTableViewRow *row);

@property (copy, nonatomic) void (^didSelectRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^didDeselectRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^commitEditingStyleForRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^willDisplayCellBlock)(DXTableViewRow *row, id cell);
//@property (copy, nonatomic) void (^didEndDisplayingCellBlock)(DXTableViewRow *row, id cell);

@property (copy, nonatomic) void (^accessoryButtonTappedForRowBlock)(DXTableViewRow *row);

@property (copy, nonatomic) UITableViewCell *(^cellForRowBlock)(DXTableViewRow *row);
@property (copy, nonatomic) void (^configureCellBlock)(DXTableViewRow *row, id cell);

@property (nonatomic) BOOL shouldShowMenuForRow;
@property (copy, nonatomic) BOOL (^canPerformActionBlock)(DXTableViewRow *row, SEL action, id sender);
@property (copy, nonatomic) void (^performActionBlock)(DXTableViewRow *row, SEL action, id sender);

- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier;

#pragma mark - Convenience methods

@property (copy, nonatomic) NSString *cellText;
@property (copy, nonatomic) NSString *cellDetailText;
@property (strong, nonatomic) UIImage *cellImage;

#pragma mark - Data Binding

@property (strong, nonatomic) id boundObject;

- (void)bindObject:(id)object keyPaths:(NSArray *)keyPaths toCellKeyPaths:(NSArray *)cellKeyPaths;

@end

@interface DXTableViewRow (Protected)

@property (strong, nonatomic) NSMutableDictionary *cellData;

- (void)updateCell;
- (void)updateObject;

@end
