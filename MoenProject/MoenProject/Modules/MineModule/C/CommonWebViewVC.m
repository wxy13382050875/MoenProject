//
//  CommonWebViewVC.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/12/12.
//

#import "CommonWebViewVC.h"
#import <WebKit/WebKit.h>
#import "CommonAbountModel.h"

@interface CommonWebViewVC ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;


@end

@implementation CommonWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.view.backgroundColor = AppBgBlueGrayColor;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65)];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.backgroundColor = AppBgBlueGrayColor;
    //开了支持滑动返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];

}

- (void)configBaseData
{
    [[NSToastManager manager] showprogress];
    [self httpPath_appInfo];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_appInfo]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_appInfo])
            {
                CommonAbountModel *model = (CommonAbountModel *)parserObject;
                [self.webView loadHTMLString:model.html baseURL:nil];
            }
        }
    }
}

/**关于Api*/
- (void)httpPath_appInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_appInfo;
}




@end
