
//
//  IMHttpClient.m
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "MoenBaseModel.h"
#import "NSHttpClient.h"
#import "BaseModelFactory.h"
#import "NSToastManager.h"
#import "NSTool.h"
#import "NSURLSessionTask+NSAdditionals.h"
#import "NSHttpClient+EncrypteData.h"
@interface NSHttpClient ()
{
    NSURLSessionDataTask *_dataTask;
}

@end

@implementation NSHttpClient
static NSHttpClient *client;

#pragma mark - client
+ (instancetype)client {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [NSHttpClient manager];
    });
    return client;
}

#pragma mark + actionCistomUsrAgent
+ (NSString *)actionCustomUsrAgent {
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *app_ver = [mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *build_ver = [mainBundle.infoDictionary objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSString *channel = ([build_ver intValue] % 2) ? @"YinChaoTech" : @"appStore";
    
    NSString *userId = @"";
    //NSString *currentUserId = [DDUser user].userId;
    NSString *currentUserId = @"";
    if (currentUserId) {
        userId = [NSString stringWithFormat:@"UID/%d ",currentUserId.intValue];
    }
    
    NSString *deviceName = @"iPhone";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        deviceName = @"iPad";
    }
    return [NSString stringWithFormat:@"( NestSound; Client/%@%@ V/%@|%@ channel/%@ %@)"
            ,deviceName ,[UIDevice currentDevice].systemVersion , build_ver, app_ver, channel, userId];
}

#pragma mark -override initWithBaseURL
- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self  = [super initWithBaseURL:url]) {
        
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 5;
        [self.requestSerializer setValue:[self.class actionCustomUsrAgent] forHTTPHeaderField:@"User-Agent"];
        
        // 加上这行代码，https ssl 验证。
        //        [self setSecurityPolicy:[self customSecurityPolicy]];
        //        self.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        //        [self.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"header-platform"];
        //        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    }
    return self;
}

#pragma mark - responseObject
- (void)responseObject:(NSObject *)obj  withOperation:(NSURLSessionDataTask *)operation {
    
}


