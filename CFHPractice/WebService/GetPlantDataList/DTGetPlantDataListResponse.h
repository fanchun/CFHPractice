//
//  DTGetPlantDataListResponse.h
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTPlantInfo.h"

extern NSString * const DTGetPlantDataListResponseResult;

NS_ASSUME_NONNULL_BEGIN

@interface DTGetPlantDataListResponse : NSObject

@property (assign, nonatomic, readonly) NSUInteger count;
@property (assign, nonatomic, readonly) NSUInteger limit;
@property (assign, nonatomic, readonly) NSUInteger offset;
@property (strong, nonatomic, readonly) NSArray *plantInfos;

- (instancetype)initWithResult:(NSDictionary *)result;

@end

NS_ASSUME_NONNULL_END
