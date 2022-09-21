//
//  StoreManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreManageVC.h"
#import "HomePageItemCCell.h"
#import "RoleProfileModel.h"
#import "SamplingManageVC.h"
#import "SamplingInputVC.h"
#import "StoreCustomerVC.h"
#import "ProfessionalCustomerVC.h"
#import "CouponRecordVC.h"
#import "PatrolStoreCheckVC.h"
#import "StaffManageVC.h"
#import "GoodsManageVC.h"
#import "OrderManageVC.h"
#import "CustomerOrderManageVC.h"
#import "ReturnGoodsVC.h"
#import "ReturnGoodsManageVC.h"
#import "UserIdentifyVC.h"
#import "PurchaseOrderManageVC.h"
#import "ExchangeGoodsVC.h"
@interface StoreManageVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation StoreManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseData];
    [self configBaseUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLab.text = [QZLUserConfig sharedInstance].shopName;
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
        me_Config = ME_Store_Owner_StoreManage;
    }else
    {
        me_Config = ME_Store_Guide_StoreManage;
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
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
        return CGSizeMake((SCREEN_WIDTH - 4)/3, (SCREEN_WIDTH - 4)/3);
    }
    return CGSizeZero;
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
    HomePageItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCCell" forIndexPath:indexPath];
    [cell showDataWithRoleProfileModel:self.roleProfileArr[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;    
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoleProfileModel * model = self.roleProfileArr[indexPath.row];
    switch (model.skipid) {
        case 0:
        {
            StoreCustomerVC *storeCustomerVC = [[StoreCustomerVC alloc] init];
            storeCustomerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeCustomerVC animated:YES];
        }
            break;
        case 1:
        {
            OrderManageVC *orderManageVC = [[OrderManageVC alloc] init];
            orderManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderManageVC animated:YES];
        }
            break;
        case 2:
        {
            GoodsManageVC *goodsManageVC = [[GoodsManageVC alloc] init];
            goodsManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsManageVC animated:YES];
        }
            break;
        case 3:
        {
            ProfessionalCustomerVC *professionalCustomerVC = [[ProfessionalCustomerVC alloc] init];
            professionalCustomerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:professionalCustomerVC animated:YES];
        }
            break;
        case 4:
        {
            CustomerOrderManageVC *customerOrderManageVC = [[CustomerOrderManageVC alloc] init];
            customerOrderManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:customerOrderManageVC animated:YES];
        }
            break;
        case 5:
        {
            StaffManageVC *staffManageVC = [[StaffManageVC alloc] init];
            staffManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:staffManageVC animated:YES];
        }
            break;
        case 6:
        {
            SamplingInputVC *samplingInputVC = [[SamplingInputVC alloc] init];
            samplingInputVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:samplingInputVC animated:YES];
        }
            break;
        case 7:
        {
            SamplingManageVC *samplingManageVC = [[SamplingManageVC alloc] init];
            samplingManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:samplingManageVC animated:YES];
        }
            break;
        case 8:
        {
            PatrolStoreCheckVC *patrolStoreCheckVC = [[PatrolStoreCheckVC alloc] init];
            patrolStoreCheckVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:patrolStoreCheckVC animated:YES];
        }
            break;
        case 9:
        {
            UserIdentifyVC *userIdentifyVC = [[UserIdentifyVC alloc] init];
            userIdentifyVC.hidesBottomBarWhenPushed = YES;
            userIdentifyVC.controllerType = UserIdentifyVCTypeReturnGoods;
            [self.navigationController pushViewController:userIdentifyVC animated:YES];

        }
            break;
        case 10:
        {
            ReturnGoodsManageVC *returnGoodsManageVC = [[ReturnGoodsManageVC alloc] init];
            returnGoodsManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:returnGoodsManageVC animated:YES];
        }
            break;
        case 11:
        {
            CouponRecordVC *couponRecordVC = [[CouponRecordVC alloc] init];
            couponRecordVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:couponRecordVC animated:YES];
        }
            break;
        case 12://换货
        {
//            ExchangeGoodsVC *exchangeGoodsVC = [[ExchangeGoodsVC alloc] init];
//            exchangeGoodsVC.hidesBottomBarWhenPushed = YES;
//            exchangeGoodsVC.isIdentifion = NO;
//            [self.navigationController pushViewController:exchangeGoodsVC animated:YES];
            
            UserIdentifyVC *userIdentifyVC = [[UserIdentifyVC alloc] init];
            userIdentifyVC.hidesBottomBarWhenPushed = YES;
            userIdentifyVC.controllerType = UserIdentifyVCTypeExchangeGoods;
            [self.navigationController pushViewController:userIdentifyVC animated:YES];
        }
            break;
        case 13://换货单管理
        {
            PurchaseOrderManageVC *purchaseOrderManageVC = [[PurchaseOrderManageVC alloc] init];
            purchaseOrderManageVC.hidesBottomBarWhenPushed = YES;
            purchaseOrderManageVC.controllerType =PurchaseOrderManageVCTypeShopExchange;
            [self.navigationController pushViewController:purchaseOrderManageVC animated:YES];
        }
            break;
        default:
            break;
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
