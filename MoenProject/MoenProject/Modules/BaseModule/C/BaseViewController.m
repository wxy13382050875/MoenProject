//
//  BaseViewController.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "BaseViewController.h"
#import "NSHttpClient.h"
#import "UINavigationItem+NSAdditions.h"


@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppBgBlueGrayColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}


/*显示后退按钮
 * 1 灰色
 * 0 白色
 */
- (void)setShowBackBtn:(BOOL)showBackBtn type:(NavBackBtnImageType)type{
    
    if (!showBackBtn) {
        return;
    }
    NSString *backNormalImg = @"";
    NSString *backHighImg = @"";
    
    switch (type) {
        case NavBackBtnImageWhiteType:
        {//白色
            backNormalImg = @"c_back_white_icon";
            backHighImg = @"c_back_white_hl_icon";
        }
            break;
        case NavBackBtnImageBlackType:
        {
            backNormalImg = @"n_back_black_icon";
            backHighImg = @"n_back_black_hl_icon";
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    WEAKSELF
    [self.navigationItem actionCustomLeftBarButton:nil
                                          nrlImage:backNormalImg
                                          hltImage:backHighImg
                                            action:^{
        [weakSelf backBthOperate];
                                            }];
}

-(void)backBthOperate{
    if (!self) {
        return ;
    }
    if (self.navigationController.presentingViewController && [self isEqual:self.navigationController.viewControllers.firstObject]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - settter & getter
-(void)setRequestType:(BOOL)requestType
{
    _requestType = requestType;
}

- (void)setRequestURL:(NSString *)url {
    
//    NSString *accessToken = nil;
    
    _requestURL = url;
    
    WEAKSELF
    /**
     *  type 为真  get
     */
    NSURLSessionDataTask *operation =[[NSHttpClient client] asyncRequestWithURL:url
                                                                           type:self.requestType
                                                                          paras:self.requestParams
                                                                        success:^(NSURLSessionDataTask *operation, NSObject *parserObject)
                                      {
                                          MoenBaseModel *responseModel = (MoenBaseModel *)parserObject;
                                          
                                          [weakSelf actionFetchRequest:operation
                                                                result:responseModel
                                                                 error:nil];
                                          weakSelf.isShowNoNetwork = NO;
                                          [weakSelf.comScrollerView reloadEmptyDataSet];
                                    }
                                                                        failure:^(NSURLSessionDataTask *operation, NSError *requestErr) {
                                                                            
                                                                            [weakSelf actionFetchRequest:operation result:nil error:requestErr];
                                                                            if ([requestErr.domain isEqualToString:@"NSURLErrorDomain"]) {
                                                                                weakSelf.isShowNoNetwork = YES;
                                                                                [weakSelf.comScrollerView reloadEmptyDataSet];
                                                                                [[NSToastManager manager] showtoast:@"网络开小差了，请检查您的网络!"];
                                                                            }
                                                                            
                                                                            
                                                                            /*
                                                                             [wSelf.view configBlankPageHasData:YES hasError:YES reloadButtonBlock:^(id sender) {
                                                                             [[NSToastManager manager] showprogress];
                                                                             [wSelf setRequestURL:requestURL];
                                                                             }];
                                                                             */
                                                                            //        [[NSToastManager manager] showtoast:@"网络开小差了，请检查您的网络!"];
                                                                            
                                                                            
                                                                        }];
}
#pragma mark - subclass can override
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr {
    // subclass can override
}

#pragma mark -- 注释 ：UIGestureRecognizerDelegate
#pragma mark -- 注释 ：在nav栈底层 取消侧滑返回效果
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark -- DZNEmptyDataSetSource DZNEmptyDataSetDelegate

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isShowNoNetwork) {
        return ImageNamed(@"c_no_network_icon");
    }
    else
    {
        return ImageNamed(@"c_no_data_icon");
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"";
    if (self.isShowNoNetwork) {
        text = @"网络连接失败\n";
    }
    else
    {
        if (self.noDataDes.length) {
            text = [NSString stringWithFormat:@"%@\n",self.noDataDes];
        }
        else
        {
            text = @"暂无数据！\n";
        }
        
    }
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName: AppTitleBlackColor};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.isShowNoNetwork) {
        return ImageNamed(@"c_no_network_connect_icon");
    }
    return nil;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    if (self.isShowNoNetwork) {
        return YES;
    }
    return NO;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    if (self.isShowEmptyData ||
        self.isShowNoNetwork) {
        return YES;
    }
    return NO;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -20;
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self reconnectNetworkRefresh];
}

- (void)reconnectNetworkRefresh
{
    
}

- (void)dealloc
{
    DLog(@"当前页面释放");
}


#pragma mark -- Setter
#pragma mark -- 设置无数据页面
/***/
- (void)setIsShowEmptyData:(BOOL)isShowEmptyData
{
    
    if (_isShowEmptyData) {
        //隐藏无数据页面
        if (!isShowEmptyData) {
            _isShowEmptyData = isShowEmptyData;
            [self.comScrollerView reloadEmptyDataSet];
        }
    }
    else
    {
        //展示无数据页面
        if (isShowEmptyData) {
            _isShowEmptyData = isShowEmptyData;
            [self.comScrollerView reloadEmptyDataSet];
        }
    }
}


@end

