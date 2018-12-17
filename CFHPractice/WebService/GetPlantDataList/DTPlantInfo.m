//
//  DTPlantInfo.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "DTPlantInfo.h"

// Key
static NSString * const kDTPlantInfoNameCh      = @"F_Name_Ch";
static NSString * const kDTPlantInfoFeature     = @"F_Feature";
static NSString * const kDTPlantInfoLocation    = @"F_Location";
static NSString * const kDTPlantInfoPic01URL    = @"F_Pic01_URL";

@implementation DTPlantInfo

- (instancetype)initWithResult:(NSDictionary *)result {
    self = [super init];
    if (self) {
        _nameCh     = result[kDTPlantInfoNameCh];
        _feature    = result[kDTPlantInfoFeature];
        _location   = result[kDTPlantInfoLocation];
        _pictureURL = result[kDTPlantInfoPic01URL];
    }
    return self;
}

@end
