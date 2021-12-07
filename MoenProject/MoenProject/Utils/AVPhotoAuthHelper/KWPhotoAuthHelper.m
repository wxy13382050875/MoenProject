//
//  KWPhotoAuthHelper.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "KWPhotoAuthHelper.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>



@implementation KWPhotoAuthHelper


/**
 *  相册或相机是否已授权 type: 1、相机 2、相册
 */
+ (BOOL)isPhotoOrCameraAuthorizedWithType:(NSInteger)type
{
    if (type == 1) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            // 用户尚未做出选择这个应用程序的问候
            if (authStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        // 用户接受
                    }
                }];
            }
            // 此应用程序没有被授权调用相机数据。
            else if (authStatus == AVAuthorizationStatusRestricted)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:confirmBtn];
                [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
                return NO;
            }
            // 用户已经明确否认了这一相机数据的应用程序访问
            else if (authStatus == AVAuthorizationStatusDenied)
            {
                NSLog(@"因为系统原因, 无法调用相机 -- 可能是家长控制权限。");
                return NO;
            }
            // AVAuthorizationStatusAuthorized -- 用户已经授权应用调用相机数据
            else
            {
                return YES;
            }
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"未检测到您的摄像头, 请在真机上测试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:confirmBtn];
            [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
    }
    else
    {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        //// 默认还没做出选择
        if (status == PHAuthorizationStatusNotDetermined) {
            // 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                    // 放一些使用相册的代码
                }
            }];
        }
        // 此应用程序没有被授权访问的照片数据
        else if (status == PHAuthorizationStatusRestricted)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:confirmBtn];
            [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
        //// 用户已经明确否认了这一照片数据的应用程序访问
        else if (status == PHAuthorizationStatusDenied)
        {
            NSLog(@"因为系统原因, 无法访问相册 -- 可能是家长控制权限。");
            return NO;
        }
        //PHAuthorizationStatusAuthorized   用户已经授权应用访问照片数据
        else
        {
            return YES;
        }
    }
    return NO;
}




@end
