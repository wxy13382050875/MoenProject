//
//  GoodsDetailModel.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id",@"smallImageUrlC":@"smallImageUrl"};
}
@end


@implementation GoodsListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productListDetailData" : [GoodsDetailModel class]};
}

@end
