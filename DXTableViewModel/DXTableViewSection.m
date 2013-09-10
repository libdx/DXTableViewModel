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

- (void)addRow:(DXTableViewRow *)row
{
    row.tableViewModel = _tableViewModel;
    [self.mutableRows addObject:row];
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
