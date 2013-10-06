//
//  DXTableViewRow.h
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXTableViewModel, DXTableViewSection;

/**
 `DXTableViewRow` represents a row in table view and provides access to customization appropriate cell.
 It is a main building block for table view model.
 It encapsulates cell object and cell's data that being used to customize cell.
 Essential part of properties have names that are very similiar to appropriate table view's delegate and data source methods.
 */
@interface DXTableViewRow : NSObject

/// @name General properties and methods
#pragma mark - General properties and methods

@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;
@property (strong, nonatomic, readonly) DXTableViewSection *section;
@property (strong, nonatomic, readonly) UITableView *tableView;

@property (strong, nonatomic, readonly) id cell;
@property (copy, nonatomic) NSString *cellReuseIdentifier;
@property (unsafe_unretained, nonatomic) Class cellClass;
@property (strong, nonatomic) UINib *cellNib;

@property (nonatomic) CGFloat rowHeight;
@property (copy, nonatomic) CGFloat (^rowHeightBlock)(DXTableViewRow *row);

@property (nonatomic) BOOL shouldHighlightRow;

@property (nonatomic) UITableViewCellEditingStyle editingStyle;
@property (copy, nonatomic) NSString *titleForDeleteConfirmationButton;
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

#pragma mark - Data Bind Capabilities

@property (strong, nonatomic, readonly) id boundObject;

@property (strong, nonatomic, readonly) NSArray *boundKeyPaths;

- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath;

- (void)bindObject:(id)object withKeyPaths:(NSArray *)keyPaths;

// Usage:
//  ```
//  [row becomeTargetOfControl:cell.stepper forControlEvents:UIControlEventValueChanged withBlock:^(UIStepper *stepper) {
//      cell.textLabel.text = [NSString stringWithFormat:@"%f", stepper.value];
//      row[@"amount"] = @(stepper.value);
//  }];
//  ```
- (void)becomeTargetOfControl:(UIControl *)control
             forControlEvents:(UIControlEvents)controlEvents
                    withBlock:(void (^)(id))block;

- (void)becomeDelegateOfTextViewForDidChange:(UITextView *)textView withBlock:(void (^)(UITextView *))block;

- (void)becomeTargetOfTextFieldForEditingChanged:(UITextField *)textField withBlock:(void (^)(UITextField *))block;

#pragma mark - Handling Row and Cell States

/**
 Configures cell's textLabel, detailLabel and image with cellText, cellDetailText and cellImage values if given
 and invokes configureCellBlock.
 */
- (void)configureCell;

/**
 Sequentially calls reloadBoundData and reloadCell.
 */
- (void)reloadRow;

/**
 Reload data from bound object into row using bound keys to be accessible via subscript.
 */
- (void)reloadBoundData;

/**
 Update bound object with row's bound data.
 
 If you did track changes from cell's controls and store them, or any other data, using subscript into row to previously
 bound key paths, this method will push these values into `boundObject` for each key path from `boundKeyPaths`.
 */
- (void)updateObject;

#pragma mark - Subclass Hooks

- (void)willBindObject:(id)object withKeyPaths:(NSArray *)keyPaths;
- (void)didBindObject:(id)object withKeyPaths:(NSArray *)keyPaths;

- (void)willConfigureCell;
- (void)didConfigureCell;

- (void)willReloadBoundData;
- (void)didReloadBoundData;

- (void)willUpdateObject;
- (void)didUpdateObject;

#pragma mark - Subscript

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
