//
//  CommonTypeModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTypeModel : MoenBaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *name;

@end

@class CommonTypeModel;
@interface CommonTypeListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<CommonTypeModel *> *listData;

@property (nonatomic, strong) NSArray<CommonTypeModel *> *MealMainData;
@end

NS_ASSUME_NONNULL_END
