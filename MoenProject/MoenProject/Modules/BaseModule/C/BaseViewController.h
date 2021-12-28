//
//  BaseViewController.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"


/**
 *  Nav 返回按钮颜色类型
 */
typedef NS_ENUM(NSUInteger, NavBackBtnImageType)
{
    NavBackBtnImageWhiteType = 0,       //白色返回按钮
    NavBackBtnImageBlackType = 1,       //黑色按钮
};

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

/**是否是再次进入*/
//@property (nonatomic, assign) BOOL isAgainEnter;

/**
 *  显示后退按钮
 *  0 灰色
 *  1 白色
 */
- (void)setShowBackBtn:(BOOL)showBackBtn type:(NavBackBtnImageType)type;

- (void)backBthOperate;


//1、GET请求 0、POST请求
@property (nonatomic,assign) BOOL  requestType;
@property (nonatomic, assign) BOOL isDamping;
@property (nonatomic,strong) NSDictionary *requestParams;
@property (nonatomic,copy) NSString *requestURL;
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr; // subclass can override


@property (nonatomic, strong) UIScrollView *comScrollerView;
@property (nonatomic, assign) BOOL isShowEmptyData;
/**无数据描述*/
@property (nonatomic, copy) NSString *noDataDes;


@property (nonatomic, assign) BOOL isShowNoNetwork;
/**隐藏无数据页面*/
- (void)hiddenEmptyDataView;
/**Reconnect刷新操作*/
- (void)reconnectNetworkRefresh;

@end

NS_ASSUME_NONNULL_END
