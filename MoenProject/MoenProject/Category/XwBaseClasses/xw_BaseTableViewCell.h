//
//  xw_BaseTableViewCell.h
//  XW_Object
//
//  Created by 武新义 on 2019/11/19.
//  Copyright © 2019年 武新义. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xw_ViewProtocol.h"
@interface xw_BaseTableViewCell : SKSTableViewCell<xw_ViewProtocol>
@property(nonatomic,assign)CGFloat xw_height;
@property(nonatomic,strong)id viewMode;
@property (nonatomic, copy) void(^didChickEventBlock)(id params);

@end
