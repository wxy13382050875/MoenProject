
//
//  CommonCategoryModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "CommonCategoryModel.h"

@implementation CommonCategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"datas" : [CommonCategoryDataModel class]};
}
@end

@implementation CommonCategoryDataModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation CommonCategoryListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"enums" : [CommonCategoryModel class]};
}

@end
