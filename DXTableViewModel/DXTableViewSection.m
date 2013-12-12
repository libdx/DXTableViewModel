//
//  DXTableViewSection.m
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewSection.h"
#import "DXTableViewModel.h"
#import "DXTableViewRow.h"

/* TODO
 - add section wide row properties (or just use for..in and enumerateObjectsUsingBlock: on rows ?)
 - add convenience properties for header and footer view like headerText, headerDetailText, footerText, footerDetailText
 and update on configure[Header|Footer]
 - add animation types properties: insertRowAnimation, reloadRowAnimation, deleteRowAnimation
 - add bound capabilities as bindArray, bindFetch ect...
 - add property: defaultCellClass which will override classes from storyboard
 */

@interface DXTableViewRow (ForTableViewModelEyes)

@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) DXTableViewSection *section;

- (void)registerNibOrClass;

@end

@interface DXTableViewSection ()

@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) NSMutableArray *mutableRows;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation DXTableViewSection

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _sectionName = name;
        _headerHeight = UITableViewAutomaticDimension;
        _footerHeight = UITableViewAutomaticDimension;
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p; name='%@' index=%ld>",
                             [self class], self, self.sectionName, (long)self.sectionIndex];
    return description;
}

- (NSMutableArray *)mutableRows
{
    if (nil == _mutableRows) {
        _mutableRows = [[NSMutableArray alloc] init];
    }
    return _mutableRows;
}

- (NSArray *)rows
{
    return self.mutableRows.copy;
}

- (NSInteger)numberOfRows
{
    return self.mutableRows.count;
}

- (NSInteger)sectionIndex
{
    return [self.tableViewModel indexOfSectionWithName:self.sectionName];
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

- (void)registerNibOrClassForHeaderFooterNib:(UINib *)nib class:(Class)cls reuseIdentifier:(NSString *)reuseIdentifier
{
    if (nil != nib)
        [self.tableViewModel.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    else if (nil != cls)
        [self.tableViewModel.tableView registerClass:cls forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}

- (void)registerNibOrClassForRows
{
    [self registerNibOrClassForHeaderFooterNib:self.headerNib class:self.headerClass reuseIdentifier:self.headerReuseIdentifier];
    [self registerNibOrClassForHeaderFooterNib:self.footerNib class:self.footerClass reuseIdentifier:self.footerReuseIdentifier];
    [self.rows makeObjectsPerformSelector:@selector(registerNibOrClass)];
}

#pragma mark - Header and Footer subclass hooks

- (void)configureHeader
{

}

- (void)configureFooter
{

}

#pragma mark Building section

- (DXTableViewRow *)nextRowWithIdentifier:(NSString *)identifier greaterRowIndexThan:(NSInteger)index
{
    __block DXTableViewRow *res;
    [self.rows enumerateObjectsUsingBlock:^(DXTableViewRow *row, NSUInteger anIndex, BOOL *stop) {
        BOOL hasGivenIdentifier = [row.cellReuseIdentifier isEqualToString:identifier];
        BOOL hasIndexGreaterThatGivenIndex = (NSInteger)anIndex > index;
        if (hasGivenIdentifier && hasIndexGreaterThatGivenIndex) {
            res = row;
            *stop = YES;
        }
    }];
    return res;
}

- (DXTableViewRow *)rowWithIdentifier:(NSString *)identifier
{
    return [self nextRowWithIdentifier:identifier greaterRowIndexThan:-1];
}

- (NSInteger)indexOfRow:(DXTableViewRow *)row
{
    return [self.mutableRows indexOfObject:row];
}

- (NSIndexPath *)indexPathForRow:(DXTableViewRow *)row
{
    NSInteger sectionIndex = NSNotFound;
    if (nil != _tableViewModel)
        sectionIndex = [_tableViewModel indexOfSectionWithName:_sectionName];

    NSInteger rowIndex = [self indexOfRow:row];
    NSIndexPath *res = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    return res;
}

- (NSIndexPath *)addRow:(DXTableViewRow *)row
{
    return [self insertRow:row atIndex:self.mutableRows.count];
}

- (NSIndexPath *)insertRow:(DXTableViewRow *)row atIndex:(NSInteger)index
{
    row.tableViewModel = _tableViewModel;
    row.section = self;
    [self.mutableRows insertObject:row atIndex:index];
    [self registerNibOrClassForRows];
    return [self indexPathForRow:row];
}

- (NSIndexPath *)removeRow:(DXTableViewRow *)row
{
    NSIndexPath *res = [self indexPathForRow:row];
    row.tableViewModel = nil;
    row.section = nil;
    [self.mutableRows removeObject:row];
    return res;
}

- (NSIndexPath *)insertRow:(DXTableViewRow *)row afterRow:(DXTableViewRow *)otherRow
{
    NSInteger rowIndex = [self indexOfRow:otherRow];
    [self insertRow:row atIndex:++rowIndex];
    return [self indexPathForRow:row];
}

- (NSIndexPath *)insertRow:(DXTableViewRow *)row beforeRow:(DXTableViewRow *)otherRow
{
    NSInteger rowIndex = [self indexOfRow:otherRow];
    [self insertRow:row atIndex:rowIndex];
    return [self indexPathForRow:row];
}

- (NSArray *)moveRow:(DXTableViewRow *)row toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSIndexPath *indexPath = [self indexPathForRow:row];

    [self.mutableRows removeObject:row];
    [self.mutableRows insertObject:row atIndex:destinationIndexPath.row];

    return @[indexPath, destinationIndexPath];
}

/// @name Building section convenience methods
#pragma mark Building section convenience methods

- (void)addRows:(NSArray *)rows
{
    for (DXTableViewRow *row in rows)
        [self addRow:row];
}

#pragma mark Animated row manupulations

- (void)insertRows:(NSArray *)rows afterRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (DXTableViewRow *aRow in rows) {
        [indexPaths addObject:[self insertRow:aRow afterRow:row]];
    }
    [self.tableViewModel.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)insertRows:(NSArray *)rows beforeRow:(DXTableViewRow *)row withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (DXTableViewRow *aRow in rows) {
        [indexPaths addObject:[self insertRow:aRow beforeRow:row]];
    }
    [self.tableViewModel.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (DXTableViewRow *aRow in rows) {
        [indexPaths addObject:[self removeRow:aRow]];
    }
    [self.tableViewModel.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadRows:(NSArray *)rows withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (DXTableViewRow *aRow in rows) {
        [indexPaths addObject:[self indexPathForRow:aRow]];
    }
    [self.tableViewModel.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)moveRow:(DXTableViewRow *)row animatedToIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSArray *indexPaths = [self moveRow:row toIndexPath:destinationIndexPath];
    [self.tableViewModel.tableView moveRowAtIndexPath:indexPaths[0] toIndexPath:indexPaths[1]];
}

@end
