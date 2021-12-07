//
//  CommonTypeModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CommonTypeModel.h"

@implementation CommonTypeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end


@implementation CommonTypeListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"listData" : [CommonTypeModel class], @"MealMainData" : [CommonTypeModel class]};
}
@end
