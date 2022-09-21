//
//  ExchangProductInfoModel.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "ExchangProductInfoModel.h"
@implementation ExchangProductInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"giftInfo" : @"GiftinfoModel",
             @"productInfo" : @"ProductinfoModel"
             };
}
@end
@implementation GiftinfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"productList" : @"ProductlistModel",
             @"setMealInfos" : @"SetmealinfosModel"
             };
}
@end
@implementation SetmealinfosModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"productList" : @"ProductlistModel",
             };
}
@end
@implementation ProductlistModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"type" : @"TypeModel",
    };
}
@end
@implementation ProductinfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"productList" : @"ProductlistModel",
             @"setMealInfos" : @"SetmealinfosModel"
             };
}

@end

@implementation TypeModel


@end


