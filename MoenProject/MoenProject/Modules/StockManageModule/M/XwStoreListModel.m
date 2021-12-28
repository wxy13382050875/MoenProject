//
//Created by ESJsonFormatForMac on 21/12/23.
//

#import "XwStoreListModel.h"
#import "XwInventoryModel.h"
@implementation XwStoreListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"storeList" : [Storelist class]};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"storeList" : @"Storelist"
             };
}

@end

@implementation Storelist

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"inventoryList" : @"Inventorylist"
             };
}

@end




