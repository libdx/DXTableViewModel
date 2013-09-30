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
 + for first release remove bindObject:keyPaths:toCellKeyPaths: method and related code, but leave boundObject property and suggest to subclass rows for binding data
 - add convenience properties: simple value properties for counterpart with block properties and vice versa
 - add convenience methods like: canCopyRow, canPasteRow etc
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
@property (strong, nonatomic) NSMutableDictionary *cellData;
@property (strong, nonatomic) NSArray *objectKeyPaths;
@property (strong, nonatomic) NSArray *cellKeyPaths;

@end

@implementation DXTableViewRow

/* TODO 
 - add checks for isTableViewDidAppear in setters (?)
 - data binding from cell
 */

- (instancetype)initWithCellReuseIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        _cellReuseIdentifier = identifier;
        _rowHeight = UITableViewAutomaticDimension;
        _editingStyle = UITableViewCellEditingStyleDelete;
        _canMoveRow = NO;
        _canEditRow = YES;
        _shouldHighlightRow = YES;
        _shouldIndentWhileEditingRow = YES;
        _indentationLevelForRow = 0;
        _shouldShowMenuForRow = YES;
    }
    return self;
}

- (NSMutableDictionary *)cellData
{
    if (nil == _cellData)
        _cellData = [[NSMutableDictionary alloc] init];
    return _cellData;
}

- (NSIndexPath *)rowIndexPath
{
    return [self.section indexPathForRow:self];
}

- (UITableView *)tableView
{
    return self.tableViewModel.tableView;
}

#pragma mark - Data Binding

- (void)setBoundObject:(id)boundObject
{
    _boundObject = boundObject;
    [self loadDataFromObject];
}

- (void)bindObject:(id)object
{
    self.boundObject = object;
}

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
