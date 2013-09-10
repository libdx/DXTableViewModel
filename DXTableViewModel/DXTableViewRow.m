//
//  DXTableViewRow.m
//  Quiz
//
//  Created by Alexander Ignatenko on 9/9/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "DXTableViewRow.h"
#import "DXTableViewModel.h"

@interface DXTableViewModel (ForTableViewRowEyes)

@property (nonatomic, readonly, getter=isTableViewDidAppear) BOOL tableViewDidAppear;

@end

@implementation DXTableViewRow

// TODO add checks for isTableViewDidAppear in setters

@end
