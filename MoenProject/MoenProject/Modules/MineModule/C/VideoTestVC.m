//
//  VideoTestVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/3/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "VideoTestVC.h"
//#import <AssetsLibrary/AssetsLibrary.h>//资产库框架

//#import <MobileCoreServices/MobileCoreServices.h>//移动核心服务框架

@interface VideoTestVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//图像选择控制器

@property(nonatomic,strong)UIImagePickerController *picker;
@end

@implementation VideoTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化图像选择控制器
    
    _picker = [[UIImagePickerController alloc]init];
    
    //遵守代理
    _picker.delegate =self;
    
    UIButton *clickBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    [clickBtn setTitle:@"点击" forState:UIControlStateNormal];
    clickBtn.backgroundColor = UIColor.redColor;
    [clickBtn addTarget:self action:@selector(takePhote) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:clickBtn];
    // Do any additional setup after loading the view.
}

- (void)takePhote
{
//    if([UIImagePickerControllerisSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//
//    {
//
        // 将sourceType设为UIImagePickerControllerSourceTypeCamera代表拍照或拍视频

        _picker.sourceType =UIImagePickerControllerSourceTypeCamera;

        // 设置拍摄照片

        _picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;

        // 设置使用手机的后置摄像头（默认使用后置摄像头）

        _picker.cameraDevice =UIImagePickerControllerCameraDeviceRear;

        // 设置使用手机的前置摄像头。

        //picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;

        // 设置拍摄的照片允许编辑

        _picker.allowsEditing =YES;
//
//
//
//    }else{
//
//
//
//        NSLog(@"模拟器无法打开摄像头");
//
//    }
//
//    // 显示picker视图控制器
//
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - 图像选择控制器代理实现

// 当得到照片或者视频后，调用该方法

-(void)imagePickerController:(UIImagePickerController *)picker

didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
//    NSLog(@"info--->成功：%@", info);
//
//    // 获取用户拍摄的是照片还是视频
//
//    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//
//
//
//    // 判断获取类型：图片，并且是刚拍摄的照片
//
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]
//
//        && picker.sourceType ==UIImagePickerControllerSourceTypeCamera)
//
//    {
//
//        UIImage *theImage =nil;
//
//        // 判断，图片是否允许修改
//
//        if ([picker allowsEditing])
//
//        {
//
//            // 获取用户编辑之后的图像
//
//            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//
//
//
//        }else {
//
//            // 获取原始的照片
//
//            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//
//        }
//
//        // 保存图片到相册中
//
//        UIImageWriteToSavedPhotosAlbum(theImage,self,nil,nil);
//
//
//
//    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//判断获取类型：视频，并且是刚拍摄的视频
//
//
//
//        //获取视频文件的url
//
//        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
//
//
//
//        //创建ALAssetsLibrary对象并将视频保存到媒体库
//
//        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
//
//        // 将视频保存到相册中
//
//        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL
//
//                                          completionBlock:^(NSURL *assetURL,NSError *error)
//
//         {
//
//             // 如果没有错误，显示保存成功。
//
//             if (!error)
//
//             {
//
//                 NSLog(@"视频保存成功！");
//
//
//
//             }else {
//
//
//
//                 NSLog(@"保存视频出现错误：%@", error);
//
//             }
//
//         }];
//
//    }
//
    // 隐藏UIImagePickerController
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
