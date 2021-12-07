//
//  NSString+Awesome.m
//  baseProject
//
//  Created by Davis on 16/11/11.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "NSString+XWAdd.h"
#import <CommonCrypto/CommonCrypto.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/utsname.h>
//获取一个32位随机数
static const char _randomStr[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";   //!@#$%^*()

@implementation NSString (XWAdd)

- (CGSize)sizeWithFont:(UIFont *)font Size:(CGSize)size
{
    CGSize resultSize;
    NSDictionary *attributes = @{NSFontAttributeName:font};
    resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return resultSize;
}

+ (instancetype)getTimeStrWithLong:(long)time
{
    time = time / 1000;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString* escapedString = [input stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char* bytes = data.bytes;
    NSMutableString* encodedString = [NSMutableString string];
    
    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length)
    {
        uint16_t code = *((uint16_t*) &bytes[bytesRead]);
        if (code > 0x007E)
        {
            [encodedString appendFormat:@"%%u%04X", code];
        }
        else
        {
            [encodedString appendFormat:@"%C", code];
        }
        bytesRead += sizeof(uint16_t);
    }
    
    // done
    return encodedString;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    
    return unesp(input);
}

Byte getInt(char c){
    if(c>='0'&&c<='9'){
        return c-'0';
    }else if((c>='a'&&c<='f')){
        return 10+(c-'a');
    }else if((c>='A'&&c<='F')){
        return 10+(c-'A');
    }
    return c;
}
int  getIntStr(NSString *src,int len){
    if(len==2){
        Byte c1 = getInt([src characterAtIndex:(NSUInteger)0]);
        Byte c2 = getInt([src characterAtIndex:(NSUInteger)1]);
        return ((c1&0x0f)<<4)|(c2&0x0f);
    }else{
        
        Byte c1 = getInt([src characterAtIndex:(NSUInteger)0]);
        
        Byte c2 = getInt([src characterAtIndex:(NSUInteger)1]);
        Byte c3 = getInt([src characterAtIndex:(NSUInteger)2]);
        Byte c4 = getInt([src characterAtIndex:(NSUInteger)3]);
        return( ((c1&0x0f)<<12)
               |((c2&0x0f)<<8)
               |((c3&0x0f)<<4)
               |(c4&0x0f));
    }
    
}


NSString * tohex(int tmpid)
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

NSString* unesp(NSString* src){
    int lastPos = 0;
    int pos=0;
    unichar ch;
    NSString * tmp = @"";
    while(lastPos<src.length){
        NSRange range;
        
        range = [src rangeOfString:@"%" options:NSLiteralSearch range:NSMakeRange(lastPos, src.length-lastPos)];
        if (range.location != NSNotFound) {
            pos = (int)range.location;
        }else{
            pos = -1;
        }
        
        if(pos == lastPos){
            
            if([src characterAtIndex:(NSUInteger)(pos+1)]=='u'){
                NSString* ts = [src substringWithRange:NSMakeRange(pos+2,4)];
                
                int d = getIntStr(ts,4);
                ch = (unichar)d;
                NSLog(@"%@%C",tohex(d),ch);
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                
                lastPos = pos+6;
                
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(pos+1,2)];
                int d = getIntStr(ts,2);
                ch = (unichar)d;
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%C",ch]];
                lastPos = pos+3;
            }
            
        }else{
            if(pos ==-1){
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,src.length-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos = (int)src.length;
            }else{
                NSString* ts = [src substringWithRange:NSMakeRange(lastPos,pos-lastPos)];
                
                tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@",ts]];
                lastPos  = pos;
            }
        }
    }
    
    return tmp;
}

+ (NSString *)getNowInterval {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate  date] timeIntervalSince1970]];
}

+ (NSString *)removeSomeEscape:(NSMutableString *)string {
    NSString *tempStr = nil;
    
    if ([string containsString:@"[{"]) {
        tempStr = [string stringByReplacingOccurrencesOfString:@"[{" withString:@""];
    } else if ([string containsString:@"{"]) {
        tempStr = [string stringByReplacingOccurrencesOfString:@"{" withString:@""];
    }
    if ([tempStr containsString:@"\""]) {
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    }
    return tempStr;
}

+ (NSInteger)getDay:(NSString *)timeStr {
    return [[timeStr substringWithRange:NSMakeRange(6, 2)] integerValue];
}

