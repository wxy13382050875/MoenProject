//
//  HomeDataModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/17.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HomeBannerModel;

@interface HomeDataModel : MoenBaseModel

/**是否存在新促销*/
@property (nonatomic, assign) BOOL newPromotion;

/**是否存在新套餐*/
@property (nonatomic, assign) BOOL newCombo;

@property (nonatomic, assign) BOOL useInventory;

/**banner图url*/
@property (nonatomic, strong) NSArray<HomeBannerModel *> *bannerImageData;

@end

@interface HomeBannerModel : MoenBaseModel

/**banner图url*/
@property (nonatomic, copy) NSString *forwardUrl;

/**点击banner图跳转网址*/
@property (nonatomic, copy) NSString *bannerImageUrl;

/**备注*/
@property (nonatomic, copy) NSString *desc;


@end

NS_ASSUME_NONNULL_END
