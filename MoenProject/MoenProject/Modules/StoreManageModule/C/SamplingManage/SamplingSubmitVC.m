//
//  SamplingSubmitVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/6.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "SamplingSubmitVC.h"
#import "NSHttpClient.h"
#import "BaseModelFactory.h"
#import "ProductSampleResultModel.h"
#import "TZImagePickerController.h"
#import "KWPhotoAuthHelper.h"
#import "SamplingDetailVC.h"
#import "SDPhotoBrowser.h"
#import "FDAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHAsset.h>


@interface SamplingSubmitVC ()<SDPhotoBrowserDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate, FDAlertViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSDampButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *imageContainerArr;
@property (nonatomic, strong) NSMutableArray *deleteBtnContainerArr;
@property (nonatomic, assign) CGFloat imgWidth;

@property (nonatomic,strong) UIImagePickerController * imagePicker;
@property (nonatomic,assign) BOOL isBackAction;


@end

@implementation SamplingSubmitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self configSubViewFrame];
    [self updateImageView];
    
}

- (void)configBaseUI
{
    self.view.backgroundColor = AppBgWhiteColor;
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.submitBtn];
    [self createImageContainerBtn];
}


- (void)updateImageView
{
    for (UIImageView *imageview in self.imageContainerArr) {
        [imageview setHidden:YES];
        [imageview setImage:ImageNamed(@"s_add_image_icon")];
    }
    NSInteger imageCount = self.photoArray.count;
    for (int i = 0; i < imageCount; i ++) {
        UIImageView *btn = self.imageContainerArr[i];
        UIButton *deleteBtn = self.deleteBtnContainerArr[i];
        [deleteBtn setHidden:NO];
        [btn setHidden:NO];
        [btn setImage:self.photoArray[i]];
    }
    if (imageCount < 9) {
        UIImageView *btn = self.imageContainerArr[imageCount];
        UIButton *deleteBtn = self.deleteBtnContainerArr[imageCount];
        [deleteBtn setHidden:YES];
        [btn setHidden:NO];
        [btn setImage:ImageNamed(@"s_add_image_icon")];
    }
}


- (void)createImageContainerBtn
{
    for (int i = 0; i < 9; i ++) {
        UIImageView *imageBtn = [[UIImageView alloc] init];
        imageBtn.contentMode = UIViewContentModeScaleAspectFill;
        [imageBtn setImage:ImageNamed(@"s_add_image_icon")];
        imageBtn.userInteractionEnabled = YES;
        [imageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickAction:)]];
        imageBtn.tag = 12000 + i;
        [imageBtn setHidden:YES];
        imageBtn.clipsToBounds = YES;
        imageBtn.layer.borderWidth = 1;
        imageBtn.layer.borderColor = AppLineGrayColor.CGColor;
        [self.view addSubview:imageBtn];
        [self.imageContainerArr addObject:imageBtn];
        
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 70 - 10) / 3.0 - 15, 0, 15, 15)];
        [deleteBtn setImage:ImageNamed(@"s_delete_icon") forState:UIControlStateNormal];
        deleteBtn.tag = 13000 + i;
        [deleteBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchDown
         ];
        [imageBtn addSubview:deleteBtn];
        [self.deleteBtnContainerArr addObject:deleteBtn];
        
    }
}


- (void)configSubViewFrame
{
    [self.backBtn setFrame:CGRectMake(15, 30, 50, 30)];
    [self.submitBtn setFrame:CGRectMake(SCREEN_WIDTH - 65, 30, 50, 30)];
    
    CGFloat leftPadding = 35;
    CGFloat itemMargin = 5;
    CGFloat startX = leftPadding;
    CGFloat startY = 90;
    
    int feedNumber = 3;
    int rowIndex = 0;
    
    for (int i = 0; i < self.imageContainerArr.count; i ++) {
        UIImageView *btn = self.imageContainerArr[i];
        int imageIndex = i - feedNumber * rowIndex;
        if (imageIndex > (feedNumber - 1)) {
            imageIndex = 0;
            rowIndex ++;
            startX = leftPadding;
            startY = startY + self.imgWidth + itemMargin;
        }
        else
        {
            startX = leftPadding + (self.imgWidth + itemMargin) * imageIndex;
        }
        [btn setFrame:CGRectMake(startX, startY, self.imgWidth, self.imgWidth)];
    }
}

