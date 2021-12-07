//
//  GoodsCategoryRankModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/1.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "GoodsCategoryRankModel.h"

@implementation GoodsCategoryRankModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end


@implementation GoodsCategoryRankListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"categoryList" : [GoodsCategoryRankModel class]};
}
@end
