//
//  DXTableViewSection.m
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewSection.h"
#import "DXTableViewModel.h"
#import "DXTableViewRow.h"

@interface DXTableViewModel (ForTableViewSectionEyes)

@property (nonatomic, readonly, getter=isTableViewDidAppear) BOOL tableViewDidAppear;

@end

@interface DXTableViewRow (ForTableViewModelEyes)

@property (strong, nonatomic) DXTableViewModel *tableViewModel;

@end

@interface DXTableViewSection ()

@property (strong, nonatomic) NSMutableArray *mutableRows;
@property (strong, nonatomic) DXTableViewModel *tableViewModel;

@end

@implementation DXTableViewSection

// TODO add checks for isTableViewDidAppear in setters

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _sectionName = name;
    }
    return self;
}

- (NSMutableArray *)mutableRows
{
    if (nil == _mutableRows) {
        _mutableRows = [[NSMutableArray alloc] init];
    }
    return _mutableRows;
}

- (void)setTableViewModel:(DXTableViewModel *)tableViewModel
{
    if (_tableViewModel != tableViewModel) {
        _tableViewModel = tableViewModel;
        for (DXTableViewRow *row in self.rows) {
            row.tableViewModel = _tableViewModel;
        }
    }
}

- (NSInteger)indexOfRow:(DXTableViewRow *)row
{
    return [self.mutableRows indexOfObject:row];
}

- (NSIndexPath *)indexPathForRow:(DXTableViewRow *)row
{
    NSIndexPath *res;
    if (nil != _tableViewModel) {
        NSInteger sectionIndex = [_tableViewModel indexOfSectionWithName:_sectionName];
        NSInteger rowIndex = [self indexOfRow:row];
        res = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    }
    return res;
}

- (NSIndexPath *)addRow:(DXTableViewRow *)row
{
    row.tableViewModel = _tableViewModel;
    [self.mutableRows addObject:row];
    return [self indexPathForRow:row];
}

- (NSIndexPath *)insertRow:(DXTableViewRow *)row atIndex:(NSInteger)index
{
    row.tableViewModel = _tableViewModel;
    [self.mutableRows insertObject:row atIndex:index];
    return [self indexPathForRow:row];
}

- (NSIndexPath *)removeRow:(DXTableViewRow *)row
{
    NSIndexPath *res = [self indexPathForRow:row];
    row.tableViewModel = nil;
    [self.mutableRows removeObject:row];
    return res;
}

- (NSArray *)rows
{
    return self.mutableRows.copy;
}

- (void)registerNibOrClassForRows
{
    for (DXTableViewRow *row in self.rows) {
        if (nil != row.cellNib)
            [self.tableViewModel.tableView registerNib:row.cellNib forCellReuseIdentifier:row.cellReuseIdentifier];
        else if (nil != row.cellClass)
            [self.tableViewModel.tableView registerClass:row.cellClass forCellReuseIdentifier:row.cellReuseIdentifier];
    }
}

@end
