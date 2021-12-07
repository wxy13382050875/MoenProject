//
//  GoodsSalesVolumeModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsSalesVolumeModel.h"

@implementation GoodsSalesVolumeModel

@end

@implementation GoodsSalesVolumeListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productList" : [GoodsSalesVolumeModel class]};
}

@end

