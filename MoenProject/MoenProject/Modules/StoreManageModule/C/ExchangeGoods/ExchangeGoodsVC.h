//
//  ExchangeGoodsVC.h
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeGoodsVC : BaseViewController
/**用户ID*/
@property (nonatomic, copy) NSString *customerId;

/**是否识加*/
@property (nonatomic, assign) BOOL isIdentifion;

@end

NS_ASSUME_NONNULL_END
