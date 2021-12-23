//
//Created by ESJsonFormatForMac on 21/12/12.
//

#import <Foundation/Foundation.h>

@class Orderproductinfodatalist;

@interface XwUpdateDeliveryModel : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *appointmentDate;

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, strong) NSArray *orderProductInfoDataList;

@end

@interface Orderproductinfodatalist : NSObject

@property (nonatomic, copy) NSString *notIssuedNum;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *appointmentNum;

@property (nonatomic, copy) NSString *dealerNum;

@property (nonatomic, copy) NSString *goodsSKU;

@property (nonatomic, copy) NSString *shopNum;

@property (nonatomic, copy) NSString *goodsImg;

@property (nonatomic, copy) NSString *sendNum;

@property (nonatomic, copy) NSString *goodsID;

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *inputCount;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *setMealId;

@end

