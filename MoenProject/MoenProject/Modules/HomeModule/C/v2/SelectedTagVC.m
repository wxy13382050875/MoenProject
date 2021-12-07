//
//  SelectedTagVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/11/18.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "SelectedTagVC.h"
#import "CommonCategoryModel.h"
#import "KWTypeConditionCCell.h"
#import "SegmentTypeModel.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "UserTagModel.h"
#import "CustomerRegistVC.h"
#import "UserIdentifySuccessVC.h"

@interface SelectedTagVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSMutableArray *selectDataArr;

/**右上角 保存按钮**/
@property (nonatomic, strong) UIButton *saveBtn;

/**判断用户是否设置过标签*/
@property (nonatomic, assign) BOOL isHaveTag;

/**请求完成状态*/
@property (nonatomic, assign) NSInteger completeState;

@property (nonatomic, strong) UserTagModel *customerTagModel;

@property (nonatomic, copy) NSString *currentSelectedTagId;
@end

@implementation SelectedTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseData];
    [self configBaseUI];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
        if ([vc isKindOfClass:[CustomerRegistVC class]]) {
            [marr removeObject:vc];
        }
        self.navigationController.viewControllers = marr;
    }
    

    //取消手势滑动
    if (self.controllerType == SelectedTagVCTypeFromRegister) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if (self.controllerType == SelectedTagVCTypeFromRegister) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)configBaseUI
{
    if (self.controllerType == SelectedTagVCTypeFromRegister) {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:ImageNamed(@"c_back_white_icon") forState:UIControlStateNormal];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [leftButton setTitle:@"跳过" forState:UIControlStateNormal];
        leftButton.titleLabel.font = FontBinB(16);
        leftButton.frame = CGRectMake(0, 0, 44, 44);
        [leftButton addTarget:self action:@selector(navLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    else
    {
        [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
        
    }
   
    self.title = @"选择客户标签";
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = FontBinB(16);
    [rightButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.saveBtn = rightButton;
    
    [self.view addSubview:self.collectionview];
}

- (void)configBaseData
{
    [self httpPath_load];
    [self httpPath_GetCustomerTag];
}

#pragma mark - 右边CollectionView  delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectDataArr.count;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(40.0f, 15.0f, 10.0f, 15.0f);
}
//设置纵向的行间距 (行与行的间距)
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

//设置横向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayouts
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 50)/3, 35);
}

//定义collection 头部和底部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SegmentTypeModel *model = self.selectDataArr[indexPath.row];
    KWTypeConditionCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KWTypeConditionCCell" forIndexPath:indexPath];
    [cell showDataWithSegmentTypeModelForSelectedTag:model];
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isHaveTag) {
        SegmentTypeModel *itemModel = self.selectDataArr[indexPath.row];
        if (!itemModel.isSelected) {
            
            self.currentSelectedTagId = itemModel.IDStr;
            for (SegmentTypeModel *model in self.selectDataArr) {
                model.isSelected = NO;
            }
            itemModel.isSelected = YES;
            [self.collectionview reloadData];
//            [self httpPath_SaveCustomerTag];
        }
    }
}

#pragma mark -- private
- (void)handleCustomerTagData
{
    if (self.completeState == 2) {
        if (self.customerTagModel.customerTagId.length) {
            self.isHaveTag = YES;
            for (SegmentTypeModel *itemModel in self.selectDataArr) {
                if ([itemModel.IDStr isEqualToString:self.customerTagModel.customerTagId]) {
                    itemModel.isSelected = YES;
                    self.currentSelectedTagId = self.customerTagModel.customerTagId;
                }
                else
                {
                    itemModel.isSelected = NO;
                }
            }
        }
        else
        {
            self.isHaveTag = NO;
            for (SegmentTypeModel *itemModel in self.selectDataArr) {
                itemModel.isSelected = NO;
            }
        }
        [self.collectionview reloadData];
        [self updateSaveBtnStatus];
    }
}

