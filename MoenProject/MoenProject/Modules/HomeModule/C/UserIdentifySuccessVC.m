//
//  UserIdentifySuccessVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/30.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "UserIdentifySuccessVC.h"
#import "HomePageItemCCell.h"
#import "UserIdentifySuccessCCell.h"
#import "RoleProfileModel.h"
#import "SellGoodsScanVC.h"
#import "StoreActivityVC.h"
#import "OrderManageVC.h"
#import "ReturnGoodsVC.h"
#import "ReturnGoodsManageVC.h"
#import "MemberIntentionVC.h"

#import "CustomerAccountVC.h"
#import "AddressListVC.h"
#import "CustomerRegistVC.h"
#import "SelectedTagVC.h"

@interface UserIdentifySuccessVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;


@end

@implementation UserIdentifySuccessVC

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
        if ([vc isKindOfClass:[CustomerRegistVC class]] ||
            [vc isKindOfClass:[SelectedTagVC class]]) {
            [marr removeObject:vc];
        }
        self.navigationController.viewControllers = marr;
    }
}

- (void)configBaseUI
{
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    if (self.controllerType == UserIdentifySuccessVCTypeRegister) {
        self.title = NSLocalizedString(@"register_success_title", nil);
    }
    else if (self.controllerType == UserIdentifySuccessVCTypeDistinguish)
    {
        self.title = NSLocalizedString(@"identify_success_title", nil);
    }
    
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageItemCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageItemCCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"UserIdentifySuccessCCell" bundle:nil] forCellWithReuseIdentifier:@"UserIdentifySuccessCCell"];
    
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView"];
}

- (void)configBaseData
{
    NSString* me_Config = @"";
    if (self.controllerType == UserIdentifySuccessVCTypeRegister) {
        me_Config = ME_Store_User_Register;
    }
    else
    {
        me_Config = ME_Store_Owner_Identity;
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
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.roleProfileArr.count;
    
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
        if (self.infoModel.referee.length > 0 ||
            self.infoModel.identity.length > 0) {
            return CGSizeMake(SCREEN_WIDTH, 235);
        }
        else
        {
            return CGSizeMake(SCREEN_WIDTH, 200);
        }
        
    }
    if (indexPath.section == 1) {
        return CGSizeMake((SCREEN_WIDTH - 4)/3, (SCREEN_WIDTH - 4)/3);
    }
    return CGSizeZero;
}

//定义collection 头部和底部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return  CGSizeMake(SCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return  CGSizeMake(SCREEN_WIDTH, 10);
    }
    return CGSizeZero;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UserIdentifySuccessCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserIdentifySuccessCCell" forIndexPath:indexPath];
        [cell showDataWithMembershipInfoModel:self.infoModel WithControllerType:self.controllerType];
        return cell;
    }
    else
    {
        HomePageItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCCell" forIndexPath:indexPath];
        [cell showDataWithRoleProfileModel:self.roleProfileArr[indexPath.row]];
        return cell;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSInteger section = indexPath.section;
    if (kind == UICollectionElementKindSectionHeader) {
        if (section == 1) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView" forIndexPath:indexPath];
            reusableview.backgroundColor = AppBgBlueGrayColor;
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 39)];
            contentView.backgroundColor = AppBgWhiteColor;
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 39)];
            titleLab.text = NSLocalizedString(@"quick_service", nil);
            titleLab.textColor = AppTitleBlackColor;
            titleLab.font = FONTLanTingR(14);
            titleLab.textAlignment = NSTextAlignmentLeft;
            [contentView addSubview:titleLab];
            [reusableview addSubview:contentView];
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView" forIndexPath:indexPath];
        reusableview.backgroundColor = AppBgBlueGrayColor;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            SellGoodsScanVC *sellGoodsScanVC = [[SellGoodsScanVC alloc] init];
            sellGoodsScanVC.customerId = self.infoModel.customerId;
            sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
        }
        if (indexPath.row == 1) {
            StoreActivityVC *storeActivityVC = [[StoreActivityVC alloc] init];
            storeActivityVC.customerId = self.infoModel.customerId;
            storeActivityVC.controllerType = StoreActivityVCPersonal;
            storeActivityVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeActivityVC animated:YES];
        }
        if (indexPath.row == 2) {
            CustomerAccountVC *customerAccountVC = [[CustomerAccountVC alloc] init];
            customerAccountVC.customerId = self.infoModel.customerId;
            customerAccountVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:customerAccountVC animated:YES];
        }
        
        if (indexPath.row == 3) {
            AddressListVC *addressListVC = [[AddressListVC alloc] init];
            addressListVC.customerId = self.infoModel.customerId;
            addressListVC.isDefault = YES;
            addressListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressListVC animated:YES];
        }
        
        if (indexPath.row == 4) {
            MemberIntentionVC *memberIntentionVC = [[MemberIntentionVC alloc] init];
            memberIntentionVC.userID = self.infoModel.customerId;
            memberIntentionVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:memberIntentionVC animated:YES];
        }
        
        if (indexPath.row == 5) {
            if (self.controllerType == UserIdentifySuccessVCTypeRegister) {
                SelectedTagVC *selectedTagVC = [[SelectedTagVC alloc] init];
                selectedTagVC.customerId = self.infoModel.customerId;
                selectedTagVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:selectedTagVC animated:YES];
                return;
            }
            OrderManageVC *orderManageVC = [[OrderManageVC alloc] init];
            orderManageVC.isIdentifion = YES;
            orderManageVC.customerId = self.infoModel.customerId;
            orderManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderManageVC animated:YES];
            
            
        }
        
        if (indexPath.row == 6) {
            
            ReturnGoodsVC *returnGoodsVC = [[ReturnGoodsVC alloc] init];
            returnGoodsVC.customerId = self.infoModel.customerId;
            returnGoodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:returnGoodsVC animated:YES];
        }
        
        if (indexPath.row == 7) {
            
            ReturnGoodsManageVC *returnGoodsManageVC = [[ReturnGoodsManageVC alloc] init];
            returnGoodsManageVC.isIdentify = YES;
            returnGoodsManageVC.customerId = self.infoModel.customerId;
            returnGoodsManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:returnGoodsManageVC animated:YES];
        }
        if (indexPath.row == 8) {
            SelectedTagVC *selectedTagVC = [[SelectedTagVC alloc] init];
            selectedTagVC.customerId = self.infoModel.customerId;
            selectedTagVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:selectedTagVC animated:YES];
        }
    }
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
