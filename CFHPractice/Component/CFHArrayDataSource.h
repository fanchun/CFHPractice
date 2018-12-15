//
//  CFHArrayDataSource.h
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CFHTableViewCellConfigureBlock)(id cell, id item);

NS_ASSUME_NONNULL_BEGIN

@interface CFHArrayDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items
               cellIdentifier:(NSString *)cellIdentifier
           configureCellBlock:(CFHTableViewCellConfigureBlock)configureCellBlock;

- (instancetype)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
