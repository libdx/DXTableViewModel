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

- (void)setTableView:(UITableView *)tableView
{
    if (_tableView != tableView) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.sections makeObjectsPerformSelector:@selector(registerNibOrClassForRows)];
    }
}

- (NSMutableArray *)mutableSections
{
    if (nil == _mutableSections) {
        _mutableSections = [NSMutableArray array];
    }
    return _mutableSections;
}

- (NSArray *)sections
{
    return self.mutableSections.copy;
}

- (DXTableViewRow *)rowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.mutableSections[indexPath.section] rows][indexPath.row];
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

- (DXTableViewSection *)sectionWithName:(NSString *)name
{
    return [self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]].lastObject;
}

- (NSInteger)indexOfSectionWithName:(NSString *)name
{
    return [self.sections indexOfObject:[self sectionWithName:name]];
}

- (NSInteger)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self.mutableSections insertObject:newSection atIndex:++index];
    return index;
}

- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self.mutableSections insertObject:newSection atIndex:index];
    return index;
}

- (NSInteger)deleteSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self.mutableSections removeObjectAtIndex:index];
    return index;
}

- (NSIndexSet *)moveSectionWithName:(NSString *)name toSectionWithName:(NSString *)destinationName
{
    NSInteger index = [self indexOfSectionWithName:name];
    NSInteger destinationIndex = [self indexOfSectionWithName:destinationName];

    DXTableViewSection *section = [self sectionWithName:name];
    [self.mutableSections removeObject:section];
    [self.mutableSections insertObject:section atIndex:destinationIndex];

    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] initWithIndex:index];
    [indexes addIndex:destinationIndex];
    return indexes.copy;
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

- (void)insertSections:(NSArray *)newSections
  afterSectionWithName:(NSString *)name
      withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (DXTableViewSection *newSection in newSections) {
        NSInteger index = [self insertSection:newSection afterSectionWithName:name];
        [indexes addIndex:index];
    }
    [self.tableView insertSections:indexes withRowAnimation:animation];
}

- (void)insertSections:(NSArray *)newSections
 beforeSectionWithName:(NSString *)name
      withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (DXTableViewSection *newSection in newSections) {
        NSInteger index = [self insertSection:newSection beforeSectionWithName:name];
        [indexes addIndex:index];
    }
    [self.tableView insertSections:indexes withRowAnimation:animation];
}

- (void)deleteSectionsWithNames:(NSArray *)names withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (NSString *name in names) {
        NSInteger index = [self deleteSectionWithName:name];
        [indexes addIndex:index];
    }
    [self.tableView deleteSections:indexes withRowAnimation:animation];
}

- (void)moveSectionWithName:(NSString *)name animatedToSectionWithName:(NSString *)otherName
{
    NSIndexSet *indexes = [self moveSectionWithName:name toSectionWithName:otherName];
    [self.tableView moveSection:indexes.firstIndex toSection:indexes.lastIndex];
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
    if (nil == res)
        res = [self.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier forIndexPath:indexPath];
    if (nil != row.configureCellBlock)
        row.configureCellBlock(row, res, tableView, indexPath);
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
