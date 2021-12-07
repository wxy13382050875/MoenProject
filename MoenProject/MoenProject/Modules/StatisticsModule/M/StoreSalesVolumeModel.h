//
//  StoreSalesVolumeModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/31.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreSalesVolumeModel : MoenBaseModel

@property (nonatomic, copy) NSString *shopPersonalName;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *orderAmount;

@property (nonatomic, copy) NSString *customerTransaction;

@property (nonatomic, copy) NSString *shopPersonalId;


@end


@class StoreSalesVolumeModel;
@interface StoreSalesVolumeListModel : MoenBaseModel

@property (nonatomic, copy) NSString *orderAmountCount;

@property (nonatomic, copy) NSString *customerTransaction;

@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, strong) NSArray<StoreSalesVolumeModel *> *shopData;

@end

NS_ASSUME_NONNULL_END
