DXTableViewModel
================

An object-oriented representation of UITableView.
Helps describe table view in declarative manner.
Useful for building complex table view based forms with lots of different
cell subclasses.

It contains only three classes:

- `DXTableViewModel` - implements all delegate and datasource methods of table view.
- `DXTableViewSection` - represents table view's section.
- `DXTableViewRow` - represents table view's row.

Sections and cells (rows) are represented by `DXTableViewSection`
and `DXTableViewRow` objects respectively. `DXTableViewModel` is essentially UITableView delegate and datasource that configures table view according to provided data through block-based API in sections and rows objects.

### Notice

This project is still in early stage of development, so use with caution.
API breaking changes at this stage are quite likely.
Any bug reports, suggestions or pull requests are wellcome.

## Key Features

- Easy to use: block-based API naming is similiar to UITableView's delegate and datasource methods.
- Easy to integrate: custom UITableViewCell's and UIViewController's free.
- Easy to add/remove sections and rows from table view with or without animations.
- Storyboard and xib friendly.
- Simple data binding capabilities that simplify creating of editable forms. (optional)
- Tracking changes from UIControl subclasses and UITextView to cache cell state before its being reused. (optional)
- Dynamic row height through `rowHeightBlock` property.
- Registration of cells' classes and xibs provided through `cellClass` or `cellNib` properties.
- Fully documented headers in appledoc style. (Currently task in progress...)

## Examples

Build table view with cell that will show alert on selection:

```objective-c
	self.tableViewModel = [[DXTableViewModel alloc] init];
	DXTableViewSection *buttonsSection = [[DXTableViewSection alloc] initWithName:@"Buttons"];
    buttonsSection.headerTitle = @"Buttons";
    DXTableViewRow *actionRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ActionCell"];
    actionRow.cellClass = [UITableViewCell class];  
    actionRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Tap Me";
    };
    actionRow.didSelectRowBlock = ^(DXTableViewRow *row) {
    	// here row is a reference to actionRow object, that avoids need to make weak reference in order to access to row's properties from this block
        [[[UIAlertView alloc] initWithTitle:@"Action"
                                   message:@"You did tap \"Tap Me\" button"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [buttonsSection addRow:actionRow];
    [self.tableViewModel addSection:buttonsSection];
    self.tableViewModel.tableView = self.tableView; // this will implicitly set delegate and datasource of table view to tableViewModel
```

Animaged manipulations with rows and sections:

```objective-c
	// assume section object is already added to table view model, newSection is configured with rows and table view is being displayed
	[tableViewModel beginUpdates];
	
	NSArray *rows = @[itemRow1, itemRow2]; // Array of DXTableViewRow objects
	[section insertRows:rows afterRow:addItemRow withRowAnimation:UITableViewRowAnimationAutomatic];
	
	NSArray *rowsToDelete = @[itemRow3];
	[section deleteRows:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];

	[tableViewModel insertSections:@[newSection] afterSectionWithName:@"SomeOtherSection" withRowAnimation:UITableViewRowAnimationAutomatic];

	[tableViewModel endUpdates];
```

Alternatevelly you can alter table view manually, `DXTableViewModel` classes will provide sufficient information:

```objective-c
	NSInteger *deletedSectionIndex = [tableViewModel deleteSectionWithName:@"SomeSection"];
	NSIndexPath *deletedRowIndexPath = [itemsSection removeRow:itemRow];
	[self.tableView beginUpdates];
	self.tableView deleteSections:[NSIndexSet indexSetWithIndex:deletedSectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];	
	self.tableView deleteRowsAtIndexPaths:@[deletedRowIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];
```

Creating editable forms. Bind object to row with cell created from xib.
Bound object's key paths will be accessible from row object through subscript:

```objective-c
    DXTableViewRow *stepperRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"StepperCell"];
    stepperRow.cellNib = [UINib nibWithNibName:@"StepperCell" bundle:nil];
    [stepperRow bindObject:self.item withKeyPaths:@[@"count"]];
    stepperRow.configureCellBlock = ^(DXTableViewRow *row, StepperCell *cell) {
	    // here row is a reference to stepperRow object, that avoids need to make weak reference in order to access to row's properties from this block
        cell.titleLabel.text = @"Number of items";
        cell.valueLabel.text = [NSString stringWithFormat:@"%@", row[@"count"]]; // count is a bound key path from 
        cell.stepper.value = [row[@"count"] doubleValue];
        [row becomeTargetOfControl:cell.stepper forControlEvents:UIControlEventValueChanged withBlock:^(UIStepper *stepper){
            row[@"count"] = @(stepper.value); // cache steppre value on each value changed event
            cell.valueLabel.text = [NSString stringWithFormat:@"%@", row[@"count"]];
        }]; // this will add row as target of stepper control in order to cache control's state
    };
	[textSection addRow:stepperRow];
	[tableViewModel addSection:textSection];
	
	// …
	
	// call updateRowObjects to push cached changes into bound objects:
	[tableViewModel updateRowObjects];
	
	// …

	// call reloadRowBoundData to refresh cached data in rows from bound objects:
	[tableViewModel reloadRowBoundData];
```

Apply parameters to all rows in section:

```objective-c

    for (DXTableViewRow *row in textSection.rows) {
        row.editingStyle = UITableViewCellEditingStyleNone;
        row.shouldIndentWhileEditingRow = NO;
    }
```

## Installation

`DXTableViewModel` available through cocoa pods. Add to your Podfile:

```
	pod 'DXTableViewModel',  '~> 0.1.0'
```

Also you can just grab source files from `DXTableViewModel` directory and add them to your project directly.

Enjoy!
