//
//  SCExpandModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SCExpandModel.h"

@implementation SCExpandModel


@end

@implementation SCExpandCustomerModel
@end




@implementation SCExpandListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"monthCoustomerDetail" : [SCExpandModel class],@"customerList":[SCExpandCustomerModel class]};
}

@end
