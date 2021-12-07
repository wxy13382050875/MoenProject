//
//  StoreSalesVolumeModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreSalesVolumeModel.h"

@implementation StoreSalesVolumeModel

@end

@implementation StoreSalesVolumeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shopData" : [StoreSalesVolumeModel class]};
}

@end