+ (NSString *)getHour:(NSString *)timeStr {
    NSInteger hour = [[timeStr substringWithRange:NSMakeRange(8, 2)] integerValue];
    NSString *hourStr = [NSString stringWithFormat:@"%02ld:00",hour];
    return hourStr;
}
+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - 散列函数
- (NSString *)md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - HMAC 散列函数
- (NSString *)hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 文件散列函数

#define FileHashDefaultChunkSizeForReadingData 4096

- (NSString *)fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 助手方法
/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}


//设备IP
+ (NSString *)deviceIP {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] || [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"pdp_ip0"] ) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    NSLog(@"手机的IP是：%@", address);
    return address;
}

+ (NSString *)deviceModel {
    static NSString *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });
    return model;
}

//设备型号
+ (NSString *)deviceName {
    static NSString *deviceModelName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *model = [self deviceModel];
        if (!model) return;
        NSDictionary *machineModels = @{
                                        //Apple TV
                                        @"AppleTV2,1" : @"Apple TV 2",
                                        @"AppleTV3,1" : @"Apple TV 3",
                                        @"AppleTV3,2" : @"Apple TV 3",
                                        @"AppleTV5,3" : @"Apple TV 4",
                                        @"AppleTV6,2" : @"Apple TV 4K",
                                        
                                        //Apple Watch
                                        @"Watch1,1" : @"Apple Watch 38mm",
                                        @"Watch1,2" : @"Apple Watch 42mm",
                                        @"Watch2,6" : @"Apple Watch Series 1 38mm",
                                        @"Watch2,7" : @"Apple Watch Series 1 42mm",
                                        @"Watch2,3" : @"Apple Watch Series 2 38mm",
                                        @"Watch2,4" : @"Apple Watch Series 2 42mm",
                                        @"Watch3,1" : @"Apple Watch Series 3 38mm",
                                        @"Watch3,2" : @"Apple Watch Series 3 42mm",
                                        @"Watch3,3" : @"Apple Watch Series 3 38mm",
                                        @"Watch3,4" : @"Apple Watch Series 3 42mm",
                                        
                                        //iPad
                                        @"iPad1,1" : @"iPad",
                                        @"iPad2,1" : @"iPad 2 (WiFi)",
                                        @"iPad2,2" : @"iPad 2 (GSM)",
                                        @"iPad2,3" : @"iPad 2 (CDMA)",
                                        @"iPad2,4" : @"iPad 2",
                                        @"iPad2,5" : @"iPad mini (WiFi)",
                                        @"iPad2,6" : @"iPad mini (4G)",
                                        @"iPad2,7" : @"iPad mini (CDMA EV-DO)",
                                        @"iPad3,1" : @"iPad 3 (WiFi)",
                                        @"iPad3,2" : @"iPad 3 (CDMA)",
                                        @"iPad3,3" : @"iPad 3 (4G)",
                                        @"iPad3,4" : @"iPad 4 (WiFi)",
                                        @"iPad3,5" : @"iPad 4 (CDMA)",
                                        @"iPad3,6" : @"iPad 4 (4G)",
                                        @"iPad4,1" : @"iPad Air (WiFi)",
                                        @"iPad4,2" : @"iPad Air (4G)",
                                        @"iPad4,3" : @"iPad Air (4G)",
                                        @"iPad4,4" : @"iPad mini 2 (WiFi)",
                                        @"iPad4,5" : @"iPad mini 2 (4G)",
                                        @"iPad4,6" : @"iPad mini 2 (CDMA EV-DO)",
                                        @"iPad4,7" : @"iPad mini 3 (WiFi)",
                                        @"iPad4,8" : @"iPad mini 3 (4G)",
                                        @"iPad4,9" : @"iPad mini 3 (4G)",
                                        @"iPad5,1" : @"iPad mini 4 (WiFi)",
                                        @"iPad5,2" : @"iPad mini 4 (4G)",
                                        @"iPad5,3" : @"iPad Air 2 (WiFi)",
                                        @"iPad5,4" : @"iPad Air 2 (4G)",
                                        @"iPad6,3" : @"iPad Pro (9.7-inch-WiFi)",
                                        @"iPad6,4" : @"iPad Pro (9.7-inch-4G)",
                                        @"iPad6,7" : @"iPad Pro (12.9-inch-WiFi)",
                                        @"iPad6,8" : @"iPad Pro (12.9-inch-4G)",
                                        @"iPad6,11" : @"iPad 5 (WiFi)",
                                        @"iPad6,12" : @"iPad 5 (4G)",
                                        @"iPad7,1" : @"iPad Pro 2 (12.9-inch-WiFi)",
                                        @"iPad7,2" : @"iPad Pro 2 (12.9-inch-4G)",
                                        @"iPad7,3" : @"iPad Pro (10.5-inch-WiFi)",
                                        @"iPad7,4" : @"iPad Pro (10.5-inch-4G)",
                                        @"iPad7,5" : @"iPad 6 (WiFi)",
                                        @"iPad7,6" : @"iPad 6 (4G)",
                                        
                                        //iPhone
                                        @"iPhone1,1" : @"iPhone",
                                        @"iPhone1,2" : @"iPhone 3G",
                                        @"iPhone2,1" : @"iPhone 3GS",
                                        @"iPhone3,1" : @"iPhone 4",
                                        @"iPhone3,2" : @"iPhone 4",
                                        @"iPhone3,3" : @"iPhone 4",
                                        @"iPhone4,1" : @"iPhone 4S",
                                        @"iPhone5,1" : @"iPhone 5",
                                        @"iPhone5,2" : @"iPhone 5",
                                        @"iPhone5,3" : @"iPhone 5c",
                                        @"iPhone5,4" : @"iPhone 5c",
                                        @"iPhone6,1" : @"iPhone 5s",
                                        @"iPhone6,2" : @"iPhone 5s",
                                        @"iPhone7,2" : @"iPhone 6",
                                        @"iPhone7,1" : @"iPhone 6 Plus",
                                        @"iPhone8,1" : @"iPhone 6s",
                                        @"iPhone8,2" : @"iPhone 6s Plus",
                                        @"iPhone8,4" : @"iPhone SE",
                                        @"iPhone9,1" : @"iPhone 7",
                                        @"iPhone9,3" : @"iPhone 7",
                                        @"iPhone9,2" : @"iPhone 7 Plus",
                                        @"iPhone9,4" : @"iPhone 7 Plus",
                                        @"iPhone10,1" : @"iPhone 8",
                                        @"iPhone10,4" : @"iPhone 8",
                                        @"iPhone10,2" : @"iPhone 8 Plus",
                                        @"iPhone10,5" : @"iPhone 8 Plus",
                                        @"iPhone10,3" : @"iPhone X",
                                        @"iPhone10,6" : @"iPhone X",
                                        
                                        //iPod touch
                                        @"iPod1,1" : @"iPod touch",
                                        @"iPod2,1" : @"iPod touch 2",
                                        @"iPod3,1" : @"iPod touch 3",
                                        @"iPod4,1" : @"iPod touch 4",
                                        @"iPod5,1" : @"iPod touch 5",
                                        @"iPod7,1" : @"iPod touch 6",
                                        
                                        //Simulator
                                        @"i386" : @"Simulator x86",
                                        @"x86_64" : @"Simulator x64",
                                        };
        deviceModelName = machineModels[model];
        if (!deviceModelName) deviceModelName = model;
    });
    return deviceModelName;
}

