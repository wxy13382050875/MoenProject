//
//  xw_BaseViewModelProtocol.h
//  XW_Object
//
//  Created by Benc Mai on 2019/11/28.
//  Copyright © 2019 武新义. All rights reserved.
//

#ifndef xw_ViewModelProtocol_h
#define xw_ViewModelProtocol_h


typedef enum : NSUInteger {
    xw_HeaderRefresh_HasMoreData = 1,
    xw_HeaderRefresh_HasNoMoreData,
    xw_FooterRefresh_HasMoreData,
    xw_FooterRefresh_HasNoMoreData,
    xw_RefreshError,
    xw_RefreshUI,
} LSRefreshDataStatus;

@protocol xw_ViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

//@property (strong, nonatomic)CMRequest *request;

/**
 *  初始化
 */
- (void)xw_initialize;
@end
#endif /* xw_BaseViewModelProtocol_h */
