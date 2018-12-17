//
//  DTPlantInfo.h
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTPlantInfo : NSObject

@property (strong, nonatomic, readonly) NSString *nameCh;
@property (strong, nonatomic, readonly) NSString *location;
@property (strong, nonatomic, readonly) NSString *feature;
@property (strong, nonatomic, readonly) NSString *pictureURL;

- (instancetype)initWithResult:(NSDictionary *)result;

@end

NS_ASSUME_NONNULL_END
