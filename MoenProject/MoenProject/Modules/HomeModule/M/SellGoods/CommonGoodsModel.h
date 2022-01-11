//
//  CommonGoodsModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/18.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CommonGoodsModel;
@interface CommonGoodsListModel : MoenBaseModel

/**商品集合*/
@property (nonatomic, strong) NSArray *selectProducts;

@end


@class CommonProdutcModel, CommonTVDataModel;

@interface CommonGoodsModel : NSObject<NSCopying>

/** 经销商发布id或者经销商活动套餐id*/
@property (nonatomic, copy) NSMutableString *ID;

/** 经销商发布id或者经销商活动套餐id*/
@property (nonatomic, copy) NSString *id;

/** 名称*/
@property (nonatomic, copy) NSMutableString *name;

/** 名称*/
@property (nonatomic, copy) NSMutableString *code;

/** sku或者套餐号*/
@property (nonatomic, copy) NSMutableString *gcode;

/** 价格*/
@property (nonatomic, copy) NSMutableString *price;

/** 图片*/
@property (nonatomic, copy) NSMutableString *photo;

/** 活动名称*/
@property (nonatomic, copy) NSMutableString *activityName;

/** 套餐描述*/
@property (nonatomic, copy) NSMutableString *comboDescribe;

/** 是否套餐*/
@property (nonatomic, assign) BOOL isSetMeal;

/** 是否特殊单品*/
@property (nonatomic, assign) BOOL isSpecial;

/**套餐对应的商品集合*/
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *productList;


@property (nonatomic, strong) NSMutableArray *sectionCellList;

/**tableView 数据缓存*/
@property (nonatomic, assign) BOOL isOpenShow;

/**是否展示详情*/
@property (nonatomic, assign) BOOL isShowDetail;

/**商品数量*/
@property (nonatomic, assign) NSInteger kGoodsCount;
/**商品面积*/
@property (nonatomic, assign) CGFloat kGoodsArea;

/**增项加价*/
@property (nonatomic, assign) double kAddPrice;
/**PU单号*/
@property (nonatomic, copy) NSMutableString *kGoodsCode;

/**最小平方数*/
@property (nonatomic, copy) NSMutableString *minNum;

/**商品数量*/
@property (nonatomic, assign) NSInteger count;

@end


@interface CommonProdutcModel : MoenBaseModel<NSCopying>

/** 商品sku*/
@property (nonatomic, copy) NSMutableString *sku;

/** 商品名称*/
@property (nonatomic, copy) NSMutableString *name;

/** 图片*/
@property (nonatomic, copy) NSString *photo;

/** 价格*/
@property (nonatomic, copy) NSMutableString *price;

/**商品数量*/
@property (nonatomic, assign) NSInteger count;

/**pu单号*/
@property (nonatomic, copy) NSMutableString *codePu;

/**增项加价*/
@property (nonatomic, copy) NSMutableString *addPrice;

/**平方*/
@property (nonatomic, copy) NSMutableString *square;

/**已退商品数量*/
@property (nonatomic, assign) NSInteger returnCount;

/**是否特殊单品，true:淋浴房，需要呈现增价、平方、pu单号*/
@property (nonatomic, assign) BOOL isSpecial;


//：已发数量（新增）
@property (nonatomic, copy) NSString *deliverCount;

//：总仓预约（新增）
@property (nonatomic, copy) NSString *waitDeliverCount;



@end


/**套餐商品数据模型*/
@class CommonProdutcModel;
@interface CommonMealProdutcModel : MoenBaseModel

/** 套餐描述*/
@property (nonatomic, copy) NSString *comboDescribe;

/** 套餐名称*/
@property (nonatomic, copy) NSString *comboName;

/** 套餐号*/
@property (nonatomic, copy) NSString *codeStr;

/** 价格*/
@property (nonatomic, copy) NSString *price;

/**商品数量*/
@property (nonatomic, assign) NSInteger count;

/**图片*/
@property (nonatomic, copy) NSString *photo;

/**套餐对应的商品集合*/
@property (nonatomic, strong) NSArray<CommonProdutcModel *> *productList;


/**用于单品*/
@property (nonatomic, copy) NSString *codePu;
@property (nonatomic, copy) NSString *addPrice;
@property (nonatomic, copy) NSString *square;

@property (nonatomic, assign) NSInteger returnCount;
@property (nonatomic, assign) BOOL isSpecial;
/** 是否套餐*/
@property (nonatomic, assign) BOOL isSetMeal;
/** 是否套餐*/
@property (nonatomic, assign) BOOL isShowDetail;
//：已发数量（新增）
@property (nonatomic, copy) NSString *deliverCount;

//：总仓预约（新增）
@property (nonatomic, copy) NSString *waitDeliverCount;
@end


NS_ASSUME_NONNULL_END
