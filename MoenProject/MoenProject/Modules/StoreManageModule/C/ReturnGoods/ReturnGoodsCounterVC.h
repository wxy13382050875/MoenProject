//
//  ReturnGoodsCounterVC.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**退货柜台*/
@interface ReturnGoodsCounterVC : BaseViewController

@property (nonatomic, copy) NSString *orderID;

@property (nonatomic, strong) NSArray *paramArr;

@end

NS_ASSUME_NONNULL_END
