//
//  ProductSampleResultModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/15.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ProductSampleResultModel.h"

@implementation ProductSampleResultModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"kOperator":@"operator"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imageUrls" : [ProductSampleResultImageModel class], @"list" : [ProductSampleResultImageModel class]};
}


@end

@implementation ProductSampleResultImageModel

@end
