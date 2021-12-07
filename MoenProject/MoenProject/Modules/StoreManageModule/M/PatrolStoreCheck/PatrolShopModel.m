//
//  PatrolShopModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PatrolShopModel.h"

@implementation PatrolShopModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

@implementation PatrolShopListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"patrolShopList" : [PatrolShopModel class]};
}
@end
