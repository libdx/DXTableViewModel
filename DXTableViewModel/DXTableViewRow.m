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
 - add properties for fast cell prototyping: cellText, cellDetailedText, cellImage
 - add convenience properties: simple value properties for counterpart with block properties and vice versa
 */

@interface DXTableViewModel (ForTableViewRowEyes)

@property (nonatomic, readonly, getter=isTableViewDidAppear) BOOL tableViewDidAppear;

@end

@interface DXTableViewSection (ForTableViewRowEyes)

- (NSIndexPath *)indexPathForRow:(DXTableViewRow *)row;

@end

@interface DXTableViewRow ()

@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) DXTableViewSection *section;
@property (strong, nonatomic) NSMutableDictionary *cellData;

@end

@implementation DXTableViewRow

/* TODO add checks for isTableViewDidAppear in setters (?)
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
        _cellData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSIndexPath *)rowIndexPath
{
    return [self.section indexPathForRow:self];
}

- (UITableView *)tableView
{
    return self.tableViewModel.tableView;
}

- (void)updateBoundObjectFromCellValues
{
    for (NSString *keyPath in _cellData) {
        id value = _cellData[keyPath];
        [self.boundObject setValue:value forKeyPath:keyPath];
    }
}

- (void)setCellValue:(id)value forKeyPath:(NSString *)keyPath
{
    [_cellData setValue:value forKey:keyPath];
}

@end
