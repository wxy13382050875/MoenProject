//
//  UnLabelUserInfoModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "UnLabelUserInfoModel.h"

@implementation UnLabelUserInfoModel

@end


@implementation UnLabelUserListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"notLabelList" : [UnLabelUserInfoModel class]};
}

@end
