//
//  AddressInfoModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddressInfoModel.h"

@implementation AddressInfoModel

@end


@implementation AddressListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"addressList" : [AddressInfoModel class]};
}
@end