- (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"*.yinchao.cn" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

#pragma mark - requestWithURL  ...
/*
 * 异步
 */
- (NSURLSessionDataTask *)asyncRequestWithURL:(NSString *)url
                                         type:(BOOL)requestType
                                        paras:(NSDictionary *)parasDict
                                      success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
                                      failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure {
    
    NSMutableDictionary *transferParas = [parasDict mutableCopy];
    
    // Loading
//    BOOL showLoading = ![[transferParas objectForKey:kNoLoading] boolValue];
//    [transferParas removeObjectForKey:kNoLoading];
//    if (showLoading) {
//
//        // show hud
//        //        [[NSToastManager manager] showprogress];
//    }
//
//    BOOL isLoadingMore = [[transferParas objectForKey:kIsLoadingMore] boolValue];
//    [transferParas removeObjectForKey:kIsLoadingMore];
    
    WEAKSELF;
    NSString *requestURL = @"";
    if ([url containsString:@"http"]) {
        requestURL = url;
    }
//    }else if ([url isEqualToString:Path_SearchByLucene]){
//        requestURL = [NSString stringWithFormat:@"%@/%@",[[NSTool obtainHostURL] stringByDeletingLastPathComponent],url];
//
//    }
    else{
        requestURL = [NSString stringWithFormat:@"%@%@",[HttpURLConfig configInterfaceAddress],url];
        
    }
    if ([QZLUserConfig sharedInstance].shopId.length &&
        ![url isEqualToString:Path_oauth_token]) {
        requestURL = [requestURL stringByAppendingString: [NSString stringWithFormat:@"?employeeShopId=%@",[QZLUserConfig sharedInstance].shopId]];
    }
     
    NSLog(@"\n\n\n raquestParam %@\n\n  requestURL ---  %@",[NSTool transformTOjsonStringWithObject:transferParas],requestURL);
    NSURLSessionDataTask *operation;
   
    if (requestType) {
        NSString * query = AFQueryStringFromParameters(parasDict);
        requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"?%@",query]];
        operation = [self GET:requestURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 MoenBaseModel *model = [BaseModelFactory modelWithURL:url
                                                          responseJson:responseObject];
                 if (model == nil) {
                     model = [[MoenBaseModel alloc] init];
                 }
                 model.code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                 model.message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                 
                 NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                 if ([resultCode isEqualToString:@"200"]) {
                     model.success = YES;
                     success(task,model);
                 }else if ([resultCode isEqualToString:@"1011"]){
                     [QZLUserConfig sharedInstance].isLoginIn = NO;
                     [UTVCSkipHelper isLoginStatus];
                     return ;
                 }else{
                     /**3.2 鉴于接口无返回码 临时添加*/
                     model.success = YES;
                     [[NSToastManager manager] showtoast:model.message];
//                     [[NSToastManager manager] showtoast:[self MessageCodeHandler:model.code]];
                     success(task,model);
                 }
             }
            else
            {
                success(task,responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
            if (!failure) {
                return ;
            }
            failure(task,error);
        }];
        
    }else{
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        if ([transferParas objectForKey:@"access_token"]) {
            if ([QZLUserConfig sharedInstance].shopId.length) {
                requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@",transferParas[@"access_token"]]];
                [transferParas removeObjectForKey:@"access_token"];
            }
            else
            {
                requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"?access_token=%@",transferParas[@"access_token"]]];
                [transferParas removeObjectForKey:@"access_token"];
            }
            
            
        }
        
        self.requestSerializer = requestSerializer;
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        operation = [self POST:requestURL
                    parameters:transferParas
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                           
                           //hide toast
//                           if (showLoading) {
//
//                               //                               [[NSToastManager manager] hideprogress];
//                           }
                           //                           DLog(@"RESPONSE JSON:%@", responseObject);
                           if (!success) {
                               return ;
                           }
                           
                           if ([responseObject isKindOfClass:[NSDictionary class]]) {
                               MoenBaseModel *model = [BaseModelFactory modelWithURL:url
                                                                     responseJson:responseObject];
                               if (model == nil) {
                                   model = [[MoenBaseModel alloc] init];
                               }
                               model.code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                               model.message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                            
                               NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
                               if ([resultCode isEqualToString:@"200"]) {
                                   
                                   model.success = YES;
                                   success(task,model);
                                   
                               }else if ([resultCode isEqualToString:@"401"]){
                                   [QZLUserConfig sharedInstance].isLoginIn = NO;
//                                   [UTVCSkipHelper isLoginStatus];
                                   [[NSToastManager manager] showtoast:@"登录超时！请重新登录"];
                                   [NSTool presentToLoginController];
                                   //token 失效
                                   //通过 refresh_token 获取新的token
//                                   if ([HXDConfigManager sharedInstance].refresh_token) {
//                                       [self getNewTokenByRefreshTokenWithOrignalUrl:url  originalParam:parasDict type:NO success:success failure:failure];
//
//                                   }
                                   return ;
                                   
                               }else{
                                   
                                   /**3.2 鉴于接口无返回码 临时添加*/
                                   model.success = YES;
                                   [[NSToastManager manager] showtoast:model.message];
//                                   [[NSToastManager manager] showtoast:[self MessageCodeHandler:model.code]];
                                   success(task,model);
                               }
                               
                           }
                           if (!weakSelf) {
                               return ;
                           }
//                           [weakSelf responseObject:responseObject withOperation:task];
                           
                       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                           NSLog(@"error %@",error);
//                           iMessageCodeHandlerf (showLoading) {
//                               [[NSToastManager manager] hideprogress];
//                           }
                           if (!failure) {
                               return ;
                           }
                           failure(task,error);
                       }];
    }
    
    operation.urlTag = url;
//    operation.isLoadingMore = isLoadingMore;
    
    return operation;
}

/*
 * 同步
 */

//- (NSURLSessionDataTask *)asyncRequestWithURL:(NSString *)url
//                                         type:(BOOL)requestType
//                                        paras:(NSDictionary *)parasDict
//                                      success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
//                                      failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure {
//
//
//}

