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

/**
 Table view model object that owns the receiver.
 */
@property (strong, nonatomic, readonly) DXTableViewModel *tableViewModel;

/**
 Section object that owns the receiver.
 */
@property (strong, nonatomic, readonly) DXTableViewSection *section;

/**
 An table view object to be configured by receiver's `tableViewModel`.
 */
@property (strong, nonatomic, readonly) UITableView *tableView;

/**
 An table view cell object to be configured by receiver.
 */
@property (strong, nonatomic, readonly) id cell;

/**
 String identifier to be used as `reuseIdentifier` of the `cell` object.
 */
@property (copy, nonatomic) NSString *cellReuseIdentifier;

/**
 Class object to be registered in creating `cell` object. Default is `nil`.

 If `cellClass` is not `nil` `cellNib` property will be ignored.
 You must provide either cell class, cell nib or declare cell in storyboard with reuse identifier equals to `cellReuseIdentifier`.
 
 @see cellNib
 @see cellReuseIdentifier
 */
@property (unsafe_unretained, nonatomic) Class cellClass;

/**
 Nib object to be registered in creating `cell` object. Default is `nil`.

 If `cellClass` is not `nil` `cellNib` property will be ignored.
 You must provide either cell class, cell nib or declare cell in storyboard with reuse identifier equals to `cellReuseIdentifier`.

 @see cellNib
 @see cellReuseIdentifier
 */
@property (strong, nonatomic) UINib *cellNib;

/**
 Height to be used for row represented by the receiver in table view. Default is UITableViewAutomaticDimension.
 
 @see rowHeightBlock
 */
@property (nonatomic) CGFloat rowHeight;

/**
 Block object to be invoked on table view delegate method `tableView:heightForRowAtIndexPath` 
 for retrieving height for row represented by the receiver in table view. Takes one parameter: row object
 (the receiver is passed as `row` parameter) and returns float value of row height. If not `nil` 
 `rowHeight` property will be ignored. Default is `nil`.
 
 @see rowHeight
 */
@property (copy, nonatomic) CGFloat (^rowHeightBlock)(DXTableViewRow *row);

/**
 Boolean value that indicates if the row represented by the receiver should be highlighted. Default is NO.
 */
@property (nonatomic) BOOL shouldHighlightRow;

/**
 The editing style of the cell represented by receiver. Default UITableViewCellEditingStyleDelete.
 
 @see canEditRow
 */
@property (nonatomic) UITableViewCellEditingStyle editingStyle;

/**
 String to be used as a title for delete confirmation button. Default is `nil`.
 
 UITableView doesn't allow to selectively show custom title for 

 In order to show custom titles for delete confirmation buttons in table view
 set [DXTableViewModel showsDefaultTitleForDeleteConfirmationButton] property to NO. In this case default value will be
 empty and you should provide localized titles for each row in the table view. This is limitation of UITableView.
 */
@property (copy, nonatomic) NSString *titleForDeleteConfirmationButton;

/**
 Block object to be invoked on table view delegate method `tableView:willBeginEditingRowAtIndexPath:`
 which tells that the table view is about to go into editing mode. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^willBeginEditingRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:willBeginEditingRowAtIndexPath:`
 which tells that the table view has left editing mode. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^didEndEditingRowBlock)(DXTableViewRow *row);

/**
 Boolean value that specifies whether row represented by the receiver can be moved to another location in the table view.
 Default is NO.
 */
@property (nonatomic) BOOL canMoveRow;

/**
 Boolean value that specifier whether row represented by the receiver editable. If YES insertion or deletion control
 will be shown whithin the row's cell in edit mode. Default is YES.
 
 @see editingStyle
 */
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
