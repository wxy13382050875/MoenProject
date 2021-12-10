//
//  StockManageChildVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/8/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "StockManageChildVC.h"
#import "HomePageItemCCell.h"
#import "RoleProfileModel.h"
#import "GoodsManageVC.h"
#import "PurchaseTypeChooseVC.h"
#import "PurchaseCounterVC.h"
#import "SelectStoreVC.h"
#import "LoginInfoModel.h"
#import "PurchaseOrderManageVC.h"
#import "InvoiceOrderManageVC.h"
#import "AllocateOrderManageVC.h"
#import "ReturnOrderManageVC.h"
#import "MasterShippingManageVC.h"

#import "StoreStockVC.h"
#import "StockQueryVC.h"
#import "InOrOutWaterVC.h"
#import "CountTypeChooseVC.h"
#import "CheckStockOrderVC.h"
#import "ChangeStockOrderVC.h"

#import "xw_StoreOrderVC.h"
#import "xw_StoreReturnVC.h"
@interface StockManageChildVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation StockManageChildVC

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
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HomePageBannerCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageBannerCCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HomePageItemCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageItemCCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"HomePageSearchCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageSearchCCell"];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView"];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView"];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"库存管理";
    
    
    
    //    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,300,44)];
    //    self.titleLab.backgroundColor = [UIColor clearColor];
    //    self.titleLab.font = FONTLanTingB(17);
    //    self.titleLab.textColor = [UIColor whiteColor];
    //    self.titleLab.textAlignment = NSTextAlignmentCenter;
    //    self.navigationItem.titleView = self.titleLab;
}

- (void)configBaseData
{
    
    NSString* me_Config = @"";
    if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
        me_Config = ME_Store_Owner_StockManageChild;
    }else
    {
        me_Config = ME_Store_Owner_StockManageChild;
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
            StoreStockVC *storeStockVC = [[StoreStockVC alloc] init];
            storeStockVC.hidesBottomBarWhenPushed = YES;
            storeStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockGoods;
            [self.navigationController pushViewController:storeStockVC animated:YES];
        }
            break;
        case 1:
        {
            StockQueryVC *stockQueryVC = [[StockQueryVC alloc] init];
            stockQueryVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockQueryVC animated:YES];
        }
            break;
        case 2:
        {
            InOrOutWaterVC *inOrOutWaterVC = [[InOrOutWaterVC alloc] init];
            inOrOutWaterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:inOrOutWaterVC animated:YES];
        }
            break;
        case 3:
        {
            CountTypeChooseVC *countTypeChooseVC = [[CountTypeChooseVC alloc] init];
            countTypeChooseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:countTypeChooseVC animated:YES];
        }
            break;
        case 4:
        {
            CheckStockOrderVC *checkStockOrderVC = [[CheckStockOrderVC alloc] init];
            checkStockOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:checkStockOrderVC animated:YES];
        }
            break;
        case 5:
        {
            ChangeStockOrderVC *changeStockOrderVC = [[ChangeStockOrderVC alloc] init];
            changeStockOrderVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:changeStockOrderVC animated:YES];
        }
            break;
        case 6:
        {
            StoreStockVC *storeStockVC = [[StoreStockVC alloc] init];
            storeStockVC.hidesBottomBarWhenPushed = YES;
            storeStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockSample;
            [self.navigationController pushViewController:storeStockVC animated:YES];
            break;
        }
        case 7://门店下单
        {
            xw_StoreOrderVC *storeOrderVC = [xw_StoreOrderVC new];
            storeOrderVC.hidesBottomBarWhenPushed = YES;
//            storeOrderVC.controllerType = StockSample;
            [self.navigationController pushViewController:storeOrderVC animated:YES];
            break;
        }
        case 8://门店退货
        {
            xw_StoreReturnVC *storeReturnVC = [xw_StoreReturnVC new];
            storeReturnVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeReturnVC animated:YES];
            break;
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
