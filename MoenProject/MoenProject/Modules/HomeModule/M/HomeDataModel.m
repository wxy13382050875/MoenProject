//
//  HomeDataModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/17.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "HomeDataModel.h"

@implementation HomeDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bannerImageData" : [HomeBannerModel class]};
}

@end

@implementation HomeBannerModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"desc":@"description"};
}
@end
