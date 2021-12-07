//
//  ReturnOrderDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnOrderDetailModel.h"

@implementation ReturnOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [ReturnOrderDetailGoodsModel class]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id", @"returnCode":@"code"};
}
@end

@implementation ReturnOrderDetailGoodsModel

@end


