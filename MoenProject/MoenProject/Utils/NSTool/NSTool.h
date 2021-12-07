//
//  NSTool.h
//  NestSound
//
//  Created by yandi on 4/16/16.
//  Copyright © 2016 yinchao. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>


static NSString * const kIdKey = @"id";
static NSString * const kTitleKey = @"title";
static NSString * const kIconKey = @"Icon";
static NSString * const kColorKey = @"Color";
static NSString * const kContentKey = @"content";


static NSString * const kHomeFloorTypeAppLike = @"applike";
static NSString * const kHomeFloorTypeHotCategory = @"hotCategory";
static NSString * const kHomeFloorTypeSusiness = @"susiness";
static NSString * const kHomeFloorTypeCompetitiveProduct = @"competitiveProduct";
static NSString * const kHomeFloorTypeCategory = @"category";
static NSString * const kHomeFloorTypeNewcompetitiveProduct = @"newcompetitiveProduct";
static NSString * const kHomeFloorTypeAppHotItems = @"app_hotitems";


/**
 brandSearch
 storeSearch
 keyword
 goodsList
 store
 goodsInfo

 **/

static NSString * const kPushTypeChannel = @"channel";//频道
static NSString * const kPushTypeGood = @"goodsInfo";//商品详情
static NSString * const kPushTypeStore = @"store";//店铺首页
static NSString * const kPushTypeSearch = @"keyword";//商品关键词搜搜
static NSString * const kPushTypeGoodsList = @"goodsList";//商品列表 id是列表字符串 ‘,’隔开
static NSString * const kPushTypeBrandSearch = @"brandSearch";//品牌搜索
static NSString * const kPushTypeStoreSearch = @"storeSearch";//店铺搜索
static NSString * const kPushTypeStoreList = @"storeList";//热门工厂
static NSString * const kPushTypeTypeList = @"typeList";//类别


//static NSString * const kPushTypeLink = @"link";

@interface NSTool : NSObject


+ (NSString *)obtainHostURL;
#pragma mark - UpLoadHostURL
+ (NSString *)upLoadHostURL;

#pragma mark - chainHostUrl

+ (NSString *)obtainSupplyChainHostUrl;

+ (NSString *)obtainH5HostURL;
+ (AppDelegate *)appDelegate;
+ (BOOL)isStringEmpty:(NSString *)targetString;
//返回当前类的所有属性

+ (NSArray *)getProperties:(Class)cls;

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

+ (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;
+(NSString *)uploadPhotoWith:(NSString *)photoPath type:(BOOL)type_ token:(NSString *)token url:(NSString *)url;
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL)compareWithUser:(long)userID;
+(NSString *)encrytWithDic:(NSDictionary *)dic;
+(NSString *)stringFormatWithTimeLong:(long)times;
+(NSString *)getMachine;
+(CGFloat)getWidthWithContent:(NSString *)contentStr font:(UIFont *)font;
/**计算文本高度*/
+(CGFloat)getHeightWithContent:(NSString *)contentStr width:(CGFloat)width font:(UIFont *)font lineOffset:(CGFloat)lineOffset;
/**
 * 跳转登录界面
 */
+ (void)presentToLoginController;

/**
 * 跳转登录界面 
 * type 0、token失效  1、异地登录 退出账号后的重新登录
 */
+ (void)presentToLoginController:(NSInteger)type;

//按照类型跳转
+ (void)pushWithUrlType:(NSString *)urlType withParameters:(NSDictionary *)parameters;

// string to data
+ (id)transformToObjectWithJsonString:(NSString *)jsonStr;

// data to jsonString
+ (NSString*)transformTOjsonStringWithObject:(id)object;

+ (NSString *)getClassifyImageWithPath:(NSString *)path mainName:(NSString *)mainName;


+ (CGFloat)numberOfTextIn:(UILabel *)label;
+ (NSString *)updateTimeForCreateTimeIntrval:(NSInteger)createTimeIntrval;

+ (NSArray *)getTagsFromTagString:(NSString *)tagString;

+ (BOOL)canRecord;



/*获取设备唯一标识符*/
+ (NSString *)getDeviceId;
/**计算文字宽度*/
+ (CGSize)getAttributeSizeWithText:(NSString *)text fontSize:(int)fontSize;

+ (NSInteger)timeWithTimeIntervalString:(NSString *)timeString;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur ;

/*好下单首页 view阴影*/
+ (void)setShadowShowToView:(UIView *)view;
/*好下单首页 view边界*/
+ (void)setBorderShowToView:(UIView *)view;

/*鉴定角色
 0 普通会员
 1 采购商
 2 供应商
 
 -1 200 以外 报错
 
 
 */

+ (void)checkRoleToTarget:(id)target action:(SEL)action targetObject:(id)targetObject;

/**过滤淘口令字段中的口令字段*/
+ (NSString *)filterShareCommand:(NSString *)haoCommand;

/**
 *  时间格式的处理
 *  2019-01-24 09:52:15 - 2019/01/24 09:52:15
 */
+ (NSString *)handleTimeFormatWithTimeString:(NSString *)timeStr;

/**
 *  时间格式的处理 裁剪
 *  2019-01-24 09:52:15 - 2019/01/24
 */
+ (NSString *)handleTimeFormatWithTimeStringTailoring:(NSString *)timeStr;


/**
 *  iOS 格式化电话号码(344形式)
 *  手机号码格式的处理
 *  138 2324 3242
 */
+ (NSString *)handlePhoneNumberFormatWithNumberString:(NSString *)phoneStr;

/**
 *  iOS 格式化电话号码(3 * 4形式)
 *  手机号码格式的处理
 *  138 **** 3242
 */
+ (NSString *)handlePhoneNumberStarFormatWithNumberString:(NSString *)phoneStr;

@end

//cache include ：accompany，record file
@interface Memory : NSObject
+(NSString *)getCacheSize;
+(void)clearCache;
@end

@interface date : NSObject
+(NSString *)datetoStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoLongStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoLongLongStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date;
+(NSString *)datetoMonthStringWithDate:(NSTimeInterval)date format:(NSString *)format;

+(NSTimeInterval)getTimeStamp;

+ (NSArray *)getMonthFirstAndLastDayWith;
@end

@interface Share : NSObject
+(void)ShareWithTitle:(NSString *)title_ andShareUrl:(NSString *)shareUrl_ andShareImage:(NSString *)shareImage andShareText:(NSString *)shareText_ andVC:(UIViewController *)VC_;;
+(BOOL)shareAvailableWeiXin;
+(BOOL)shareAvailableQQ;
+(BOOL)shareAvailableSina;
@end

@interface image : NSObject
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

@interface HXDAttributedString : NSObject
+ (NSMutableAttributedString*)getMutableAttributedString:(NSString*)string textColor:(UIColor *)color length:(NSInteger)num;

//切割加粗生成首页 频道等的标题
+ (NSMutableAttributedString *)getTitleWithString:(NSString *)string size:(CGFloat)size;

@end
