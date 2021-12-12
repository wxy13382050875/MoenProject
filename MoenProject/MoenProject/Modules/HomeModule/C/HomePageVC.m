//
//  HomePageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageBannerCCell.h"
#import "HomePageItemCCell.h"
#import "HomePageSearchCCell.h"
#import "RoleProfileModel.h"

#import "UserIdentifyVC.h"
#import "StoreActivityVC.h"
#import "CustomerRegistVC.h"
#import "PackageManageVC.h"
#import "IMLeaderManageVC.h"
#import "MembershipInfoModel.h"
#import "UserIdentifySuccessVC.h"
#import "FDAlertView.h"
#import "IMSellerManageVC.h"

#import "HomeDataModel.h"
//#import "FPSDisplay.h"

@interface HomePageVC ()<UICollectionViewDelegate, UICollectionViewDataSource, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;

@property (nonatomic, copy) NSString *identifyPhone;

@property (nonatomic, assign) BOOL isCanHandle;

@property (nonatomic, strong) HomeDataModel *bannerModel;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, assign) BOOL isClearContent;
@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"甜甜家具旗舰店";
    self.isCanHandle = YES;
    [self configBaseData];
    [self configBaseUI];
    
//    [FPSDisplay shareFPSDisplay];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLab.text = [QZLUserConfig sharedInstance].shopName;
    [self httpPath_getHomePage];
}

- (void)configBaseUI
{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageBannerCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageBannerCCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageItemCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageItemCCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageSearchCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageSearchCCell"];
    
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView"];
    
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView"];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,44)];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.font = FONTLanTingB(17);
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.titleLab;
    
    
}

- (void)configBaseData
{
    NSString* me_Config = @"";
    if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
        me_Config = ME_Store_Owner_HomePage;
    }else
    {
        me_Config = ME_Store_Guide_HomePage;
    }
    
    
    NSDictionary* dict = [TransCodingHelper dictionaryWithJsonString:me_Config];
    NSArray* items = [dict objectForKey:@"datas"];
    for (NSDictionary* dict in items) {
        RoleProfileModel * model = [[RoleProfileModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        [self.roleProfileArr addObject:model];
    }
}


#pragma mark - 右边CollectionView  delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.roleProfileArr.count;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}
//设置纵向的行间距 (行与行的间距)
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

//设置横向的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*170);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    if (indexPath.section == 2) {
        return CGSizeMake((SCREEN_WIDTH - 4)/3, (SCREEN_WIDTH - 4)/3);
    }
    return CGSizeZero;
}

//定义collection 头部和底部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 10);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 4);
    }
    return CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if (indexPath.section == 0) {
        HomePageBannerCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageBannerCCell" forIndexPath:indexPath];
        [cell showDataWithHomeDataModel:self.bannerModel];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        HomePageSearchCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageSearchCCell" forIndexPath:indexPath];
        cell.isClearContent = self.isClearContent;
        self.isClearContent = NO;
        cell.searchBlock = ^(NSString *searchStr) {
            [weakSelf httpPath_getCustomerWithPhoneNumber:searchStr];
        };
        return cell;
    }
    else
    {
        HomePageItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCCell" forIndexPath:indexPath];
        [cell showDataWithRoleProfileModel:self.roleProfileArr[indexPath.row] WithHomeDataModel:self.bannerModel];
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSInteger section = indexPath.section;
    if (kind == UICollectionElementKindSectionHeader) {
        if (section == 1) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView" forIndexPath:indexPath];
            reusableview.backgroundColor = AppBgBlueGrayColor;
            
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        if (section == 1) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView" forIndexPath:indexPath];
            reusableview.backgroundColor = AppBgBlueGrayColor;
        }
        
    }
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CustomerRegistVC *customerRegistVC = [[CustomerRegistVC alloc] init];
            customerRegistVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:customerRegistVC animated:YES];
        }
        if (indexPath.row == 1) {
            UserIdentifyVC *userIdentifyVC = [[UserIdentifyVC alloc] init];
            userIdentifyVC.hidesBottomBarWhenPushed = YES;
            userIdentifyVC.controllerType = UserIdentifyVCTypeSaleGoods;
            [self.navigationController pushViewController:userIdentifyVC animated:YES];
        }
        if (indexPath.row == 2) {
            StoreActivityVC *storeActivityVC = [[StoreActivityVC alloc] init];
            storeActivityVC.controllerType = StoreActivityVCCurrent;
            storeActivityVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeActivityVC animated:YES];
        }
        if (indexPath.row == 3) {
            if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
                IMLeaderManageVC *imLeaderManageVC = [[IMLeaderManageVC alloc] init];
                imLeaderManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:imLeaderManageVC animated:YES];
            }else
            {
                IMSellerManageVC *iMSellerManageVC = [[IMSellerManageVC alloc] init];
                iMSellerManageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:iMSellerManageVC animated:YES];
            }
        }
        if (indexPath.row == 4) {
            PackageManageVC *packageManageVC = [[PackageManageVC alloc] init];
            packageManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packageManageVC animated:YES];
        }
    }
}