- (void)getNewTokenByRefreshTokenWithOrignalUrl:(NSString *)orignalUrl originalParam:(NSDictionary *)param type:(BOOL)type success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure{
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.requestSerializer = requestSerializer;
    WEAKSELF
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@",[NSTool obtainHostURL],nil];
//    NSLog(@"refresh_token %@",[HXDConfigManager sharedInstance].refresh_token);
//    NSDictionary *parameter = @{@"refresh_token":[HXDConfigManager sharedInstance].refresh_token};
    [self POST:requestURL
    parameters:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           
           /**
            {
            code = 200;
            data =     {
            "access_overdue" = 30;
            "access_token" = 7c5fc36b521c43fc9a2f183298468095;
            id = 16;
            "login_time" = "2017-03-21 22:34:07";
            "refresh_overdue" = 60;
            "refresh_token" = ade65f97e5fa4f0eb09bd41be80badb2;
            };
            msg = "<null>";
            }
            */
           
           
           if ([responseObject isKindOfClass:[NSDictionary class]]) {
               int resultCode = [[NSString stringWithFormat:@"%@",responseObject[@"code"]] intValue];
               NSDictionary *dataDict = responseObject[@"data"];
               if (resultCode == 200) {
//                   [HXDConfigManager sharedInstance].access_Token = dataDict[@"access_token"];
//                   [HXDConfigManager sharedInstance].refresh_token = dataDict[@"refresh_token"];
                   NSMutableDictionary *newParameters = [NSMutableDictionary dictionaryWithDictionary:param];
//                   [newParameters setValue:[HXDConfigManager sharedInstance].access_Token forKey:@"access_token"];
                   [self asyncRequestWithURL:orignalUrl type:type paras:newParameters success:success failure:failure];
               }
               if (resultCode == 1008) {
                   [[NSToastManager manager] showtoast:@"登录超时，请重新登录"];
                   [NSTool presentToLoginController];
               }
               
           }
           if (!weakSelf) {
               return ;
           }
           //                       [wSelf responseObject:responseObject withOperation:task];
           
       } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
           
           
           
       }];
    
    
    
    
}

#pragma  mark -downLoadWithFIleURL
-(void)downLoadWithFileURL:(NSString *)fileURL completionHandler:(void(^)())completion
{
    
    
}

#pragma  mark -upload

- (void)uploadWithUrl:(NSString *)url imageArr:(NSArray *)imageArr
             progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
              success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
              failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure{
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    manage.responseSerializer = [AFJSONResponseSerializer serializer];        //设置超时时间
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:[QZLUserConfig sharedInstance].token forHTTPHeaderField:@"Authorization"];
    manage.requestSerializer= requestSerializer;
    manage.requestSerializer.timeoutInterval = 120;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",[HttpURLConfig configUploadImageAddress],url];
    requestURL = [requestURL stringByAppendingString:[NSString stringWithFormat:@"?access_token=%@",[QZLUserConfig sharedInstance].token]];
    if ([QZLUserConfig sharedInstance].shopId.length &&
    ![url isEqualToString:Path_oauth_token]) {
        requestURL = [requestURL stringByAppendingString: [NSString stringWithFormat:@"&employeeShopId=%@",[QZLUserConfig sharedInstance].shopId]];
    }

    NSLog(@"%@", requestURL);
    WEAKSELF
    [manage POST:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArr.count == 1) {
            id obj  = imageArr.firstObject;
            UIImage *imgObc;
            if ([obj isKindOfClass:[UIImage class]]) {
                imgObc = obj;
            }
            if ([obj isKindOfClass:[NSString class]]) {
                imgObc = [UIImage imageWithContentsOfFile:obj];
            }
            NSData *data;
            NSString *lastPath = @"";
            data = UIImageJPEGRepresentation(imgObc, 0.1);
            lastPath = @".jpg";

            //单张图片
            [formData appendPartWithFileData:data name:@"posters" fileName:[NSString stringWithFormat:@"file%@",lastPath] mimeType:@"multipart/form-data"];
        }else{
            //服务器暂不支持
              for(int i = 0; i <[imageArr count] ; i++)
             {
                 NSMutableString *key = [NSMutableString stringWithString:@"imgFile"];
                 UIImage *imgObc = imageArr[i];
                 NSData *data;
                 if (UIImagePNGRepresentation(imgObc) == nil) {
                     data = UIImageJPEGRepresentation(imgObc, 0.1);
                 } else {
                     data = UIImageJPEGRepresentation(imgObc, 0.1);
                 }
                 [key appendFormat:@"%d.jpg",(i + 1)];
                 [formData appendPartWithFileData:data name:@"posters" fileName:key mimeType:@"multipart/form-data"];
             }
        }
    } progress:uploadProgress success:success failure:failure];
}

