//
//  DXTableViewModel.m
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewModel.h"
#import "DXTableViewSection.h"
#import "DXTableViewRow.h"

@interface DXTableViewSection (ForTableViewModelEyes)

@property (strong, nonatomic) DXTableViewModel *tableViewModel;

- (void)registerNibOrClassForRows;

@end

@interface DXTableViewModel ()

@property (strong, nonatomic) NSMutableArray *mutableSections;
@property (nonatomic, getter=isTableViewDidAppear) BOOL tableViewDidAppear;

@end

@implementation DXTableViewModel

#pragma DXTableViewModel

- (NSMutableArray *)mutableSections
{
    if (nil == _mutableSections) {
        _mutableSections = [NSMutableArray array];
    }
    return _mutableSections;
}

- (DXTableViewRow *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.mutableSections[indexPath.section][indexPath.row];
}

- (void)addSection:(DXTableViewSection *)section
{
    [self insertSection:section atIndex:self.mutableSections.count];
}

- (void)insertSection:(DXTableViewSection *)section atIndex:(NSInteger)index
{
    [self insertSections:@[section] atIndexes:[[NSIndexSet alloc] initWithIndex:index]];
}

- (void)insertSections:(NSArray *)sections atIndexes:(NSIndexSet *)indexes
{
    [sections makeObjectsPerformSelector:@selector(setTableViewModel:) withObject:self];
    [sections makeObjectsPerformSelector:@selector(registerNibOrClassForRows)];
    [self.mutableSections insertObjects:sections atIndexes:indexes];
}

- (void)removeSection:(DXTableViewSection *)section
{
    [self.mutableSections removeObject:section];
}

#pragma mark UITableView Mnemonic Methods

- (void)beginUpdates
{
    [self.tableView beginUpdates];
}

- (void)endUpdates
{
    [self.tableView endUpdates];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableViewDidAppear = YES;
    return [self.mutableSections[section] numberOfRows];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mutableSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *res;
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.cellForRowAtIndexPath)
        res = row.cellForRowAtIndexPath(row, tableView, indexPath);
    return res;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat res = 0.0f;
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (row.rowHeightBlock)
        res = row.rowHeightBlock(row, tableView, indexPath);
    else
        res = row.rowHeight;
    return res;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.mutableSections[section] headerHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self.mutableSections[section] footerHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didSelectRowAtIndexPath)
        row.didSelectRowAtIndexPath(row, tableView, indexPath);
}

@end
