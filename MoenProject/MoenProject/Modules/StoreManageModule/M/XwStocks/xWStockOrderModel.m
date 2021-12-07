//
//Created by ESJsonFormatForMac on 21/12/05.
//

#import "xWStockOrderModel.h"
@implementation xWStockOrderModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"orderList" : @"Orderlist"
             };
}

@end

@implementation Orderlist

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goodsList" : @"Goodslist"
             };
}

@end


@implementation Goodslist


@end

@implementation Goodspackage

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goodsList" : @"Goodslist"
             };
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

