//
//  DXTableViewRow.m
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewRow.h"
#import "DXTableViewSection.h"
#import "DXTableViewModel.h"

/* TODO
 for v 0.1.0:
 - documentation
 for v 0.2.0:
 - add convenience properties: simple value properties for counterpart with block properties and vice versa
 - add convenience methods like: canCopyRow, canPasteRow etc.
 - add repeatable row feature when binding an array with following properties:
    @property (nonatomic, getter=isRepeatable) BOOL repeatable;
    @property (nonatomic) NSInteger repeatCount;
 */

@interface DXTableViewModel (ForTableViewRowEyes)

@property (nonatomic, readonly, getter=isTableViewDidAppear) BOOL tableViewDidAppear;

@end

@interface DXTableViewSection (ForTableViewRowEyes)

- (NSIndexPath *)indexPathForRow:(DXTableViewRow *)row;

@end

@interface DXTableViewRow ()

@property (strong, nonatomic) id cell;
@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) DXTableViewSection *section;
@property (strong, nonatomic) NSArray *objectKeyPaths;
@property (strong, nonatomic) NSArray *cellKeyPaths;

@end

@implementation DXTableViewRow

- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        _cellReuseIdentifier = identifier;
        _rowHeight = UITableViewAutomaticDimension;
        _editingStyle = UITableViewCellEditingStyleDelete;
        _canMoveRow = YES;
        _canEditRow = YES;
        _shouldHighlightRow = YES;
        _shouldIndentWhileEditingRow = YES;
        _indentationLevelForRow = 0;
        _shouldShowMenuForRow = YES;
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [super description];
    description = [NSString stringWithFormat:@"%@: ID='%@', IndexPath=%@", description, self.cellReuseIdentifier, self.rowIndexPath];
    return description;
}

- (NSIndexPath *)rowIndexPath
{
    return [self.section indexPathForRow:self];
}

- (UITableView *)tableView
{
    return self.tableViewModel.tableView;
}

- (void)registerNibOrClass
{
    if (nil != self.cellClass)
        [self.tableViewModel.tableView registerClass:self.cellClass forCellReuseIdentifier:self.cellReuseIdentifier];
    else if (nil != self.cellNib)
        [self.tableViewModel.tableView registerNib:self.cellNib forCellReuseIdentifier:self.cellReuseIdentifier];
}

#pragma mark - Data Bind Capabilities

- (void)setBoundObject:(id)boundObject
{
    _boundObject = boundObject;
    [self loadDataFromObject];
}

- (void)bindObject:(id)object
{
    self.boundObject = object;
}

#pragma mark - Subclass Hooks

- (void)loadDataFromObject
{

}

- (void)updateCell
{
    UITableViewCell *cell = self.cell;
    cell.textLabel.text = self.cellText;
    cell.detailTextLabel.text = self.cellDetailText;
    cell.imageView.image = self.cellImage;
}

- (void)updateObject
{
}

@end
