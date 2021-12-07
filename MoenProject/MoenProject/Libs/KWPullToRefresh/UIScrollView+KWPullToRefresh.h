//
//  UIScrollView+KWPullToRefresh.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/11/5.
//

#import <UIKit/UIKit.h>

/**下拉刷新处理*/
typedef void(^DropDownRefreshHandler)(void);

/**上拉刷新处理*/
typedef void(^PullUpRefreshHandler)(void);

@interface UIScrollView (KWPullToRefresh)

@property (nonatomic, copy) DropDownRefreshHandler dropDownHandler;

@property (nonatomic, copy) PullUpRefreshHandler pullUpHandler;

/**添加下拉刷新*/
- (void)addDropDownRefreshWithActionHandler:(DropDownRefreshHandler)actionHandler;

/**添加上拉刷新*/
- (void)addPullUpRefreshWithActionHandler:(PullUpRefreshHandler)actionHandler;

/**取消刷新操作*/
- (void)cancelRefreshAction;

/**隐藏刷新 Footer*/
- (void)hidenRefreshFooter;

/**隐藏刷新 Hearder*/
- (void)hidenRefreshHearder;

/**显示刷新 Hearder*/
- (void)showRefreshHearder;

/**显示刷新 Footer*/
- (void)showRefreshFooter;
@end
