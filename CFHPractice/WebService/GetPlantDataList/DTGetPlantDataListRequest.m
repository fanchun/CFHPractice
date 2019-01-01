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

static NSString * const kScope  = @"scope";
static NSString * const kRid    = @"rid";
static NSString * const kLimit  = @"limit";
static NSString * const kOffset = @"offset";

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
    dicParameters[kScope]   = DataTaipeiDefineParameterScope;
    dicParameters[kRid]     = DataTaipeiDefineParameterRid;
    dicParameters[kLimit]   = @(_mLimit);
    dicParameters[kOffset]  = @(_mOffset);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:DataTaipeiDefineURL
      parameters:dicParameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSDictionary *dicJson = (NSDictionary *)responseObject;
             DTGetPlantDataListResponse *resposne = [[DTGetPlantDataListResponse alloc] initWithResult:dicJson[DTGetPlantDataListResponseResult]];
             success(resposne);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             failure(error);
             
         }];
}


@end
