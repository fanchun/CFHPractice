//
//  DTGetPlantDataListRequest.h
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTGetPlantDataListResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTGetPlantDataListRequest : NSObject

- (instancetype)initWithLimit:(NSUInteger)limit offset:(NSInteger)offset;

- (void)getWSSuccess:(void (^)(DTGetPlantDataListResponse *response))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
