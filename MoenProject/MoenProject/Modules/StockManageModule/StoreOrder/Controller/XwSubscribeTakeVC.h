//
//  XwSubscribeTakeVC.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/12.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XwSubscribeTakeVC : BaseViewController
@property(nonatomic,strong)NSString* orderID;
@property(nonatomic,strong)NSString* customerId;
/**是否识别*/
@property (nonatomic, assign) BOOL isIdentifion;
@property(nonatomic,strong)NSString* type;
@end

NS_ASSUME_NONNULL_END
