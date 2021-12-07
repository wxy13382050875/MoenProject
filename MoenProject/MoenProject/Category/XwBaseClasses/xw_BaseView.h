//
//  xw_BaseView.h
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xw_ViewProtocol.h"

@interface xw_BaseView : UIView<xw_ViewProtocol>
//-(void)xw_setupUI;
//-(void)xw_updateConstraints;
@property (nonatomic, copy) void(^didChickEventBlock)(id params);
@end
