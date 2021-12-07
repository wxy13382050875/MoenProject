//
//  OrderInfoModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end
