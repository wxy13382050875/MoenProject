//
//  ReturnAllGoodsCounterVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/25.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**整单退货*/
@interface ReturnAllGoodsCounterVC : BaseViewController

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, assign) BOOL wholeOtherReturn;

@end

NS_ASSUME_NONNULL_END
