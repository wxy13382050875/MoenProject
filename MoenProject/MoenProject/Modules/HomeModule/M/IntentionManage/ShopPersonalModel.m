//
//  ShopPersonalModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ShopPersonalModel.h"

@implementation ShopPersonalModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

@implementation ShopPersonalListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopPersonalList" : [ShopPersonalModel class]};
}
@end
