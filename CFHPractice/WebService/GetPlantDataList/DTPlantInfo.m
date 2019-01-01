//
//  DTPlantInfo.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "DTPlantInfo.h"

// Key
static NSString * const kNameCh     = @"F_Name_Ch";
static NSString * const kFeature    = @"F_Feature";
static NSString * const kLocation   = @"F_Location";
static NSString * const kPic01URL   = @"F_Pic01_URL";

@implementation DTPlantInfo

- (instancetype)initWithResult:(NSDictionary *)result {
    self = [super init];
    if (self) {
        _nameCh     = result[kNameCh];
        _feature    = result[kFeature];
        _location   = result[kLocation];
        _pictureURL = result[kPic01URL];
    }
    return self;
}

@end