- (void)skipToUserIdentifySuccessVCWithModel:(MembershipInfoModel *)model
{
    UserIdentifySuccessVC *userIdentifySuccessVC = [[UserIdentifySuccessVC alloc] init];
    userIdentifySuccessVC.controllerType = UserIdentifySuccessVCTypeDistinguish;
    userIdentifySuccessVC.infoModel = model;
    userIdentifySuccessVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userIdentifySuccessVC animated:YES];
}


#pragma mark -- FDAlertViewDelegate
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        //用户注册
        CustomerRegistVC *customerRegistVC = [[CustomerRegistVC alloc] init];
        customerRegistVC.userPhone = self.identifyPhone;
        customerRegistVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customerRegistVC animated:YES];
    }
    else
    {
        self.isClearContent = YES;
        [self.collectionview reloadData];
    }
}


#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getHomePage]) {
            
        }
        self.isCanHandle = YES;
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getHomePage]) {
                HomeDataModel *model = (HomeDataModel *)parserObject;
                [QZLUserConfig sharedInstance].useInventory = model.useInventory;
                if ([model.code isEqualToString:@"200"]) {
                    self.bannerModel = model;
                    [self.collectionview reloadData];
                }
            }
            if ([operation.urlTag isEqualToString:Path_getCustomer])
            {
                MembershipInfoModel *model = (MembershipInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [weakSelf skipToUserIdentifySuccessVCWithModel:model];
                }
                else if ([model.code isEqualToString:@"3002"])
                {
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提醒" alterType:FDAltertViewTypeTips message:@"用户还未注册，请确认是否注册？" delegate:self buttonTitles:@"取消", @"确定", nil];
                    [alert show];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                self.isCanHandle = YES;
            }
        }
    }
}

/**首页信息 Api */
- (void)httpPath_getHomePage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:[QZLUserConfig sharedInstance].token.length > 0 ? [QZLUserConfig sharedInstance].token:@"" forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getHomePage;
}


/**获取会员信息Api*/
- (void)httpPath_getCustomerWithPhoneNumber:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        [[NSToastManager manager] showtoast:@"请输入手机号码"];
        return;
    }
   if (![Utils checkTelNumber:phoneNumber]) {
       [[NSToastManager manager] showtoast:@"手机号格式不正确"];
       return;
    }
    if (!self.isCanHandle) {
        return;
    }
    [self.view endEditing:YES];
    self.identifyPhone = phoneNumber;
    self.isCanHandle = NO;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNumber forKey:@"phone"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getCustomer;
}



#pragma mark- getters and setters
- (NSMutableArray *)roleProfileArr
{
    if (!_roleProfileArr) {
        _roleProfileArr = [[NSMutableArray alloc] init];
    }
    return _roleProfileArr;
}



@end
