//
//  NSTool.m
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "NSTool.h"
#include <sys/sysctl.h>
#import "LoginVC.h"
//#import "UIViewController+Utils.h"
//#import "HXDLoginController.h"
//#import "SAMKeychain.h"
//#import "HXDNavigationController.h"
//#import "NSHttpClient.h"
//#import "RoleApplyModel.h"
#import <objc/runtime.h>
#import <Accelerate/Accelerate.h>
//#import "GoodDetailContainerController.h"
//#import "HomePageViewController.h"
//#import "ShopDetailController.h"
//#import "SearchResultContainerController.h"
//#import "ChannelViewController.h"
//#import "SearchShopListController.h"
//#import "GoodListViewController.h"
//#import "NewClassificationVC.h"
// 导入运行时文件
/*
 void swizzled_Method(Class class,SEL originalSelector,SEL swizzledSelector) {
 Method originalMethod = class_getInstanceMethod(class, originalSelector);
 Method swizzeldMethod = class_getInstanceMethod(class, swizzledSelector);
 
 BOOL didSwizzle = class_addMethod(class, originalSelector, method_getImplementation(swizzeldMethod), method_getTypeEncoding(swizzeldMethod));
 
 if (didSwizzle) {
 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
 } else {
 method_exchangeImplementations(originalMethod, swizzeldMethod);
 }
 }
 */

BOOL debugMode = NO;
NSString *host = @"";
NSString *port = @"";

@implementation NSTool
static NSDateFormatter *dateFormatter;

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[self class] configureHostURL];
        
        dateFormatter = [[NSDateFormatter alloc] init];
    });
}

#pragma mark + configureHostURL
+ (void)configureHostURL {
    /*
     
     if (debugMode) {
     
     if (·) {
     
     #ifdef DEBUG
     host = debugHost;
     port = debugPort;
     
     [USERDEFAULT setValue:debugHost forKey:customHostKey];
     [USERDEFAULT setValue:debugPort forKey:customPortKey];
     [USERDEFAULT synchronize];
     #else
     host = releaseHost;
     port = releasePort;
     
     [USERDEFAULT setValue:releaseHost forKey:customHostKey];
     [USERDEFAULT setValue:releasePort forKey:customPortKey];
     [USERDEFAULT synchronize];
     #endif
     } else {
     
     host = [USERDEFAULT objectForKey:customHostKey];
     port = [USERDEFAULT objectForKey:customPortKey];
     }
     return ;
     }
     #ifdef DEBUG
     host = debugHost;
     port = debugPort;
     #else
     host = releaseHost;
     port = releasePort;
     #endif
     
     */
}

#pragma mark - obtainHostURL
+ (NSString *)obtainHostURL {
    
    NSString *requestURL ;
#ifdef DEBUG

//    requestURL = [NSString stringWithFormat:@"%@%@",ReleaseHost,@"/MallApi"];
//    TermireMall
//    MallApi
//    192.168.2.50:8087/financer
//    192.168.2.217:8088
    requestURL = @"http://192.168.2.50:8087";
//    requestURL = [NSString stringWithFormat:@"%@%@",DebugHost,@"/TermireMall"];

#else
//    requestURL = [NSString stringWithFormat:@"%@%@",ReleaseHost,@"/MallApi"];
#endif
    
    return requestURL;
}

#pragma mark - chainHostUrl

+ (NSString *)obtainSupplyChainHostUrl{
    NSString *chainUrl= @"";
#ifdef DEBUG
    
//    chainUrl = SupplyChainReleaseHost;
#else
//    chainUrl = SupplyChainReleaseHost;
    
#endif
    
    return chainUrl;
}

#pragma mark - UpLoadHostURL
+ (NSString *)upLoadHostURL {
    
    NSString *upLoadURL ;
    
    upLoadURL = [NSTool obtainHostURL];
    
    
    return upLoadURL;
    
}

#pragma mark - obtainH5HostUrl
+ (NSString *)obtainH5HostURL {
    
    
    NSString *requestURL ;
#ifdef DEBUG
    
//    requestURL = DebugHost;
#else
    
//    requestURL = ReleaseHost;
#endif
    
    
    return requestURL;
    
}

