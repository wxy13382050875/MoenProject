//
//Created by ESJsonFormatForMac on 21/12/06.
//

#import <Foundation/Foundation.h>

@class Inventorylist;
@interface XwInventoryModel : NSObject

@property (nonatomic, copy) NSString *inventoryNo;
@property (nonatomic, strong) NSArray *inventoryList;

@end
@interface Inventorylist : NSObject

@property (nonatomic, copy) NSString *goodsSKU;

@property (nonatomic, copy) NSString *goodsID;

@property (nonatomic, copy) NSString *inventoryCount;

@property (nonatomic, copy) NSString *inventorySortID;

@property (nonatomic, copy) NSString *goodsIMG;

@property (nonatomic, copy) NSString *goodsName;

@end

