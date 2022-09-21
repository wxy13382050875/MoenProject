//
//  ExchangProductInfoModel.h
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "MoenBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@class GiftinfoModel,SetmealinfosModel,ProductlistModel,ProductinfoModel,TypeModel;
@interface ExchangProductInfoModel : MoenBaseModel
@property (nonatomic, strong) GiftinfoModel *giftInfo;
@property (nonatomic, strong) ProductinfoModel *productInfo;
@end



@interface GiftinfoModel : NSObject

@property (nonatomic, strong) NSArray<ProductlistModel *> *productList;
@property (nonatomic, strong) NSArray<SetmealinfosModel *> *setMealInfos;

@end

@interface SetmealinfosModel : NSObject

@property (nonatomic, copy) NSString *goodsIMG;
@property (nonatomic, copy) NSString *goodsSKU;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, strong) NSArray<ProductlistModel *> *productList;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *goodsDescribe;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, assign) BOOL isShowDetail;
@property (nonatomic, assign) BOOL isSetMeal;
@property (nonatomic, assign) NSInteger atIndex;

@end

@interface ProductlistModel : NSObject

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsStatus;
@property (nonatomic, copy) NSString *goodsCount;
@property (nonatomic, assign) BOOL isCan;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *goodsSKU;
@property (nonatomic, strong) TypeModel *type;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, copy) NSString *goodsIMG;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, copy) NSString *nGoodsID;
@property (nonatomic, copy) NSString *nGoodsSKU;
@property (nonatomic, copy) NSString *nGoodsIMG;
@property (nonatomic, copy) NSString *nGoodsName;
@end

@interface ProductinfoModel : NSObject

@property (nonatomic, strong) NSArray<ProductlistModel *> *productList;
@property (nonatomic, strong) NSArray<SetmealinfosModel *> *setMealInfos;

@end


@interface TypeModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *des;

@end
NS_ASSUME_NONNULL_END
