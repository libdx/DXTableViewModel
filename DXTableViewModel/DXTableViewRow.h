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
 
 In order to show custom titles for delete confirmation buttons in table view
 set `[DXTableViewModel showsDefaultTitleForDeleteConfirmationButton]` property to NO. In this case default value will be
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
 Boolean value that specifies whether row represented by the receiver editable. If YES insertion or deletion control
 will be shown whithin the row's cell in edit mode. Default is YES.
 
 @see editingStyle
 */
@property (nonatomic) BOOL canEditRow;

/**
 Boolean value that specifies whether content of tow represented by the receiver should be indented while table view
 is in editing mode. Default is YES
 */
@property (nonatomic) BOOL shouldIndentWhileEditingRow;

/**
 Level of indentation for a row represented by the receiver. Default is 0.
 */
@property (nonatomic) NSInteger indentationLevelForRow;

/**
 An index path object that identifies position of row in table view model and table view.
 Is `nil` if receiver is not inserted into section. Section index is `NSNotFound` if receiver inserted into section,
 but section is not inserted into model.
 */
@property (strong, nonatomic, readonly) NSIndexPath *rowIndexPath;

/**
 Block object to be invoked on table view delegate method `tableView:didHighlightRowAtIndexPath:`
 which tells that the table view did highlight represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^didHighlightRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:didUnhighlightRowAtIndexPath:`
 which tells that the table view did unhighlight represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^didUnhighlightRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:willSelectRowAtIndexPath:`
 which tells that the table view is about to select represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) NSIndexPath *(^willSelectRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:willDeselectRowAtIndexPath:`
 which tells that the table view is about to deselect represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) NSIndexPath *(^willDeselectRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:didSelectRowAtIndexPath:`
 which tells that the table view did select represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^didSelectRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:didDeselectRowAtIndexPath:`
 which tells that the table view did deselect represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^didDeselectRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:commitEditingStyle:forRowAtIndexPath:`
 which asks to commit insertion or deletion of represented by the receiver row. Takes one parameter: row object
 (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^commitEditingStyleForRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view delegate method `tableView:willDisplayCell:forRowAtIndexPath:`
 which tells that the table view is about to show a cell for represented by the receiver row. 
 Takes one parameter: row object (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^willDisplayCellBlock)(DXTableViewRow *row, id cell);

/**
 Block object to be invoked on table view delegate method `tableView:accessoryButtonTappedForRowWithIndexPath:`
 which tells that the user tapped accessory view of represented by the receiver row.
 Takes one parameter: row object (the receiver is passed as `row` parameter).
 */
