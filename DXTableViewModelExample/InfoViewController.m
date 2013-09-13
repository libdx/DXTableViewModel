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

    DXTableViewSection *textSection = [[DXTableViewSection alloc] initWithName:@"text"];
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

    DXTableViewSection *buttonsSection = [[DXTableViewSection alloc] initWithName:@"buttons"];
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
    [buttonsSection addRow:actionRow];

    // options section
    // items (editable add/delete/move) section

    [self.tableViewModel addSection:textSection];
    [self.tableViewModel addSection:buttonsSection];
    self.tableViewModel.tableView = self.tableView;
}

- (DXTableViewModel *)tableViewModel
{
    if (nil == _tableViewModel) {
        _tableViewModel = [[DXTableViewModel alloc] init];
    }
    return _tableViewModel;
}

@end
