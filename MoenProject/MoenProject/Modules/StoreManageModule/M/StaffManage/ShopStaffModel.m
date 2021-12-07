//
//  ShopStaffModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ShopStaffModel.h"

@implementation ShopStaffModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end


@implementation ShopStaffListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopPersonalList" : [ShopStaffModel class]};
}
@end


@implementation ShopStaffTypeModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

