//
//Created by ESJsonFormatForMac on 21/12/05.
//

#import <Foundation/Foundation.h>

@class Orderlist,Goodslist ,Goodspackage;
@interface xWStockOrderModel : MoenBaseModel


@property (nonatomic, strong) NSArray *orderList;

@end
@interface Orderlist : NSObject

@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, strong) NSArray *goodsList;

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, copy) NSString *goodsType;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *senderKey;

@property (nonatomic, copy) NSString *id;
@end

@interface Goodslist : NSObject
@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *inventorySortID;

@property (nonatomic, copy) NSString *goodsSKU;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *goodsCount;

@property (nonatomic, copy) NSString *goodsStatus;

@property (nonatomic, copy) NSString *orderStatus;

@property (nonatomic, copy) NSString *goodsCountBefor;

@property (nonatomic, copy) NSString *goodsCountAfter;

@property (nonatomic, copy) NSString *goodsPrice;

@property (nonatomic, copy) NSString *goodsIMG;

@property (nonatomic, copy) NSString *goodsID;

@property (nonatomic, strong) Goodspackage *goodsPackage;

@property (nonatomic, assign) BOOL isShowDetail;

@property (nonatomic, copy)NSIndexPath* indexPath;


@property (nonatomic, assign)NSInteger controllerType;


@property (nonatomic, assign) BOOL isProblem;

@property (nonatomic, copy) NSString* deliverCount;

@property (nonatomic, assign) NSInteger sendNum;

@property (nonatomic, assign) NSInteger notSendNum;

//换货单详情
@property (nonatomic, copy) NSString* sendCount;

@property (nonatomic, copy) NSString* oldProduct;

@property (nonatomic, copy) NSString* returnCount;
@end

@interface Goodspackage : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *packageID;

@property (nonatomic, strong) NSArray *goodsList;

@property (nonatomic, copy) NSString *packageStatus;

@property (nonatomic, copy) NSString *goodsID;

@end