@property (copy, nonatomic) void (^accessoryButtonTappedForRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view data source method `tableView:cellForRowAtIndexPath:`
 which asks for configured cell to be shown. Takes one parameter: row object (the receiver is passed as `row` parameter).
 
 Providing this block you are responsible for dequeuing cells from table view just as well you implement
 `tableView:cellForRowAtIndexPath:` data source method. It is recommended to use `configureCellBlock` property 
 as more convenience way to configure cells.
 
 @see configureCellBlock
 */
@property (copy, nonatomic) UITableViewCell *(^cellForRowBlock)(DXTableViewRow *row);

/**
 Block object to be invoked on table view data source method `tableView:cellForRowAtIndexPath:`
 which asks for configured cell to be shown. Takes one parameter: row object and cell object;
 (the receiver is passed as `row` parameter).
 
 This block object is invoked after cell object's dequeue and gives ability to configure cell object.
 Cell is pass as `id` so you can substitute its type by concrete `UITableViewCell` type in block's argument list.
 
 @see cellForRowBlock
 */
@property (copy, nonatomic) void (^configureCellBlock)(DXTableViewRow *row, id cell);

/**
 Boolean values that determines if the editing menu should be shown on long tap for row represented by the receiver. Default is NO.
 
 @see canPerformActionBlock
 */
@property (nonatomic) BOOL shouldShowMenuForRow;

/**
 Block object to be invoked on table view delegate method `tableView:canPerformAction:forRowAtIndexPath:withSender`
 which asks if copy or paste items should be shown in editing menu. Takes three parameters: row object
 (the receiver is passed as `row` parameter), action (can be either selector `copy:` or `paster:`) and sender
 (the object that sent message).
 
 @see shouldShowMenuForRow
 */
@property (copy, nonatomic) BOOL (^canPerformActionBlock)(DXTableViewRow *row, SEL action, id sender);

/**
 Block object to be invoked on table view delegate method `tableView:performAction:forRowAtIndexPath:withSender:`
 which tells to perform copy or paster action. Takes three arguments: row object
 (the receiver is passed as `row` parameter), action (can be either selector `copy:` or `paster:`) and sender
 (the object that sent message).
 */
@property (copy, nonatomic) void (^performActionBlock)(DXTableViewRow *row, SEL action, id sender);

/**
 Returns configured row object.
 
 @param identifier A string to be used as reuse identifier of table view cell
 */
- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier;

#pragma mark - Convenience methods

/**
 String to be used as cell's textLabel text value.
 
 This allows quick cell's prototyping without need to provide `configureCellBlock`.
 If any other value than `nil` is given textLabel will be configured before `configureCellBlock` call, but
 after `cellForRowBlock` call.
 */
@property (copy, nonatomic) NSString *cellText;

/**
 String to be used as cell's detailTextLabel text value.
 
 This allows quick cell's prototyping without need to provide `configureCellBlock`.
 If any other value than `nil` is given detailTextLabel will be configured before `configureCellBlock` call, but
 after `cellForRowBlock` call. In order to display detailTextLabel cell must be configured in xib/storyboard or instantinated
 in `cellForRowBlock` with appropriet cell style.
 */
@property (copy, nonatomic) NSString *cellDetailText;

/**
 String to be used as cell's imageView image value.
 
 This allows quick cell's prototyping without need to provide `configureCellBlock`.
 If any other value than `nil` is given imageView will be configured before `configureCellBlock` call, but
 after `cellForRowBlock` call. In order to display imageView cell must be configured in xib/storyboard or instantinated
 in `cellForRowBlock` with appropriet cell style.
 */
@property (strong, nonatomic) UIImage *cellImage;

/**
 Boolean value that determines will be row deselected with animation just after selection. Default is YES.
 */
@property (assign, nonatomic) BOOL shouldDeselectRow;

#pragma mark - Data Bind Capabilities

/**
 Object that was bound to the receiver with one of the following methods: `bindObject:withKeyPath:` or `bindObject:withKeyPaths:`.
 
 Listed values as key paths of this object are accessible via receiver's subscript.
 `updateObject` method changes `boundObject`.  `reloadBoundData` loads data from `boundObject`.

 @see bindObject:withKeyPath:
 @see bindObject:withKeyPaths:
 @see reloadBoundData
 @see updateObject
 */
@property (strong, nonatomic, readonly) id boundObject;

/**
 List of key paths of data object that were bound to the receiver with one of the following method: `bindObject:withKeyPath:`,
 `bindObject:withKeyPaths:`.
 
 Theirs values are accessible via receiver's subscript.
 
 @see bindObject:withKeyPath:
 @see bindObject:withKeyPaths:
 @see reloadBoundData
 @see updateObject
 */
@property (strong, nonatomic, readonly) NSArray *boundKeyPaths;

/**
 Binds value of the given `object` with provided `keyPath` to the receiver.

 Receiver keeps strong reference on `object` that is accessible through `boundObject` property. `keyPath`
 is stored in `boundKeyPaths` array. Bound values are accessible via receiver subscript using given `keyPath`.
 For instance, if you did bind data object with key path "track.name", you can get track's name value like this: row[@"track.name"].
 
 @param object An object with key-value-coding compliant properties.
 @param keyPath Key path that refers to key-value coding compliant property of `object`.
 Value must be copyable (i.e. conforms to NSCopying protocol).
 
 @see bindObject:withKeyPaths:
 */
- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath;

/**
 Binds values of the given `object` with provided `keyPaths` to the receiver.
 
 Receiver keeps strong reference on `object` that is accessible through `boundObject` property. `keyPaths`
 is stored in `boundKeyPaths` array. Bound values are accessible via receiver subscript using any key path from given `keyPaths`.
 For instance, if you did bind data object with key path "track.name", you can get track's name value like this: row[@"track.name"].

 @param object An object with key-value-coding compliant properties.
 @param keyPaths Key paths that refer to key-value coding compliant properties of `object`.
 Values must be copyable (i.e. conform to NSCopying protocol).

 @see bindObject:withKeyPath:
 */
- (void)bindObject:(id)object withKeyPaths:(NSArray *)keyPaths;

/**
 Makes receiver a target of given `control` object for particular events.

 Usage:

  ```
      [row becomeTargetOfControl:cell.stepper forControlEvents:UIControlEventValueChanged withBlock:^(UIStepper *stepper) {
          cell.textLabel.text = [NSString stringWithFormat:@"%f", stepper.value];
          row[@"amount"] = @(stepper.value);
      }];
  ```
 @param control UIControl subclass object.
 @param controlEvents Bitmask that specifies particular control events.
 @param block A block object to be invoked when specified control events occur.
 */
- (void)becomeTargetOfControl:(UIControl *)control
             forControlEvents:(UIControlEvents)controlEvents
                    withBlock:(void (^)(id))block;

/**
 Makes receiver a delegate of given `textView` object with `textViewDidChange:` method.
 
 @param textView UITextView object.
 @param block A block object to be invoked when text or attributes of the `textVeiw` were changed by user.
 */
- (void)becomeDelegateOfTextViewForDidChange:(UITextView *)textView withBlock:(void (^)(UITextView *))block;

/**
 Convenience method that makes receiver a target of given `textField` for `UIControlEventEditingChanged` control event.
 
 @param textField UITextField object.
 @param block A block object to be invoked when editing changed event of given `textField` occur.
 */
- (void)becomeTargetOfTextFieldForEditingChanged:(UITextField *)textField withBlock:(void (^)(UITextField *))block;

#pragma mark - Handling Row and Cell States

/**
 Configures cell's textLabel, detailLabel and image with cellText, cellDetailText and cellImage values if given
 and invokes configureCellBlock.
 */
- (void)configureCell;

/**
 Reload data from bound object into the receiver using bound keys to be accessible via subscript.
 */
- (void)reloadBoundData;

/**
 Update bound object with receiver's bound data.
 
 If you did track changes from cell's controls and store them, or any other data, using subscript into row to previously
 bound key paths, this method will push these values into `boundObject` for each key path from `boundKeyPaths`.
 */
- (void)updateObject;

#pragma mark - Subclass Hooks

/**
 Invoked just before given `object` will be bind to the receiver. To be overridden in subclasses. Default implementation does nothing.

 @param object An object with key-value-coding compliant properties.
 @param keyPaths Key paths that refer to key-value coding compliant properties of `object`.
 
 @see bindObject:withKeyPaths:
 */
- (void)willBindObject:(id)object withKeyPaths:(NSArray *)keyPaths;

/**
 Invoked just after given `object` was bound to the receiver. To be overridden in subclasses. Default implementation does nothing.

 @param object An object with key-value-coding compliant properties.
 @param keyPaths Key paths that refer to key-value coding compliant properties of `object`.
 
 @see bindObject:withKeyPaths:
 */
- (void)didBindObject:(id)object withKeyPaths:(NSArray *)keyPaths;

/**
 Invoked just before cell will be configured. To be overridden in subclasses. Default implementation does nothing.

 @see configureCell
 */
- (void)willConfigureCell;

/**
 Invoked just after cell was configured. To be overridden in subclasses. Default implementation does nothing.
 
 @see configureCell
 */
- (void)didConfigureCell;

/**
 Invoked just before data from bound object will be reloaded into receiver. To be overridden in subclasses. Default implementation does nothing.

 @see reloadBoundData
 */
- (void)willReloadBoundData;

/**
 Invoked just after data from bound object were reloaded into receiver. To be overridden in subclasses. Default implementation does nothing.
 
 @see reloadBoundData
 */
- (void)didReloadBoundData;

/**
 Invoked just before `boundObject` will be updated with receiver's data. To be overridden in subclasses. Default implementation does nothing.
 
 @see updateObject
 */
- (void)willUpdateObject;

/**
 Invoked just after `boundObject` was updated with receiver's data. To be overridden in subclasses. Default implementation does nothing.
 
 @see updateObject
 */
- (void)didUpdateObject;

#pragma mark - Subscript

/**
 Provides support for subscript allows retrieve values for `key`.
 
 @param key The key for which to return the appropriate value
 */
- (id)objectForKeyedSubscript:(id)key;

/**
 Provides support for subscript allows set values for `key`.
 
 @param obj An object to set as value
 @param key The key for a given value (`obj`)
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
