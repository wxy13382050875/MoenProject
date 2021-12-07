//
//  MoenBaseModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "MoenBaseModel.h"

@implementation MoenBaseModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"code" : @"respCode",
             @"message" : @"respMsg",
             @"data" : @"data"
             };
}

@end
