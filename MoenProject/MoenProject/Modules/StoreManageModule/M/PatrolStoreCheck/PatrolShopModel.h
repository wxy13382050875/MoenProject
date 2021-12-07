//
//  PatrolShopModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PatrolShopModel : MoenBaseModel

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *result;

@property (nonatomic, copy) NSString *reason;
@end

@class PatrolShopModel;
@interface PatrolShopListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<PatrolShopModel *> *patrolShopList;

@end
NS_ASSUME_NONNULL_END
