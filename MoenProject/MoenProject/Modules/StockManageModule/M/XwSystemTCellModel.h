//
//  XwSystemTCellModel.h
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XwSystemTCellModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *deliverID;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) NSString *type;//select 时间弹框 skip 跳转页面
@end

NS_ASSUME_NONNULL_END
