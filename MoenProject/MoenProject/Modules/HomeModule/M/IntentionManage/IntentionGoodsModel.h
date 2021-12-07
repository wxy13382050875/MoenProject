//
//  IntentionGoodsModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/10.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IntentionGoodsModel;
@interface IntentionListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<IntentionGoodsModel *> *intentInfoList;

@end


@class IntentionProductModel;
@interface IntentionGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger intentId;

@property (nonatomic, copy) NSString *businessRole;

@property (nonatomic, assign) BOOL isIntent;

//是否是模拟数据
@property (nonatomic, assign) BOOL isSimulation;

@property (nonatomic, strong) NSArray<IntentionProductModel *> *intentProductList;

@property (nonatomic, strong) NSArray<IntentionProductModel *> *productList;

@end


@interface IntentionProductModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *createDate;

@end

NS_ASSUME_NONNULL_END
