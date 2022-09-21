//
//  SalesCounterVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesCounterDataModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SalesCounterType)
{
    SalesCounterTypeNone = 0,       //卖货柜台
    SalesCounterTypeReserve = 1,       //预定进入卖货柜台
};
/**卖货柜台*/
@interface SalesCounterVC : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) SalesCounterDataModel *counterDataModel;

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) SalesCounterType type;
@end

NS_ASSUME_NONNULL_END
