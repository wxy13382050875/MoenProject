//
//  IMHttpClient.h
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 yinchao. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@class NSHttpClient;
typedef enum {
    GetRequest = 1,
    PostRuest = 0
}requestType;
@protocol NSHttpClientDelegate <NSObject>

- (void)passProgressValue:(NSHttpClient *)httplient;

@end

@class NSCacheManager;


@interface NSHttpClient : AFHTTPSessionManager;
@property (nonatomic, strong) AFURLSessionManager *downloadManager;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) id<NSHttpClientDelegate>delegate;

@property (nonatomic, strong) NSCacheManager *cacheManager;


+ (instancetype)client;
+ (NSString *)actionCustomUsrAgent;
- (NSURLSessionDataTask *)asyncRequestWithURL:(NSString *)url
                                    type:(BOOL)requestType
                                   paras:(NSDictionary *)parasDict
                                 success:(void(^)(NSURLSessionDataTask *operation,NSObject *parserObject))success
                                 failure:(void(^)(NSURLSessionDataTask *operation,NSError *requestErr))failure;

-(void)downLoadWithFileURL:(NSString *)fileURL completionHandler:(void(^)())completion;

- (void)uploadWithUrl:(NSString *)url imageArr:(NSArray *)imageArr
             progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
              success:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
              failure:(void (^_Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

- (void)cancelDownload;
- (void)cancelRequest;
@end
