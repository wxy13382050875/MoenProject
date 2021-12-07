//
//  SamplingManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingManageVC.h"
#import "KWPhotoAuthHelper.h"
#import "TZImagePickerController.h"
#import "SamplingSubmitVC.h"
#import "SamplingDetailVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PHAsset.h>

@interface SamplingManageVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic,strong) UIImagePickerController * imagePicker;

@end

@implementation SamplingManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"sampling_release", nil);

}

- (void)configBaseData
{
    
    
}

- (IBAction)upLoadAction:(UIButton *)sender {
    [self selectImageWithType];
}

- (IBAction)searchHistoryAction:(UIButton *)sender {
    
    SamplingDetailVC *samplingDetailVC = [[SamplingDetailVC alloc] init];
    [self.navigationController pushViewController:samplingDetailVC animated:YES];
}

#pragma Mark - private methods
- (void)selectImageWithType
{
    UIAlertController *photoActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithSourceType:1];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoWithSourceType:2];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [photoActionSheet addAction:cameraAction];
    [photoActionSheet addAction:albumAction];
    [photoActionSheet addAction:cancelAction];
    [self presentViewController:photoActionSheet animated:YES completion:^{
    }];
}


#pragma mark - UIImagePickerController
- (void)takePhotoWithSourceType:(NSInteger)type{
    
    if ([KWPhotoAuthHelper isPhotoOrCameraAuthorizedWithType:type]) {
        if (type == 1) {
            if ([KWPhotoAuthHelper isPhotoOrCameraAuthorizedWithType:2]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:self.imagePicker animated:YES completion:nil];
                });
            }
        }
        else
        {
            [self pushTZImagePickerController];
        }
        
    }
}

#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WEAKSELF;
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (photo) {
            [weakSelf loadImageFinished:photo];
        }
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    WEAKSELF;
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
                
            }];
            if (imageAsset)
            {
                [weakSelf takePhoteSuccessActionWithPhote:image WithAsset:imageAsset];
            }
        }
    }];
}


- (void)takePhoteSuccessActionWithPhote:(UIImage *)image WithAsset:(PHAsset *)asset
{
    SamplingSubmitVC *samplingSubmitVC = [[SamplingSubmitVC alloc] init];
    samplingSubmitVC.photoArray = @[image].mutableCopy;
    samplingSubmitVC.assetsArray = @[asset].mutableCopy;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:samplingSubmitVC];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
//        return;
//    }
//    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
//        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.frame.size.width < 42) {
//                [viewController.view sendSubviewToBack:obj];
//                *stop = YES;
//            }
//        }];
//    }
//}


#pragma mark -- 弹出相册选择
- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];

    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.circleCropRadius = 100;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        SamplingSubmitVC *samplingSubmitVC = [[SamplingSubmitVC alloc] init];
        samplingSubmitVC.photoArray = [photos mutableCopy];
        samplingSubmitVC.assetsArray = [assets mutableCopy];
        
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:samplingSubmitVC];
        [nav setNavigationBarHidden:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        if (@available(iOS 11.0, *)) {
            _imagePicker.imageExportPreset = UIImagePickerControllerImageURLExportPresetCompatible;
        }
        
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePicker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    return _imagePicker;
}



@end
