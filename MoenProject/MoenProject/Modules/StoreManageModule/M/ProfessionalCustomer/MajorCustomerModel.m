//
//  MajorCustomerModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "MajorCustomerModel.h"

@implementation MajorCustomerModel

@end


@implementation MajorCustomerListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"specialtyCustomerList" : [MajorCustomerModel class]};
}

@end
