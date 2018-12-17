//
//  DTGetPlantDataListRequest.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "DTGetPlantDataListRequest.h"
#import "DataTaipeiDefine.h"
#import <AFNetworking.h>



// Request Key
static NSString * const kDTGetPlantDataListReqScope     = @"scope";
static NSString * const kDTGetPlantDataListReqRid       = @"rid";
static NSString * const kDTGetPlantDataListReqLimit     = @"limit";
static NSString * const kDTGetPlantDataListReqOffset    = @"offset";

// Response Key
static NSString * const kDTGetPlantDataListRespResult   = @"result";

@interface DTGetPlantDataListRequest ()

@property (assign, nonatomic) NSUInteger mLimit;
@property (assign, nonatomic) NSUInteger mOffset;

@end

@implementation DTGetPlantDataListRequest

- (instancetype)initWithLimit:(NSUInteger)limit offset:(NSInteger)offset {
    self = [super init];
    if (self) {
        _mLimit = limit;
        _mOffset = offset;
    }
    return self;
}

- (void)getWSSuccess:(void (^)(DTGetPlantDataListResponse * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSMutableDictionary *dicParameters = [NSMutableDictionary dictionary];
    dicParameters[kDTGetPlantDataListReqScope]  = DataTaipeiParameterScope;
    dicParameters[kDTGetPlantDataListReqRid]    = DataTaipeiParameterRid;
    dicParameters[kDTGetPlantDataListReqLimit]  = @(_mLimit);
    dicParameters[kDTGetPlantDataListReqOffset] = @(_mOffset);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:DataTaipeiURL
      parameters:dicParameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dicJson = (NSDictionary *)responseObject;
             DTGetPlantDataListResponse *resposne = [[DTGetPlantDataListResponse alloc] initWithResult:dicJson[kDTGetPlantDataListRespResult]];
             success(resposne);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure(error);
             
         }];
}


@end
