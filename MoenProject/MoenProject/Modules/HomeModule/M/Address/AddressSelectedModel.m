//
//  AddressSelectedModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "AddressSelectedModel.h"

@implementation AddressSelectedModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

@implementation AddressSelectedListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"provinceList" : [AddressSelectedModel class], @"cityList" : [AddressSelectedModel class], @"districtList" : [AddressSelectedModel class], @"streetList" : [AddressSelectedModel class]};
}
@end
