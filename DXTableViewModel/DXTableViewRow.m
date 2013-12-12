//
//  DXTableViewRow.m
//  DXTableViewModel
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewRow.h"
#import "DXTableViewSection.h"
#import "DXTableViewModel.h"

/* TODO
 - add convenience properties: simple value properties for counterpart with block properties and vice versa
 - add convenience methods like: canCopyRow, canPasteRow etc.
 - add repeatable row feature when binding an array with following properties:
    @property (nonatomic, getter=isRepeatable) BOOL repeatable;
    @property (nonatomic) NSInteger repeatCount;
 - copy values of bound object referenced by key paths
 - provide default subclasses of cell with different stock styles
 */

@interface DXTableViewSection (ForTableViewRowEyes)

- (NSIndexPath *)indexPathForRow:(DXTableViewRow *)row;

@end

@interface DXTableViewRow () <UITextViewDelegate>

@property (strong, nonatomic) id cell;
@property (strong, nonatomic) DXTableViewModel *tableViewModel;
@property (strong, nonatomic) DXTableViewSection *section;
@property (strong, nonatomic) id boundObject;
@property (strong, nonatomic) NSArray *boundKeyPaths;
@property (strong, nonatomic) NSMutableDictionary *boundObjectData;
@property (copy, nonatomic) void (^textViewDidChangeBlock)(UITextView *);
@property (strong, nonatomic) NSMutableDictionary *actionBlockByControlMap;

@end

@implementation DXTableViewRow

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
        _shouldShowMenuForRow = NO;
        _shouldDeselectRow = YES;
    }
    return self;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p; ID='%@'; indexPath=%@; sectionName='%@'>",
                             [self class], self, self.cellReuseIdentifier, self.rowIndexPath, self.section.sectionName];
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

- (NSMutableDictionary *)actionBlockByControlMap
{
    if (nil == _actionBlockByControlMap)
        _actionBlockByControlMap = [NSMutableDictionary dictionary];
    return _actionBlockByControlMap;
}

#pragma mark - Data Bind Capabilities

- (void)bindObject:(id)object withKeyPath:(NSString *)keyPath
{
    [self bindObject:object withKeyPaths:@[keyPath]];
}

- (void)bindObject:(id)object withKeyPaths:(NSArray *)keyPaths
{
    [self willBindObject:object withKeyPaths:keyPaths];
    self.boundObject = object;
    self.boundKeyPaths = keyPaths;
    [self reloadBoundData];
    [self didBindObject:self.boundObject withKeyPaths:self.boundKeyPaths];
}

#pragma mark - Controls' handling

- (void)becomeTargetOfControl:(UIControl *)control
             forControlEvents:(UIControlEvents)controlEvents
                    withBlock:(void (^)(id))block
{
    NSArray *actions = [control actionsForTarget:self forControlEvent:controlEvents];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", NSStringFromSelector(@selector(targetActionForControl:))];
    if ([actions filteredArrayUsingPredicate:predicate].count < 1) {
        [control addTarget:self action:@selector(targetActionForControl:) forControlEvents:controlEvents];
        [self.actionBlockByControlMap setObject:block forKey:[NSValue valueWithNonretainedObject:control]];
    }
}

- (void)becomeDelegateOfTextViewForDidChange:(UITextView *)textView withBlock:(void (^)(UITextView *))block
{
    self.textViewDidChangeBlock = block;
    textView.delegate = self;
}

- (void)becomeTargetOfTextFieldForEditingChanged:(UITextField *)textField withBlock:(void (^)(UITextField *))block
{
    [self becomeTargetOfControl:textField forControlEvents:UIControlEventEditingChanged withBlock:block];
}

#pragma mark - Controls' action

- (void)targetActionForControl:(id)sender
{
    void (^block)(id) = self.actionBlockByControlMap[[NSValue valueWithNonretainedObject:sender]];
    block(sender);
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.textViewDidChangeBlock(textView);
}

- (void)configureCell
{
    [self willConfigureCell];

    UITableViewCell *cell = self.cell;
    if (nil != self.cellText)
        cell.textLabel.text = self.cellText;
    if (nil != self.cellDetailText)
        cell.detailTextLabel.text = self.cellDetailText;
    if (nil != self.cellImage)
        cell.imageView.image = self.cellImage;

    if (nil != self.configureCellBlock)
        self.configureCellBlock(self, self.cell);

    [self didConfigureCell];
}

- (void)reloadBoundData
{
    [self willReloadBoundData];
    for (NSString *keyPath in self.boundKeyPaths)
        self[keyPath] = [[self.boundObject valueForKeyPath:keyPath] copy];
    [self didReloadBoundData];
}

- (void)updateObject
{
    [self willUpdateObject];
    for (NSString *keyPath in self.boundKeyPaths)
        [self.boundObject setValue:self[keyPath] forKeyPath:keyPath];
    [self didUpdateObject];
}

#pragma mark - Subclass Hooks

- (void)willBindObject:(id)object withKeyPaths:(NSArray *)keyPaths
{

}

- (void)didBindObject:(id)object withKeyPaths:(NSArray *)keyPaths
{

}

- (void)willConfigureCell
{

}

- (void)didConfigureCell
{

}

- (void)willReloadBoundData
{

}

- (void)didReloadBoundData
{

}

- (void)willUpdateObject
{

}

- (void)didUpdateObject
{

}

#pragma mark - Subscription

- (NSMutableDictionary *)boundObjectData
{
    if (nil == _boundObjectData)
        _boundObjectData = [NSMutableDictionary dictionary];
    return _boundObjectData;
}

- (id)objectForKeyedSubscript:(id)key
{
    return self.boundObjectData[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    if (nil != obj)
        self.boundObjectData[key] = obj;
}


@end
