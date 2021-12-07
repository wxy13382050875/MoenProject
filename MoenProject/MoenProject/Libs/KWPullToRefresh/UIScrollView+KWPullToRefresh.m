//
//  UIScrollView+KWPullToRefresh.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/11/5.
//

#import "UIScrollView+KWPullToRefresh.h"
#import <objc/runtime.h>
#import "MJRefresh.h"
#import "HXDRefreshHeader.h"
#import "HXDRefreshFooter.h"
@interface UIScrollView ()
@end

@implementation UIScrollView (KWPullToRefresh)

static char *dropDownRefreshKey = "dropDownRefreshHandler";
static char *pullUpRefreshKey = "pullUpRefreshHandler";

//
- (DropDownRefreshHandler)dropDownHandler
{
    return objc_getAssociatedObject(self, dropDownRefreshKey);
}

- (void)setDropDownHandler:(DropDownRefreshHandler)dropDownHandler
{
    objc_setAssociatedObject(self, dropDownRefreshKey, dropDownHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//

- (PullUpRefreshHandler)pullUpHandler
{
    return objc_getAssociatedObject(self, pullUpRefreshKey);
}

- (void)setPullUpHandler:(PullUpRefreshHandler)pullUpHandler
{
    objc_setAssociatedObject(self, pullUpRefreshKey, pullUpHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




#pragma Mark -- Method


- (void)addDropDownRefreshWithActionHandler:(DropDownRefreshHandler)actionHandler
{
    self.dropDownHandler = actionHandler;
    self.mj_header = [HXDRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}


- (void)addPullUpRefreshWithActionHandler:(PullUpRefreshHandler)actionHandler
{
    self.pullUpHandler = actionHandler;
    self.mj_footer = [HXDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)cancelRefreshAction
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)hidenRefreshFooter
{
    [self.mj_footer setHidden:YES];
}

- (void)hidenRefreshHearder
{
    [self.mj_header setHidden:YES];
}

- (void)showRefreshHearder
{
    //下拉刷新 取消上拉刷新的限制
    if (self.mj_header.isHidden) {
        [self.mj_header setHidden:NO];
    }
}

- (void)showRefreshFooter
{
    //下拉刷新 取消上拉刷新的限制
    if (self.mj_footer.isHidden) {
        [self.mj_footer setHidden:NO];
    }
}


- (void)loadNewData{
    
    if (self.dropDownHandler) {
        //下拉刷新 取消上拉刷新的限制
        if (self.mj_footer.isHidden) {
            [self.mj_footer setHidden:NO];
        }
        self.dropDownHandler();
    }
}

- (void)loadMoreData{
    if (self.pullUpHandler) {
        self.pullUpHandler();
    }
}






@end
