//
//  DTGetPlantDataListResponse.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "DTGetPlantDataListResponse.h"

static NSString * const kDTGetPlantDataListRespCount    = @"count";
static NSString * const kDTGetPlantDataListRespLimit    = @"limit";
static NSString * const kDTGetPlantDataListRespOffset   = @"offset";
static NSString * const kDTGetPlantDataListRespResults  = @"results";

@implementation DTGetPlantDataListResponse

- (instancetype)initWithResult:(NSDictionary *)result {
    self = [super init];
    if (self) {
        _count  = [result[kDTGetPlantDataListRespCount] unsignedIntegerValue];
        _limit  = [result[kDTGetPlantDataListRespLimit] unsignedIntegerValue];
        _offset = [result[kDTGetPlantDataListRespOffset] unsignedIntegerValue];
        
        NSMutableArray *arPlantInfos = [NSMutableArray arrayWithCapacity:_count];
        for (NSDictionary *dicPlantInfo in result[kDTGetPlantDataListRespResults]) {
            DTPlantInfo *plantInfo = [[DTPlantInfo alloc] initWithResult:dicPlantInfo];
            [arPlantInfos addObject:plantInfo];
        }
        _plantInfos = arPlantInfos;
    }
    return self;
}


@end
