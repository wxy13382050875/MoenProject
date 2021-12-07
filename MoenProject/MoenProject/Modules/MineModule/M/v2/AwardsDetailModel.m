//
//  AwardsDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/16.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "AwardsDetailModel.h"

@implementation AwardsDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rewardList" : [AwardsDetailItemModel class]};
}
@end




@implementation AwardsDetailItemModel

@end
