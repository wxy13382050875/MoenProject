//
//  StoreSalesPersonalModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreSalesPersonalModel : MoenBaseModel

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *orderAmount;

@property (nonatomic, copy) NSString *customerTransaction;

@end

@class StoreSalesPersonalModel;
@interface StoreSalesPersonalListModel : MoenBaseModel

@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, copy) NSString *orderAmountCount;

@property (nonatomic, copy) NSString *customerTransaction;

@property (nonatomic, strong) NSArray<StoreSalesPersonalModel *> *shopData;

@end

NS_ASSUME_NONNULL_END