#pragma mark - appDelegate
+ (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - isStringEmpty
+ (BOOL)isStringEmpty:(NSString *)targetString {
    
    if (![targetString isKindOfClass:[NSString class]]) {
        targetString = targetString.description;
    }
    if ([targetString isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([targetString isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([targetString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([targetString isEqualToString:@"(null)(null)"]) {
        return YES;
    }
    if ([[targetString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

//返回当前类的所有属性
+ (NSArray *)getProperties:(Class)cls{
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}


+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    
    // Compress by quality
    
    CGFloat compression = 1;
    
    NSData *data = UIImageJPEGRepresentation(image, compression);
    
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    
    CGFloat min = 0;
    
    for (int i = 0; i < 6; ++i) {
        
        compression = (max + min) / 2;
        
        data = UIImageJPEGRepresentation(image, compression);
        
        if (data.length < maxLength * 0.9) {
            
            min = compression;
            
        } else if (data.length > maxLength) {
            
            max = compression;
            
        } else {
            
            break;
            
        }
        
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    
    NSUInteger lastDataLength = 0;
    
    while (data.length > maxLength && data.length != lastDataLength) {
        
        lastDataLength = data.length;
        
        CGFloat ratio = (CGFloat)maxLength / data.length;
        
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)), (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        
        UIGraphicsBeginImageContext(size);
        
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(resultImage, compression);
        
    }
    
    return resultImage;
    
}

#pragma mark cutImage With size
//+ (UIImage *)cutImage:(UIImage*)image scaledToSize:(CGSize)newSize2
//{
//    //压缩图片
//    CGSize newSize;
//    CGImageRef imageRef;
//
//    if ((image.size.width / image.size.height) < (newSize2.width / newSize2.height)) {
//        newSize.width = image.size.width;
//        newSize.height = image.size.width * newSize2.height / newSize2.width;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
//
//    } else {
//        newSize.height = image.size.height;
//        newSize.width = image.size.height * newSize2.width / newSize2.height;
//
//        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
//
//    }
//
//    return [UIImage imageWithCGImage:imageRef];
//
//}


#pragma mark saveImage to Document
+(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
//    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//
//    NSString * fullPath = [LocalPath stringByAppendingPathComponent:imageName];
//    NSFileManager * fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:fullPath]) {
//        [fm removeItemAtPath:fullPath error:nil];
//    }
//    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark uploade image to Qiniu
+(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url
{
    NSString *  fileURL;
    
    __block NSString * file = fileURL;
    /*
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath:photoPath]) {
     QNUploadManager * upManager = [[QNUploadManager alloc] init];
     NSData * imageData = [NSData dataWithContentsOfFile:photoPath];
     [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
     
     file = [NSString stringWithFormat:@"%@",[resp objectForKey:@"key"]];
     
     
     } option:nil];
     }
     */
    return file;
}


+(BOOL)isValidateMobile:(NSString *)mobile
{
    //cell number is 13， 15，18 begain，nine \d number
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,6,7,8]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+(BOOL)compareWithUser:(long)userID
{
    //    NSDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    NSString * user = [NSString stringWithFormat:@"%ld",userID];
    if ([user isEqualToString:@""]) {
        return YES;
    }else{
        
        return NO;
        
    }
    
    
}

+(NSString *)encrytWithDic:(NSDictionary *)dic
{
    /*
     NSDictionary * dic1 = [[NSHttpClient client] encryptWithDictionary:@{@"data":dic} isEncrypt:YES];
     NSString * str =  [NSString stringWithFormat:@"data=%@",[dic1 objectForKey:requestData]];
     return str;
     */
    return @"";
}

+(NSString *)stringFormatWithTimeLong:(long)times
{
    if (times) {
        NSString * minute;
        NSString * second;
        int seconds = times%60;
        long minutes = times/60;
        if (minutes/10 == 0) {
            minute = [NSString stringWithFormat:@"0%ld",minutes];
        }
        
        if (seconds/10 == 0) {
            second = [NSString stringWithFormat:@"0%d",seconds];
        }else{
            second = [NSString stringWithFormat:@"%d",seconds];
        }
        
        NSString * str = [NSString stringWithFormat:@"%@:%@",minute,second];
        return str;
    } else {
        return @"00:00";
    }
    
}

+ (NSString*)getMachine{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    
    free(name);
    
    if( [machine isEqualToString:@"i386"] || [machine isEqualToString:@"x86_64"] ) machine = @"ios_Simulator";
    else if( [machine isEqualToString:@"iPhone1,1"] ) machine = @"iPhone_1G";
    else if( [machine isEqualToString:@"iPhone1,2"] ) machine = @"iPhone_3G";
    else if( [machine isEqualToString:@"iPhone2,1"] ) machine = @"iPhone_3GS";
    else if( [machine isEqualToString:@"iPhone3,1"] ) machine = @"iPhone_4";
    else if ( [machine isEqualToString:@"iPhone4,1"]) machine = @"iPhone_4S";
    else if ( [machine isEqualToString:@"iPhone5,1"]) machine = @"iPhone_5";
    else if ( [machine isEqualToString:@"iPhone5,3"]) machine = @"iPhone_5C";
    else if ( [machine isEqualToString:@"iPhone6,1"]) machine = @"iPhone_5S";
    else if ( [machine isEqualToString:@"iPhone7,1"]) machine = @"iPhone_6P";
    else if ( [machine isEqualToString:@"iPhone7,2"]) machine = @"iPhone_6";
    else if ( [machine isEqualToString:@"iPhone8,1"]) machine = @"iPhone_6S";
    else if ( [machine isEqualToString:@"iPhone8,2"]) machine = @"iPhone_6SP";
    else if( [machine isEqualToString:@"iPod1,1"] ) machine = @"iPod_Touch_1G";
    else if( [machine isEqualToString:@"iPod2,1"] ) machine = @"iPod_Touch_2G";
    else if( [machine isEqualToString:@"iPod3,1"] ) machine = @"iPod_Touch_3G";
    else if( [machine isEqualToString:@"iPod4,1"] ) machine = @"iPod_Touch_4G";
    else if( [machine isEqualToString:@"iPad1,1"] ) machine = @"iPad_1";
    else if( [machine isEqualToString:@"iPad2,1"] ) machine = @"iPad_2";
    
    
    return machine;
}

+(CGFloat)getWidthWithContent:(NSString *)contentStr font:(UIFont *)font {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
}

+(CGFloat)getHeightWithContent:(NSString *)contentStr width:(CGFloat)width font:(UIFont *)font lineOffset:(CGFloat)lineOffset{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [dic setValue:@(lineOffset) forKey:NSBaselineOffsetAttributeName];
    CGSize size = [contentStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height
    ;
}

+ (void)presentToLoginController:(NSInteger)type
{
    UIViewController *currentController = [UIViewController currentViewController];
    LoginVC *loginController = [[LoginVC alloc] init];
    loginController.controllerType = LoginVCType_login;
    //另一台设备登陆后  需要传这两个参数 用于之后的页面跳转
    [currentController presentViewController:loginController animated:YES completion:nil];
}

+ (void)presentToLoginController{
    
    [self presentToLoginController:0];
    //    HXDLoginController *loginController = [[HXDLoginController alloc] init];
    //    HXDNavigationController *navController = [[HXDNavigationController alloc] initWithRootViewController:loginController];
    //    UIViewController *currentController = [UIViewController currentViewController];
    //    if (![currentController isKindOfClass:[HXDLoginController class]]) {
    //
    //        [currentController presentViewController:navController animated:YES completion:^{
    //
    //        }];
    //    }
}

//+ (void)pushWithUrlType:(NSString *)urlType withParameters:(NSDictionary *)parameters{
//
//    UIViewController *destViewController ;
//    if (![[parameters allKeys] containsObject:kTitleKey]) {
//        NSMutableDictionary *changableParameter = [NSMutableDictionary dictionaryWithDictionary:parameters];
//        [changableParameter setValue:kTitleKey forKey:@""];
//        parameters = [NSDictionary dictionaryWithDictionary:changableParameter];
//    }
//
//    /*
//     type描述：
//     goodsInfo进入商品详情
//     channel 则返回channelId 读取楼层数据
//     store   进入店铺
//     link     进入链接
//     keyWords 关键字搜索
//     */
//
//    /*
//     parameters =
//     @{
//     kIdKey:@"";
//     kTitleKey:@"";
//
//     };
//
//     */
//    if ([urlType isEqualToString:kPushTypeGood]) {
//        GoodDetailContainerController *goodDetailController = [[GoodDetailContainerController alloc] init];
//        NSString *goodId  = [NSString stringWithFormat:@"%@",parameters[kIdKey]];
//        goodDetailController.goodId = @"4683";
//        goodDetailController.isWoolGoods = NO;
//        destViewController = goodDetailController;
//    }else if ([urlType isEqualToString:kPushTypeStore]){
//        ShopDetailController *shopDetailVC = [[ShopDetailController alloc] init];
//        NSString *shopId  = [NSString stringWithFormat:@"%@",parameters[kIdKey]];
//        shopDetailVC.shopId = shopId;
//        destViewController = shopDetailVC;
//
//    }else if ([urlType isEqualToString:kPushTypeGoodsList]){
//        NSString *idListString = parameters[kIdKey];
//        NSString *title = parameters[kTitleKey];
//        if (!title.length) {
//            title = @"商品列表";
//        }
//        NSMutableArray *goodIdArr= [NSMutableArray arrayWithArray:[idListString componentsSeparatedByString:@","]];
//        [goodIdArr removeObject:@""];
//
//
//        GoodListViewController *goodListController = [[GoodListViewController alloc] init];
//        goodListController.title = title;
//        goodListController.goodsIdList = [NSArray arrayWithArray:goodIdArr];
//        goodListController.hidesBottomBarWhenPushed = YES;
//        destViewController = goodListController;
//
//    }else if ([urlType isEqualToString:kPushTypeSearch]){
//        NSString *searchStr = parameters[kIdKey];
//        //        NSString *title = parameters[kTitleKey];
//
//        SearchResultContainerController *searchResultVC = [[SearchResultContainerController alloc] init];
//        searchResultVC.searchStr = searchStr;
//        searchResultVC.searchType = 1;
//        destViewController = searchResultVC;
//
//    }else if ([urlType isEqualToString:kPushTypeBrandSearch]){
//        NSString *searchStr = parameters[kIdKey];
//        SearchResultContainerController *searchResultVC = [[SearchResultContainerController alloc] init];
//        searchResultVC.searchStr = searchStr;
//        searchResultVC.searchType = 2;
//        destViewController = searchResultVC;
//
//    }else if ([urlType isEqualToString:kPushTypeStoreSearch]){
//        NSString *searchStr = parameters[kIdKey];
//        SearchResultContainerController *searchResultVC = [[SearchResultContainerController alloc] init];
//        searchResultVC.searchStr = searchStr;
//        searchResultVC.searchType = 3;
//        destViewController = searchResultVC;
//
//    }else if ([urlType isEqualToString:kPushTypeChannel]){
//        ChannelViewController *channelController = [[ChannelViewController alloc] init];
//        NSString *channelId = parameters[kIdKey];
//        //        StandardModelModel *model = (StandardModelModel *)parameters[kTitleKey];
//        //        NSString *title = model.title;
//        NSString *title = parameters[kTitleKey];
//
//        channelController.channelId = channelId;
//        channelController.title = title;
//        destViewController = channelController;
//
//    }else if ([urlType isEqualToString:kPushTypeTypeList]){
//
//        //分类
////        [UIViewController currentViewController].tabBarController.selectedIndex = 1;
//        NewClassificationVC *vc = [[NewClassificationVC alloc] init];
//        vc.enterType = 1;
//        vc.title = @"分类";
//        vc.hidesBottomBarWhenPushed = YES;
//        [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
//
//    }else if ([urlType isEqualToString:kPushTypeStoreList]){
//        SearchShopListController *shopListController = [[SearchShopListController alloc] init];
//        shopListController.searchStr = nil;
//        shopListController.hidesBottomBarWhenPushed = YES;
//        destViewController = shopListController;
//    }else{
//#ifdef DEBUG
//        [[NSToastManager manager] showtoast:@"跳转类型服务器未定义"];
//#else
//
//
//#endif
//    }
//
//    if (destViewController) {
//        if (!destViewController.tabBarController.tabBar.hidden) {
//            destViewController.hidesBottomBarWhenPushed = YES;
//        }
//
//        UIViewController *currentController = [UIViewController currentViewController];
//        [currentController.navigationController pushViewController:destViewController animated:YES];
//
//        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//        if (rootViewController) {
//            NSLog(@"rootViewController %@",rootViewController);
//        }else{
//            [[NSToastManager manager] showtoast:@"rootviewcontroller丢失"];
//        }
//    }
//
//
//
//}

// string to data
+ (id)transformToObjectWithJsonString:(NSString *)jsonStr{
    
    if (jsonStr == nil) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    id object = nil;
    object = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingAllowFragments
                                               error:nil];
    
    return object;
}


// data to jsonString
+ (NSString*)transformTOjsonStringWithObject:(id)object
{
    if (object == nil) {
        return @"";
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSString *)getClassifyImageWithPath:(NSString *)path mainName:(NSString *)mainName
{
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@/%@",path,mainName];
    return imageUrlStr;
}

// calculate numberoflines

+ (CGFloat)numberOfTextIn:(UILabel *)label{
    // 获取单行时候的内容的size
    CGSize singleSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    // 获取多行时候,文字的size
    CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    // 返回计算的行数
    return ceil( textSize.height / singleSize.height);
}

/** 通过行数, 返回更新时间 */
+ (NSString *)updateTimeForCreateTimeIntrval:(NSInteger)createTimeIntrval {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = createTimeIntrval/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    if (time <60) {
        return @"刚刚";
        
    }
    //秒转分钟
    if (time<3600) {
        NSInteger minutes = time/60;
        return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        
    }
    // 秒转小时
    NSInteger hours = time/3600;
    NSInteger days = time/3600/24;
    if (days<24 && days == 0) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    if (days == 1) {
        return @"昨天";
    }
    
    
    
    if (days < 7 && days > 1) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:createTime];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+ (NSArray *)getTagsFromTagString:(NSString *)tagString{
    
    NSMutableArray *tagArray =[NSMutableArray arrayWithArray: [tagString componentsSeparatedByString:@"/"]];
    [tagArray removeObject:@" "];
    return tagArray;
    
}

//+ (BOOL)canRecord
//{
//    __block BOOL bCanRecord = YES;
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)     {
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                bCanRecord = granted;
//            }];
//        }
//    }
//    return bCanRecord;
//}



//+ (NSString *)getDeviceId
//{
//    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" "account:@"uuid"];
//    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
//    {
//        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
//        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
//        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
//        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" "account:@"uuid"];
//    }
//    return currentDeviceUUIDStr;
//}

//+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(int)fontSize
//{
//    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
//    if (IOS_VERSION >= 7.0)
//    {
//        size=[text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
//    }else{
//        NSAttributedString *attributeSting = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}];
//        size = [attributeSting size];
//    }
//    return size;
//}

+ (NSInteger)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:timeString];
    NSTimeInterval a = [date timeIntervalSince1970];
    return  a;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img); CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL) NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer; outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img); outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) { NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx); CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+ (void)setShadowShowToView:(UIView *)view{
    view.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    view.layer.shadowOffset = CGSizeMake(2,2);
    view.layer.shadowRadius = 3.5f;
    view.layer.shadowOpacity = 0.4f;
    view.layer.masksToBounds = NO;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = UIColorFromRGB(0xdadbdd).CGColor;
}

+ (void)setBorderShowToView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.borderWidth = 0.5f;
    view.layer.borderColor = UIColorFromRGB(0xdadbdd).CGColor;
}
/*鉴定角色*/
+ (void)checkRoleToTarget:(id)target action:(SEL)action targetObject:(id)targetObject{
//    if (targetObject == nil) {
//        targetObject =@"";
//    }
//    [[NSToastManager manager] showmodalityprogress];
//    [[NSHttpClient client] asyncRequestWithURL:Path_ApplyRoleInfo type:NO paras:@{TokenKey:[HXDConfigManager sharedInstance].access_Token} success:^(NSURLSessionDataTask *operation, NSObject *parserObject) {
//
//        NSLog(@"%@",parserObject);
//        RoleApplyModel *roleModel = (RoleApplyModel *)parserObject;
//
//
//        if (roleModel.code == 200) {
//
//            if (([roleModel.status isEqualToString:@"success"] || [roleModel.status isEqualToString:@"renew_pay"]) &&[roleModel.type isEqualToString:@"purchaser"]) {
//                [target performSelector:action withObject:@{@"result":@(1),
//                                                            @"content":targetObject} afterDelay:0.0];
//
//
//            }else if (([roleModel.status isEqualToString:@"success"] || [roleModel.status isEqualToString:@"renew_pay"]) &&[roleModel.type isEqualToString:@"supplier"]){
//                [target performSelector:action withObject:@{@"result":@(1),
//                                                            @"content":targetObject} afterDelay:0.0];
////                [target performSelector:action withObject:@{@"result":@(2),
////                                                            @"content":targetObject} afterDelay:0.0];
//
//
//            }else{
////                [target performSelector:action withObject:@{@"result":@(0),
////                                                            @"content":targetObject} afterDelay:0.0];
//                [target performSelector:action withObject:@{@"result":@(1),
//                                                            @"content":targetObject} afterDelay:0.0];
//            }
//
//
//
//        }else {
//            [target performSelector:action withObject:@{@"result":@(-1),
//                                                        @"content":targetObject} afterDelay:0.0];
//        }
//
//    } failure:^(NSURLSessionDataTask *operation, NSError *requestErr) {
//        [target performSelector:action withObject:nil afterDelay:0.0];
//        [[NSToastManager manager] showtoast:@"网络错误"];
//    }];
    
}

+ (NSString *)filterShareCommand:(NSString *)haoCommand
{
    NSString *resultStr = @"";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"￥[A-Za-z0-9]{11}￥" options:0 error:&error];
    if (regex)
    {
        NSArray *resultArr = [regex matchesInString:haoCommand options:0 range:NSMakeRange(0, haoCommand.length)];
        if (resultArr.count) {
            //对象进行匹配
            NSTextCheckingResult *resultCheck = [resultArr lastObject];
            if (resultCheck) {
                NSRange resultRange = [resultCheck rangeAtIndex:0];
                //从urlString当中截取数据
                resultStr = [haoCommand substringWithRange:resultRange];
                //输出结果
                NSLog(@"->  %@  <-",resultStr);
            }
        }
    }
    return resultStr;
}

+ (NSString *)handleTimeFormatWithTimeString:(NSString *)timeStr
{
    NSString *resultStr = @"";
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [startDateFormatter dateFromString:timeStr];
    
    NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
    [endDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    resultStr = [endDateFormatter stringFromDate:startDate];
    return resultStr;
}

+ (NSString *)handleTimeFormatWithTimeStringTailoring:(NSString *)timeStr
{
    NSString *resultStr = @"";
    NSDateFormatter *startDateFormatter = [[NSDateFormatter alloc] init];
    [startDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [startDateFormatter dateFromString:timeStr];
    
    NSDateFormatter *endDateFormatter = [[NSDateFormatter alloc] init];
    [endDateFormatter setDateFormat:@"yyyy/MM/dd"];
    resultStr = [endDateFormatter stringFromDate:startDate];
    return resultStr;
}

+ (NSString *)handlePhoneNumberFormatWithNumberString:(NSString *)phoneStr
{
    NSString *resultStr = @"";
    resultStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                               withString:@"$1 $2 $3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [phoneStr length])];
    return resultStr;
}

+ (NSString *)handlePhoneNumberStarFormatWithNumberString:(NSString *)phoneStr
{
    NSString *resultStr = @"";
    resultStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{4})(\\d{4})"
                                                    withString:@"$1 $2 $3"
                                                       options:NSRegularExpressionSearch
                                                         range:NSMakeRange(0, [phoneStr length])];
    NSRange range = NSMakeRange(4, 4);    
    NSString *string=[resultStr stringByReplacingCharactersInRange:range withString:@"****"];;
    return string;
}

@end

@implementation Memory

//+(NSString *)getCacheSize
//{
//
//    NSFileManager * fm = [NSFileManager defaultManager];
//
//    NSString * fileName;
//    //获取cache
//    //    if (![fm fileExistsAtPath:webPath]&&![fm fileExistsAtPath:cachePath]) {
//    //        return @"0";
//    //    }
//
//    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:LocalAccompanyPath] objectEnumerator];
//    float folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
//        NSString * fileAbsolutePath = [LocalAccompanyPath stringByAppendingPathComponent:fileName];
//        folderSize+=[[fm attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
//    }
//
//
//    folderSize = folderSize/(1024.0*1024.0);
//
//    NSString * size = [NSString stringWithFormat:@"%0.2fM",folderSize];
//    return size;
//}

//+(void)clearCache
//{
//    
//    NSFileManager * fm = [NSFileManager defaultManager];
//    NSString * fileName;
//    NSEnumerator * childFilesEnumerator = [[fm subpathsAtPath:LocalAccompanyPath] objectEnumerator];
//    //    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject])!=nil) {
//        NSString * fileAbsolutePath = [LocalAccompanyPath stringByAppendingPathComponent:fileName];
//        [fm removeItemAtPath:fileAbsolutePath error:nil];
//    }
//    
//    
//    
//    //    [fm removeItemAtPath:webPath error:nil];
//    //    [fm removeItemAtPath:cachePath error:nil];
//    
//    
//}



@end

@implementation date
+(NSString *)datetoStringWithDate:(NSTimeInterval)date
{
    
    
    double d = date / 1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"YYYY-MM-dd"];
    NSString * dateString = [fomatter stringFromDate:dat];
    return dateString;
}

//date to string format like "1992-12-05 12:33"
+(NSString *)datetoLongStringWithDate:(NSTimeInterval)date
{
    
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString * currentTimeString = [formatter stringFromDate:dat];
    return currentTimeString;
}

+(NSString *)datetoLongLongStringWithDate:(NSTimeInterval)date
{
    
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * currentTimeString = [formatter stringFromDate:dat];
    return currentTimeString;
}

//date to string formatLike "4月5日"

+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date
{
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString * dateString = [formatter stringFromDate:dat];
    return dateString;
}


+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date format:(NSString *)format
{
    double d = date /1000;
    NSDate * dat = [NSDate dateWithTimeIntervalSince1970:d];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * dateString = [formatter stringFromDate:dat];
    return dateString;
}



//get the time stamp
+(NSTimeInterval )getTimeStamp
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval  timeStamp = [date timeIntervalSince1970];
    
    return timeStamp;
}


+ (NSArray *)getMonthFirstAndLastDayWith{
    
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *newDate = [NSDate date];
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}

@end

@implementation Share

+(void)ShareWithTitle:(NSString *)title_ andShareUrl:(NSString *)shareUrl_ andShareImage:(NSString * )shareImage andShareText:(NSString *)shareText_ andVC:(UIViewController *)VC_
{
    
    /*
     [UMSocialData defaultData].extConfig.title = title_;
     [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
     [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
     [UMSocialData defaultData].extConfig.qqData.title = title_;
     [UMSocialData defaultData].extConfig.qzoneData.title = title_;
     if (shareImage.length == 0) {
     [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
     [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
     [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
     [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = [UIImage imageNamed:@"2.0_placeHolder"];
     
     }else{
     [UMSocialData defaultData].extConfig.qqData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
     [UMSocialData defaultData].extConfig.qzoneData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
     [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
     [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]];
     }
     [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl_;
     [UMSocialData defaultData].extConfig.qqData.url = shareUrl_;
     [UMSocialData defaultData].extConfig.wechatTimelineData.url =  shareUrl_;
     [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl_;
     
     [UMSocialSnsService presentSnsIconSheetView:VC_ appKey:umAppKey shareText:shareText_ shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImage]]]shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone] delegate:nil];
     */
    
}

+(BOOL)shareAvailableWeiXin
{
    return YES;
    /*
     if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
     return YES;
     }else{
     return NO;
     }
     */
}



+(BOOL)shareAvailableQQ
{
    
    return YES;
    /*
     if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi]) {
     return YES;
     }else{
     return NO;
     }
     */
}

+(BOOL)shareAvailableSina
{
    
    return YES;
}

@end

@implementation image

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation HXDAttributedString

+ (NSMutableAttributedString*)getMutableAttributedString:(NSString*)string textColor:(UIColor *)color length:(NSInteger)num {
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, num)];
    return aAttributedString;
}

+ (NSMutableAttributedString *)getTitleWithString:(NSString *)string size:(CGFloat)size{
    NSArray *titleArr = [string componentsSeparatedByString:@","];
    
    NSMutableAttributedString *attributedStr;
    if (titleArr.count == 2) {
        NSString *frontStr = titleArr[0];
        NSString *backStr = titleArr[1];
        attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",frontStr,backStr]];
        [attributedStr setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:size]} range:[attributedStr.string rangeOfString:frontStr]];
        [attributedStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} range:[attributedStr.string rangeOfString:backStr]];
    }else{
        attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
        
    }
    
    return attributedStr;
}



@end

