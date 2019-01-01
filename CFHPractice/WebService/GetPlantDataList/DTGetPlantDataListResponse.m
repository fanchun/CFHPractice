//
//  DTGetPlantDataListResponse.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "DTGetPlantDataListResponse.h"

NSString * const DTGetPlantDataListResponseResult = @"result";

static NSString * const kCount      = @"count";
static NSString * const kLimit      = @"limit";
static NSString * const kOffset     = @"offset";
static NSString * const kResults    = @"results";

@implementation DTGetPlantDataListResponse

- (instancetype)initWithResult:(NSDictionary *)result {
    self = [super init];
    if (self) {
        _count  = [result[kCount] unsignedIntegerValue];
        _limit  = [result[kLimit] unsignedIntegerValue];
        _offset = [result[kOffset] unsignedIntegerValue];
        
        NSMutableArray *arPlantInfos = [NSMutableArray arrayWithCapacity:_count];
        for (NSDictionary *dicPlantInfo in result[kResults]) {
            DTPlantInfo *plantInfo = [[DTPlantInfo alloc] initWithResult:dicPlantInfo];
            [arPlantInfos addObject:plantInfo];
        }
        _plantInfos = arPlantInfos;
    }
    return self;
}


@end