+ (NSString *)deviceWIP {
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"https://ifconfig.me/ip"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    if(error != nil) {
        ip = @"0.0.0.0";
    }
    return ip;
}

//1、获取一个随机整数范围在：[0,100)包括0，不包括100  int x = arc4random() % 100;
// 获取一个随机数范围在：[500,1000]，包括500，不包括1000  int y = (arc4random() % 501) + 500;
//所以如果获取一个32位的随机数。就从_randomStr里面选择 _randomStr一共有62位长度。如果加上后面的符合就有71位。所以是%62  arc4random()%62
+(NSString*)randomStr
{
    char datas[32];
    for (int x=0;x<32;datas[x++] =_randomStr[arc4random()%62]); //71
    return [[NSString alloc] initWithBytes:datas length:32 encoding:NSUTF8StringEncoding];
}
+ (BOOL)cmpNewVersion:(NSString *)newVersion oldVersion:(NSString *)oddVersion{
    NSArray *newVs = [newVersion componentsSeparatedByString:@"."];
    NSArray *oldVs = [oddVersion componentsSeparatedByString:@"."];
    NSInteger cmpCount = oldVs.count;
    if (newVs.count < oldVs.count) {
        cmpCount = newVs.count;
    }
    for (int i = 0; i<cmpCount; i++) {
        int nv = [newVs[i] intValue];
        int ov = [oldVs[i] intValue];
        //NSLog(@"ov1=%@,nv1=%@,i=%@",@(ov),@(nv),@(i));
        if (nv!=ov) {
            if (nv>ov) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
    
}
@end
