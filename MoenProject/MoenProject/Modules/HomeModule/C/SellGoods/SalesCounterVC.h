//
//  SalesCounterVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

/**卖货柜台*/
@interface SalesCounterVC : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArr;

/**用户ID*/
@property (nonatomic, copy) NSString *customerId;
@end

NS_ASSUME_NONNULL_END
