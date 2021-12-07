//
//  HttpURLConfig.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/11/7.
//

#import <Foundation/Foundation.h>
@implementation HttpURLConfig

+(NSString *)configInterfaceAddress
{
    NSString *requestURL;
#ifdef DEBUG
    requestURL = [NSString stringWithFormat:@"%@%@",DebugHostName,DebugHostPath];
    if ([QZLUserConfig sharedInstance].isTestEnter) {
         requestURL = [NSString stringWithFormat:@"%@%@",TestHostName,DebugHostPath];
    }
#else
    requestURL = [NSString stringWithFormat:@"%@%@",ReleaseHostName,ReleaseHostPath];
    if ([QZLUserConfig sharedInstance].isTestEnter) {
        requestURL = [NSString stringWithFormat:@"%@%@",TestHostName,DebugHostPath];
    }
#endif
    return requestURL;
}

+(NSString *)configUploadImageAddress
{
    NSString *requestURL;
#ifdef DEBUG
    requestURL = [NSString stringWithFormat:@"%@",DebugImageUploadPath];
#else
    requestURL = [NSString stringWithFormat:@"%@",ReleaseImageUploadPath];
#endif
    return requestURL;
}

+ (NSString *)configDownloadImageAddress
{
    NSString *requestURL;
#ifdef DEBUG
    requestURL = [NSString stringWithFormat:@"%@",DebugImageDownloadPath];
#else
    requestURL = [NSString stringWithFormat:@"%@",ReleaseImageDownloadPath];
#endif
    return requestURL;
}

@end