- (NSString *)MessageCodeHandler:(NSString *)code
{
    NSString *message = @"";
    if ([code isEqualToString:@"1001"]) {
        message = @"参数名错误！";
    }
    else if ([code isEqualToString:@"400"])
    {
        message = @"错误的用户名或密码！";
    }
//    else if ([code isEqualToString:@"403"])
//    {
//        message = @"验证码错误!";
//    }
    
    else if ([code isEqualToString:@"1002"])
    {
        message = @"参数验证错误！";
    }
    else if ([code isEqualToString:@"1003"])
    {
        message = @"时间处理错误！";
    }
    else if ([code isEqualToString:@"1004"])
    {
        message = @"验证码错误！";
    }
    else if ([code isEqualToString:@"2001"])
    {
        message = @"用户没有权限！";
    }
    else if ([code isEqualToString:@"2002"])
    {
        message = @"帐号信息错误！";
    }
    else if ([code isEqualToString:@"2003"])
    {
        message = @"数据异常!";
    }
    else if ([code isEqualToString:@"3001"])
    {
        message = @"会员已存在！";
    }
//    else if ([code isEqualToString:@"3002"])
//    {
//        message = @"会员不存在！";
//    }
    else if ([code isEqualToString:@"3003"])
    {
        message = @"商品不存在！";
    }
    else if ([code isEqualToString:@"3004"])
    {
        message = @"门店员工信息错！";
    }
    else if ([code isEqualToString:@"3005"])
    {
        message = @"该人员为店长，您不能停用!";
    }
    else if ([code isEqualToString:@"3006"])
    {
        message = @"该员工已经被停用！";
    }
    else if ([code isEqualToString:@"3007"])
    {
        message = @"该手机号已经是导购！";
    }
    else if ([code isEqualToString:@"3008"])
    {
        message = @"该手机号已经是专业客户!";
    }
    else if ([code isEqualToString:@"3009"])
    {
        message = @"请上传出样图片!";
    }
    else if ([code isEqualToString:@"3010"])
    {
        message = @"出样图片最多上传9张!";
    }
    else if ([code isEqualToString:@"3011"])
    {
        message = @"上传的图片不能大于5M!";
    }
    else if ([code isEqualToString:@"3012"])
    {
        message = @"领取优惠券失败!";
    }
    
    
    else if ([code isEqualToString:@"3013"])
    {
        message = @"数据错误!";
    }
    else if ([code isEqualToString:@"3014"])
    {
        message = @"推荐人信息识别错误！您已存在购买信息，不可以更改推荐关系!";
    }
    else if ([code isEqualToString:@"3015"])
    {
        message = @"安装评价失败!";
    }
    else if ([code isEqualToString:@"3016"])
    {
        message = @"验证码错误！";
    }
    else if ([code isEqualToString:@"3017"])
    {
        message = @"原密码验证错误!";
    }
    return message;
}

- (void)requestCallBackWithTask:(id)currentTask target:(id)target withBackCall:(NSString*)call
{
    SEL selector = NSSelectorFromString(call);
    ((void (*)(id, SEL,id))[target methodForSelector:selector])(target, selector,currentTask);
}
@end

