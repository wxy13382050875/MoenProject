//
//Created by ESJsonFormatForMac on 21/12/06.
//

#import <Foundation/Foundation.h>

@class OrderlistModel;
@interface XwInOrOutWaterModel : NSObject

@property (nonatomic, strong) NSArray *orderList;

@end
@interface OrderlistModel : NSObject

@property (nonatomic, copy) NSString *goodsIMG;

@property (nonatomic, copy) NSString *goodIMG;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *goodsSKU;

@property (nonatomic, copy) NSString *businessType;

@property (nonatomic, copy) NSString *operateType;

@property (nonatomic, copy) NSString *goodsID;

@property (nonatomic, copy) NSString *businessTime;

@property (nonatomic, copy) NSString *businessID;

@end

