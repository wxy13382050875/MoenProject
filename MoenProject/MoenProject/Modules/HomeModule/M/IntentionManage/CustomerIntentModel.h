//
//  CustomerIntentModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerIntentGoodsModel;
@interface CustomerIntentModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *custCode;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger productCount;

@property (nonatomic, assign) BOOL isShowDetail;

@property (nonatomic, strong) NSArray<CustomerIntentGoodsModel *> *productList;

@end


@class CustomerIntentModel;
@interface CustomerIntentListModel : MoenBaseModel


@property (nonatomic, strong) NSArray<CustomerIntentModel *> *customerIntentList;

@end




@interface CustomerIntentGoodsModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *sku;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *createDate;

@end



NS_ASSUME_NONNULL_END
