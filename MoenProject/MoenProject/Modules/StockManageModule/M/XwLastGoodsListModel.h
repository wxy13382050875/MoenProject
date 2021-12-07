//
//Created by ESJsonFormatForMac on 21/12/06.
//

#import <Foundation/Foundation.h>

@class Lastgoodslist;
@interface XwLastGoodsListModel : NSObject

@property (nonatomic, copy) NSString *size;

@property (nonatomic, strong) NSArray *LastGoodsList;

@property (nonatomic, copy) NSString *operator;

@property (nonatomic, copy) NSString *operateTime;

@property (nonatomic, copy) NSString *page;

@end
@interface Lastgoodslist : NSObject

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *inventorySortID;

@property (nonatomic, copy) NSString *goodsCountBefor;

@property (nonatomic, copy) NSString *goodsSKU;

@property (nonatomic, copy) NSString *goodsCountAfter;

@property (nonatomic, copy) NSString *goodsID;

@property (nonatomic, copy) NSString *goodsIMG;

@property (nonatomic, copy) NSString *goodsCount;


@end

