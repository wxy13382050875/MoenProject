//
//  PackageRankModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageRankModel.h"

@implementation PackageRankModel

@end

@implementation PackageRankListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"setMealList" : [PackageRankModel class]};
}

@end