- (void)configBaseData
{
    self.imgWidth = (SCREEN_WIDTH - 70 - 10) / 3.0;
}

#pragma mark -- Private Methods
//处理图片的显示
- (void)handleImageShow
{
    
}

#pragma mark -- Touch Event
- (void)backBtnAction
{
    self.isBackAction = YES;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"出样信息未提交，确定要返回吗？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitBtnAction
{
    if (self.photoArray.count == 0) {
        [[NSToastManager manager] showtoast:@"请添加图片"];
        return;
    }
    [self confirmPushAction];
}

#pragma mark- event response
- (void)confirmPushAction
{
    
    self.isBackAction = NO;
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认发布出样信息？" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        if (self.isBackAction) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self upLoadImageAction];
        }
    }
}

#pragma mark -- Touch Event
- (void)imageClickAction:(UIGestureRecognizer *)sender
{
    NSInteger atIndex = [sender view].tag - 12000;
    if (atIndex == self.photoArray.count) {
        [self selectImageWithType];
    }
    else
    {
        SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
        broser.currentImageIndex = atIndex;
        //    broser.sourceImagesContainerView = self.view;
        broser.imageCount = self.photoArray.count;
        broser.delegate = self;
        [broser show];
    }
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.imageContainerArr[index];
    return imageView.image;
}

- (void)deleteImageAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 13000;
    [self.photoArray removeObjectAtIndex:atIndex];
    [self.assetsArray removeObjectAtIndex:atIndex];
    [self updateImageView];
}


#pragma Mark - private methods
- (void)selectImageWithType
{
    //    self.selectedImageType = type;
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
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
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
        UIImage *photo = [info objectForKey:UIImagePickerControllerEditedImage];
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
                [weakSelf.assetsArray addObject:imageAsset];
                [weakSelf.photoArray addObject:image];
                [weakSelf updateImageView];
            }
        }
    }];
}


- (void)extracted {
    [[NSHttpClient client] uploadWithUrl:Path_publishProductSampleImage imageArr:self.photoArray progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            MoenBaseModel *model = [BaseModelFactory modelWithURL:Path_publishProductSampleImage
                                                     responseJson:responseObject];
            if (model == nil) {
                model = [[MoenBaseModel alloc] init];
            }
            model.code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            model.message = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
            
            NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
            if ([resultCode isEqualToString:@"200"]) {
                [[NSToastManager manager] showtoast:@"发表出样报告成功"];
                ProductSampleResultModel *dataModel = (ProductSampleResultModel *)model;
                SamplingDetailVC *samplingDetailVC = [[SamplingDetailVC alloc] init];
                samplingDetailVC.controllerType = SamplingDetailVCTypeSuccess;
                samplingDetailVC.dataModel = dataModel;
                [self.navigationController setNavigationBarHidden:NO];
                [self.navigationController pushViewController:samplingDetailVC animated:YES];
                
            }else{
                [[NSToastManager manager] showtoast:model.message];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
        NSLog(@"%@", error);
        [[NSToastManager manager] hideprogress];
    }];
}

/**上传图片操作*/
- (void)upLoadImageAction
{
    [[NSToastManager manager] showmodalityprogress];
    [self extracted];
}



#pragma mark -- 弹出相册选择
- (void)pushTZImagePickerController {
    WEAKSELF
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.assetsArray; // 目前已经选中的图片数组
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.circleCropRadius = 100;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.assetsArray = [assets mutableCopy];
        weakSelf.photoArray = [photos mutableCopy];
        [weakSelf updateImageView];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePicker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    }
    return _imagePicker;
}

#pragma mark -- Getter&Setter
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ImageNamed(@"s_backbtn_icon") forState:UIControlStateNormal];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}

- (NSDampButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [NSDampButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_submitBtn setTitle:@"发表" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchDown];
    }
    return _submitBtn;
}

- (NSMutableArray *)imageContainerArr
{
    if (!_imageContainerArr) {
        _imageContainerArr = [[NSMutableArray alloc] init];
    }
    return _imageContainerArr;
}

- (NSMutableArray *)deleteBtnContainerArr
{
    if (!_deleteBtnContainerArr) {
        _deleteBtnContainerArr = [[NSMutableArray alloc] init];
    }
    return _deleteBtnContainerArr;
}

- (void)setPhotoArray:(NSMutableArray *)photoArray
{
    _photoArray = photoArray;
}




@end
