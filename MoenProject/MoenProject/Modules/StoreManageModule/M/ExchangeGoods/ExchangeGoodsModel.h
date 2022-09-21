//
//  ExchangeGoodsModel.h
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "MoenBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@class GoodslistModel;
@interface ExchangeGoodsModel : MoenBaseModel
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *giftCount;
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *orderID;
@property (nonatomic, strong) NSArray<GoodslistModel *> *goodsList;
  
@end



@interface GoodslistModel : NSObject

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsStatus;
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, copy) NSString *goodsSKU;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *notSendNum;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *sendNum;
@property (nonatomic, copy) NSString *goodsIMG;
@property (nonatomic, assign) CGFloat square;
@property (nonatomic, copy) NSString *orderItemId;
@end
NS_ASSUME_NONNULL_END