- (void)updateSaveBtnStatus
{
    if (self.isHaveTag) {
        [self.saveBtn setTitle:@"修改" forState:UIControlStateNormal];
    }
    else
    {
        [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
}


- (void)saveAction:(UIButton *)sender
{
    if (self.isHaveTag) {
        self.isHaveTag = NO;
        [self updateSaveBtnStatus];
    }
    else
    {
        if (self.currentSelectedTagId.length) {
            [self httpPath_SaveCustomerTag];
        }
        else
        {
            [[NSToastManager manager] showtoast:@"请选择客户标签"];
        }
        
    }
}

- (void)navLeftBarButtonClick
{
    [[NSToastManager manager] showtoast:@"请选择客户标签"];
//    UserIdentifySuccessVC *userIdentifySuccessVC = [[UserIdentifySuccessVC alloc] init];
//    userIdentifySuccessVC.controllerType = UserIdentifySuccessVCTypeRegister;
//    userIdentifySuccessVC.infoModel = self.infoModel;
//    userIdentifySuccessVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:userIdentifySuccessVC animated:YES];
}
#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_returnOrderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_load]) {
                self.completeState += 1;
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"CustomerLabel"]) {
                        [self.selectDataArr removeAllObjects];
                        for (CommonCategoryDataModel *model in itemModel.datas) {
                            SegmentTypeModel *itemModel = [[SegmentTypeModel alloc] init];
                            itemModel.name = model.des;
                            itemModel.IDStr = model.ID;
                            [self.selectDataArr addObject:itemModel];
                        }
                    }
                }
                [self handleCustomerTagData];
                [self.collectionview reloadData];
            }
            if ([operation.urlTag isEqualToString:Path_SaveCustomerTag]) {
                UserTagModel *model = (UserTagModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    
                    if (model.customerTagId.length) {
                        if (self.controllerType == SelectedTagVCTypeFromRegister) {
                            [[NSToastManager manager] showtoast:@"保存成功"];
                            UserIdentifySuccessVC *userIdentifySuccessVC = [[UserIdentifySuccessVC alloc] init];
                            userIdentifySuccessVC.controllerType = UserIdentifySuccessVCTypeRegister;
                            userIdentifySuccessVC.infoModel = self.infoModel;
                            userIdentifySuccessVC.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:userIdentifySuccessVC animated:YES];
                        }
                        else
                        {
                            [[NSToastManager manager] showtoast:@"保存成功"];
                            self.customerTagModel = model;
                            [self handleCustomerTagData];
                        }
                    }
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                    [self handleCustomerTagData];
                }
                
            }
            if ([operation.urlTag isEqualToString:Path_GetCustomerTag]) {
                UserTagModel *model = (UserTagModel *)parserObject;
                self.customerTagModel = model;
                self.completeState += 1;
                [self handleCustomerTagData];
            }
        }
    }
}

/**获取下拉数据Api*/
- (void)httpPath_load
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_load;
}

/**根据会员ID获取会员标签信息 Api*/
- (void)httpPath_GetCustomerTag
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: self.customerId forKey:@"customerId"];
    
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_GetCustomerTag;
}

/**保存会员标签信息 Api*/
- (void)httpPath_SaveCustomerTag
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: self.customerId forKey:@"customerId"];
    [parameters setValue: self.currentSelectedTagId forKey:@"customerTagId"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_SaveCustomerTag;
}



#pragma Mark- getters and setters

- (NSMutableArray *)selectDataArr
{
    if (!_selectDataArr) {
        _selectDataArr = [[NSMutableArray alloc] init];
    }
    return _selectDataArr;
}

- (UICollectionView *)collectionview {
    if (!_collectionview) {
        UICollectionViewLeftAlignedLayout *flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//竖直滚动
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
//        UICollectionViewLeftAlignedLayout *layout=[[UICollectionViewLeftAlignedLayout alloc] init];
//        flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;//竖直滚动
//        layout.minimumInteritemSpacing=10;//itme左右间距
//        layout.minimumLineSpacing=10;//itme 上下间距
//        //section 距上下左右的距离
//        layout.sectionInset=UIEdgeInsetsMake(5, 15, 15, 15);
//        //头部的size
//        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 20);
        
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - KWNavBarAndStatusBarHeight) collectionViewLayout:flowLayout];
        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.backgroundColor = [UIColor whiteColor];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.bounces = NO;
        [_collectionview registerNib:[UINib nibWithNibName:@"KWTypeConditionCCell" bundle:nil] forCellWithReuseIdentifier:@"KWTypeConditionCCell"];
    }
    return _collectionview;
}


@end
