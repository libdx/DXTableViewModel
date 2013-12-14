//
//  DXTableViewModel.m
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewModel.h"
#import "DXTableViewSection.h"
#import "DXTableViewRow.h"

/* TODO
 - add reload sections method
 - check animated sections manipulations (check nested and grouped manipulations precisely)
 - implement missing delegate methods (those that were added in iOS 7)
 - rethink about section titles implementation, make it object oriented (e.g. per section title)
 - remove `__weak` for every row that is pass to row's block as argument (?)
 - add animation types properties: insertRowAnimation, deleteRowAnimation
 - add tests
 - add property: defaultCellClass which will override classes from storyboard
 */

@interface DXTableViewRow (ForTableViewModelEyes)

@property (strong, nonatomic) id cell;

@end

@interface DXTableViewSection (ForTableViewModelEyes)

@property (strong, nonatomic) DXTableViewModel *tableViewModel;

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;

- (void)registerNibOrClassForRows;

@end

@interface DXTableViewModel ()

@property (strong, nonatomic) NSMutableArray *mutableSections;

@end

@implementation DXTableViewModel

#pragma DXTableViewModel

- (id)init
{
    self = [super init];
    if (nil == self)
        return nil;

    _showsDefaultTitleForDeleteConfirmationButton = YES;

    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [self init];
    if (nil == self)
        return nil;

    self.tableView = tableView;

    return self;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p; sections=%@>", [self class], self, self.mutableSections];
    return description;
}

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

#pragma mark - Model building

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sectionName IN %@",
                              [self.mutableSections valueForKey:@"sectionName"]];
    NSArray *duplicates = [sections filteredArrayUsingPredicate:predicate];
    if (duplicates.count > 0) {
        NSString *fmt = @"\"%@\" section name is already exists in the model, but section name must be unique";
        [NSException raise:NSInvalidArgumentException format:fmt, [duplicates[0] sectionName]];
    }
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
    NSArray *sections = [self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"sectionName = %@", name]];
    if (sections.count < 1)
        [NSException raise:NSInvalidArgumentException format:@"section with name \"%@\" not found", name];
    return sections[0];
}

- (NSInteger)indexOfSectionWithName:(NSString *)name
{
    return [self.sections indexOfObject:[self sectionWithName:name]];
}

- (NSInteger)insertSection:(DXTableViewSection *)newSection afterSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self insertSection:newSection atIndex:++index];
    return index;
}

- (NSInteger)insertSection:(DXTableViewSection *)newSection beforeSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self insertSection:newSection atIndex:index];
    return index;
}

- (NSInteger)deleteSectionWithName:(NSString *)name
{
    NSInteger index = [self indexOfSectionWithName:name];
    [self removeSection:[self sectionWithName:name]];
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

#pragma mark - Model building convenience methods

- (void)addSections:(NSArray *)sections
{
    for (DXTableViewSection *section in sections)
        [self addSection:section];
}

#pragma mark - respondsToSelector hacks

- (BOOL)respondsToSelector:(SEL)aSelector
{
    BOOL res = [super respondsToSelector:aSelector];
    NSString *selectorName = NSStringFromSelector(aSelector);
    if ([selectorName isEqualToString:@"tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:"] &&
        _showsDefaultTitleForDeleteConfirmationButton)
        res = NO;

    if ([selectorName isEqualToString:@"tableView:sectionForSectionIndexTitle:atIndex:"] &&
        nil == self.sectionForSectionIndexTitleAtIndexBlock)
        res = NO;

    return res;
}

#pragma mark - Animated sections manipulations

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

- (void)reloadSectionsWithNames:(NSArray *)names withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableIndexSet *indices = [[NSMutableIndexSet alloc] init];
    for (NSString *name in names) {
        DXTableViewSection *section = [self sectionWithName:name];
        [indices addIndex:section.sectionIndex];
    }
    [self.tableView reloadSections:indices withRowAnimation:animation];
}

#pragma mark - Data binding

- (void)reloadRowBoundData
{
    for (DXTableViewSection *section in self.sections)
        [section.rows makeObjectsPerformSelector:@selector(reloadBoundData)];
}

- (void)updateRowObjects
{
    for (DXTableViewSection *section in self.sections)
        [section.rows makeObjectsPerformSelector:@selector(updateObject)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    if (nil != row.cellForRowBlock)
        res = row.cellForRowBlock(row);
    if (nil == res)
        res = [self.tableView dequeueReusableCellWithIdentifier:row.cellReuseIdentifier forIndexPath:indexPath];
    row.cell = res;
    [row configureCell];
    return res;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.mutableSections[section] headerTitle];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.mutableSections[section] footerTitle];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] canEditRow];
}

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] canMoveRow];
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *res;
    if (nil != self.sectionIndexTitlesBlock)
        res = self.sectionIndexTitlesBlock();
    return res;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // This method shouldn't be called unless sectionForSectionIndexTitleAtIndexBlock is not nil.
    // See respondsToSelector: for details
    return self.sectionForSectionIndexTitleAtIndexBlock(title, index);
}

// Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.commitEditingStyleForRowBlock)
        row.commitEditingStyleForRowBlock(row);
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // move row
    DXTableViewRow *row = [self rowAtIndexPath:sourceIndexPath];
    DXTableViewSection *sourceSection = row.section;
    DXTableViewSection *destinationSection = self.mutableSections[destinationIndexPath.section];
    [sourceSection removeRow:row];
    [destinationSection insertRow:row atIndex:destinationIndexPath.row];
    if (nil != self.moveRowToIndexPathBlock)
        self.moveRowToIndexPathBlock(row, destinationIndexPath);
}

#pragma mark - UITableViewDelegate

// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.willDisplayCellBlock)
        row.willDisplayCellBlock(row, cell);
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    __weak DXTableViewSection *sectionObject = self.mutableSections[section];
    if (nil != sectionObject.willDisplayHeaderViewBlock)
        sectionObject.willDisplayHeaderViewBlock(sectionObject, view);
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    __weak DXTableViewSection *sectionObject = self.mutableSections[section];
    if (nil != sectionObject.willDisplayFooterViewBlock)
        sectionObject.willDisplayFooterViewBlock(sectionObject, view);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (nil != self.didEndDisplayingCellBlock)
        self.didEndDisplayingCellBlock(self, cell, indexPath);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if (nil != self.didEndDisplayingHeaderViewBlock)
        self.didEndDisplayingHeaderViewBlock(self, view, section);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if (nil != self.didEndDisplayingFooterViewBlock)
        self.didEndDisplayingFooterViewBlock(self, view, section);
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat res = UITableViewAutomaticDimension;
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (row.rowHeightBlock)
        res = row.rowHeightBlock(row);
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

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header;
    DXTableViewSection *sectionObject = self.mutableSections[section];
    if (nil != sectionObject.viewForHeaderInSectionBlock)
        header = sectionObject.viewForHeaderInSectionBlock(sectionObject);
    else if (sectionObject.headerReuseIdentifier)
        header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionObject.headerReuseIdentifier];
    sectionObject.headerView = header;
    [sectionObject configureHeader];
    if (nil != sectionObject.configureHeaderBlock)
        sectionObject.configureHeaderBlock(sectionObject, header);
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer;
    DXTableViewSection *sectionObject = self.mutableSections[section];
    if (nil != sectionObject.viewForFooterInSectionBlock)
        footer = sectionObject.viewForFooterInSectionBlock(sectionObject);
    else if (sectionObject.footerReuseIdentifier)
        footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionObject.footerReuseIdentifier];
    sectionObject.footerView = footer;
    [sectionObject configureFooter];
    if (nil != sectionObject.configureFooterBlock)
        sectionObject.configureFooterBlock(sectionObject, footer);
    return footer;
}

// Accessories (disclosures).

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.accessoryButtonTappedForRowBlock)
        row.accessoryButtonTappedForRowBlock(row);
}

// Selection

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] shouldHighlightRow];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didHighlightRowBlock)
        row.didHighlightRowBlock(row);
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didUnhighlightRowBlock)
        row.didUnhighlightRowBlock(row);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.willSelectRowBlock)
        indexPath = row.willSelectRowBlock(row);
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.willDeselectRowBlock)
        indexPath = row.willDeselectRowBlock(row);
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didSelectRowBlock)
        row.didSelectRowBlock(row);

    if (row.shouldDeselectRow)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didDeselectRowBlock)
        row.didDeselectRowBlock(row);
}

// Editing

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] editingStyle];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] titleForDeleteConfirmationButton];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] shouldIndentWhileEditingRow];
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.willBeginEditingRowBlock)
        row.willBeginEditingRowBlock(row);
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.didEndEditingRowBlock)
        row.didEndEditingRowBlock(row);
}

// Moving/reordering

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (nil != self.targetIndexPathForMoveFromRowToProposedIndexPath)
        proposedDestinationIndexPath = self.targetIndexPathForMoveFromRowToProposedIndexPath([self rowAtIndexPath:sourceIndexPath],
                                                                                             proposedDestinationIndexPath);
    return proposedDestinationIndexPath;
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] indentationLevelForRow];
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self rowAtIndexPath:indexPath] shouldShowMenuForRow];
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    BOOL res = NO;
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.canPerformActionBlock)
        res = row.canPerformActionBlock(row, action, sender);
    return res;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    __weak DXTableViewRow *row = [self rowAtIndexPath:indexPath];
    if (nil != row.performActionBlock)
        row.performActionBlock(row, action, sender);
}

@end
