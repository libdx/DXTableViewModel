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

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;

    DXTableViewSection *textSection = [[DXTableViewSection alloc] initWithName:@"Text"];
    textSection.headerTitle = @"Text";
    DXTableViewRow *titleRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"TitleCell"];
    titleRow.cellClass = [UITableViewCell class];
    titleRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Title";
    };
    DXTableViewRow *descriptionRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"DescriptionCell"];
    descriptionRow.cellClass = [DescriptionCell class];
    descriptionRow.rowHeight = 100.0f;
    descriptionRow.cellForRowBlock = ^(DXTableViewRow *row) {
        DescriptionCell *cell = [row.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier];
        cell.detailTextLabel.text = @"Loooooong text";
        return cell;
    };
    [textSection addRow:titleRow];
    [textSection addRow:descriptionRow];

    DXTableViewSection *buttonsSection = [[DXTableViewSection alloc] initWithName:@"Buttons"];
    buttonsSection.headerTitle = @"Buttons";
    DXTableViewRow *actionRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ActionCell"];
    actionRow.cellClass = [UITableViewCell class];
    actionRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Tap Me";
    };
    actionRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        [[[UIAlertView alloc] initWithTitle:@"Action"
                                   message:@"You did tap \"Tap Me\" button"
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil] show];
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    DXTableViewRow *swapRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ActionCell"];
    swapRow.cellClass = [UITableViewCell class];
    swapRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Swap sections";
    };
    swapRow.didSelectRowBlock = ^(DXTableViewRow *row) {
        [row.tableViewModel beginUpdates];
        [row.tableViewModel moveSectionWithName:@"Text" animatedToSectionWithName:@"Options"];
        [row.tableViewModel moveSectionWithName:@"Buttons" animatedToSectionWithName:@"Empty"];
        [row.tableViewModel endUpdates];
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
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
    option1.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Option 1";
    };
    option2.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Option 2";
    };
    option3.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Option 3";
    };
    option1.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    option2.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    option3.didSelectRowBlock = ^(DXTableViewRow *row) {
        UITableViewCell *cell = [row.tableView cellForRowAtIndexPath:row.rowIndexPath];
        cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ?
        UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    [optionsSection addRow:option1];
    [optionsSection addRow:option2];
    [optionsSection addRow:option3];

    DXTableViewSection *emptySection = [[DXTableViewSection alloc] initWithName:@"Empty"];
    emptySection.headerTitle = @"Empty One";
    emptySection.footerTitle = @"But it is exists";

    [self.tableViewModel addSection:buttonsSection];
    [self.tableViewModel addSection:textSection];
    [self.tableViewModel addSection:emptySection];
    [self.tableViewModel addSection:optionsSection];
    self.tableViewModel.tableView = self.tableView;
}

- (DXTableViewRow *)newItemRow
{
    DXTableViewRow *row = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"ItemCell"];
    row.cellClass = [UITableViewCell class];
    row.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
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

- (DXTableViewSection *)editableSection
{
    // items (editable add/delete/move) section
    DXTableViewSection *editableSection = [[DXTableViewSection alloc] initWithName:@"Editable"];
    editableSection.headerTitle = @"Editable";
    DXTableViewRow *addRow = [[DXTableViewRow alloc] initWithCellReuseIdentifier:@"AddCell"];
    addRow.editingStyle = UITableViewCellEditingStyleInsert;
    addRow.cellClass = [UITableViewCell class];
    addRow.configureCellBlock = ^(DXTableViewRow *row, UITableViewCell *cell) {
        cell.textLabel.text = @"Add Item";
    };
    void (^addItemActionBlock)() = ^(DXTableViewRow *row) {
        [editableSection insertRows:@[[self newItemRow]] afterRow:row withRowAnimation:UITableViewRowAnimationRight];
        [row.tableView deselectRowAtIndexPath:row.rowIndexPath animated:YES];
    };
    addRow.didSelectRowBlock = addItemActionBlock;
    addRow.commitEditingStyleForRowBlock = addItemActionBlock;
    [editableSection addRow:addRow];
    return editableSection;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        if (animated) {
            [self.tableViewModel insertSections:@[self.editableSection] afterSectionWithName:@"Text" withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableViewModel insertSection:self.editableSection afterSectionWithName:@"Text"];
            [self.tableView reloadData];
        }
    } else {
        if (animated) {
            [self.tableViewModel deleteSectionsWithNames:@[@"Editable"] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.tableViewModel deleteSectionWithName:@"Editable"];
            [self.tableView reloadData];
        }
    }
}

@end
