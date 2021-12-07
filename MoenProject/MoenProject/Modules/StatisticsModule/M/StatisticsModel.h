//
//  StatisticsModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/1.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatisticsModel : MoenBaseModel

/**今日门店销售额*/
@property (nonatomic, copy) NSString *shopCount;

/**今日套餐销售最佳*/
@property (nonatomic, copy) NSString *setMealName;

/**今日品类销售最佳*/
@property (nonatomic, copy) NSString *categoryName;

/**今日单品销售最佳*/
@property (nonatomic, copy) NSString *productSku;

/**今日客户注册数*/
@property (nonatomic, copy) NSString *customerCount;

/**商品名称*/
@property (nonatomic, copy) NSString *productName;

/**套餐描述*/
@property (nonatomic, copy) NSString *setMealInfo;

/**门店排名提醒*/
@property (nonatomic, copy) NSString *saleRemind;

@end


@interface StatisticsTVModel : MoenBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) UIColor *contentColor;

@end


NS_ASSUME_NONNULL_END
