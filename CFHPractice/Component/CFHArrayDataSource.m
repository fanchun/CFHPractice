//
//  CFHArrayDataSource.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHArrayDataSource.h"

@interface CFHArrayDataSource ()

@property (strong, nonatomic) NSArray *mItems;
@property (copy, nonatomic) NSString *mCellIdentifier;
@property (copy, nonatomic) CFHTableViewCellConfigureBlock mConfigureCellBlock;

@end

@implementation CFHArrayDataSource

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(CFHTableViewCellConfigureBlock)configureCellBlock {
    self = [super init];
    if (self) {
        self.mItems = items;
        self.mCellIdentifier = cellIdentifier;
        self.mConfigureCellBlock = configureCellBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.mItems[indexPath.row];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.mCellIdentifier
                                                            forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.mConfigureCellBlock(cell, item);
    return cell;
}

@end
