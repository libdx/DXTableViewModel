//
//  InfoViewController.m
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/13/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "InfoViewController.h"
#import "DXTableViewModel.h"
#import "DXTableViewSection.h"
#import "DXTableViewRow.h"

@interface DescriptionCell : UITableViewCell
@end

@implementation DescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

@end

@interface InfoViewController ()
@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    DXTableViewSection *textSection = [[DXTableViewSection alloc] initWithName:@"Text"];
    textSection.headerTitle = @"Text";
    DXTableViewRow *titleRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"TitleCell"];
    titleRow.cellClass = [UITableViewCell class];
    titleRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Title";
    };
    DXTableViewRow *descriptionRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"DescriptionCell"];
    descriptionRow.cellClass = [DescriptionCell class];
    descriptionRow.rowHeight = 100.0f;
    descriptionRow.cellForRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.detailTextLabel.text = @"Loooooong text";
        return cell;
    };
    [textSection addRow:titleRow];
    [textSection addRow:descriptionRow];

    DXTableViewSection *buttonsSection = [[DXTableViewSection alloc] initWithName:@"Buttons"];
    buttonsSection.headerTitle = @"Buttons";
    DXTableViewRow *actionRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ActionCell"];
    actionRow.cellClass = [UITableViewCell class];
    actionRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Tap Me";
    };
    actionRow.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        [[[UIAlertView alloc] initWithTitle:@"Action"
                                   message:@"You did tap \"Tap Me\" button"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    DXTableViewRow *swapRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ActionCell"];
    swapRow.cellClass = [UITableViewCell class];
    swapRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Swap sections";
    };
    swapRow.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        [row.tableViewModel beginUpdates];
        [row.tableViewModel moveSectionWithName:@"Text" animatedToSectionWithName:@"Options"];
        [row.tableViewModel moveSectionWithName:@"Buttons" animatedToSectionWithName:@"EditableSection"];
        [row.tableViewModel endUpdates];
        [tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [buttonsSection addRow:actionRow];
    [buttonsSection addRow:swapRow];

    // options section with prototyped cell in storyboard
    DXTableViewSection *optionsSection = [[DXTableViewSection alloc] initWithName:@"Options"];
    optionsSection.headerTitle = @"Options";
    optionsSection.footerTitle = @"copylefts 2013";
    DXTableViewRow *option1 = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"OptionCell"];
    DXTableViewRow *option2 = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"OptionCell"];
    DXTableViewRow *option3 = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"OptionCell"];
    option1.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Option 1";
    };
    option2.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Option 2";
    };
    option3.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Option 3";
    };
    option1.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    option2.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    option3.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    [optionsSection addRow:option1];
    [optionsSection addRow:option2];
    [optionsSection addRow:option3];

    // items (editable add/delete/move) section

    DXTableViewSection *editableSection = [[DXTableViewSection alloc] initWithName:@"EditableSection"];
    editableSection.headerTitle = @"Editable";
    DXTableViewRow *addRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"AddCell"];
    addRow.cellClass = [UITableViewCell class];
    addRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Add Item";
    };
    addRow.didSelectRowAtIndexPath = ^(DXTableViewRow *row, UITableView *tableView, NSIndexPath *indexPath) {
        [editableSection insertRows:@[[self newItemRow]] afterRow:row withRowAnimation:UITableViewRowAnimationRight];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    };
    [editableSection addRow:addRow];

    [self.tableViewModel addSection:buttonsSection];
    [self.tableViewModel addSection:textSection];
    [self.tableViewModel addSection:editableSection];
    [self.tableViewModel addSection:optionsSection];
    self.tableViewModel.tableView = self.tableView;
}

- (DXTableViewRow *)newItemRow
{
    DXTableViewRow *row = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ItemCell"];
    row.cellClass = [UITableViewCell class];
    row.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell, UITableView *tableView, NSIndexPath *indexPath) {
        cell.textLabel.text = @"Item";
    };
    return row;
}

- (DXTableViewModel *)tableViewModel
{
    if (nil == _tableViewModel) {
        _tableViewModel = [[DXTableViewModel alloc] init];
    }
    return _tableViewModel;
}

@end
