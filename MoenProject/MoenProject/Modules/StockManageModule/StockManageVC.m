//
//  StockManageVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "StockManageVC.h"
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
#import "StockManageChildVC.h"

@interface StockManageVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation StockManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        me_Config = ME_Store_Owner_StockManage;
    }else
    {
        me_Config = ME_Store_Owner_StockManage;
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
            PurchaseTypeChooseVC *purchaseTypeChooseVC = [[PurchaseTypeChooseVC alloc] init];
            purchaseTypeChooseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:purchaseTypeChooseVC animated:YES];
//            PurchaseCounterVC *purchaseTypeChooseVC = [[PurchaseCounterVC alloc] init];
//            purchaseTypeChooseVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:purchaseTypeChooseVC animated:YES];
        }
            break;
        case 1:
        {
            SelectStoreVC *selectStoreVC = [[SelectStoreVC alloc] init];
            
            selectStoreVC.modalPresentationStyle = 0;
            selectStoreVC.controllerType = ChangeStoreVCTypeDefault;
            selectStoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:selectStoreVC animated:YES];
        }
            break;
        case 2:
        {
            StockManageChildVC *stockManageChildVC = [[StockManageChildVC alloc] init];
            stockManageChildVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockManageChildVC animated:YES];
        }
            break;
        case 3:
        {
            PurchaseOrderManageVC *purchaseOrderManageVC = [[PurchaseOrderManageVC alloc] init];
            purchaseOrderManageVC.hidesBottomBarWhenPushed = YES;
            purchaseOrderManageVC.controllerType =PurchaseOrderManageVCTypeSTOCK;
            [self.navigationController pushViewController:purchaseOrderManageVC animated:YES];
        }
            break;
        case 4:
        {
            InvoiceOrderManageVC *invoiceOrderManageVC = [[InvoiceOrderManageVC alloc] init];
            invoiceOrderManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:invoiceOrderManageVC animated:YES];
        }
            break;
        case 5:
        {
            AllocateOrderManageVC *allocateOrderManageVC = [[AllocateOrderManageVC alloc] init];
            allocateOrderManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:allocateOrderManageVC animated:YES];
        }
            break;
        case 6:
        {
//            ReturnOrderManageVC *returnOrderManageVC = [[ReturnOrderManageVC alloc] init];
//            returnOrderManageVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:returnOrderManageVC animated:YES];
            
            PurchaseOrderManageVC *purchaseOrderManageVC = [[PurchaseOrderManageVC alloc] init];
            purchaseOrderManageVC.hidesBottomBarWhenPushed = YES;
            purchaseOrderManageVC.controllerType =PurchaseOrderManageVCTypeReturn;
            [self.navigationController pushViewController:purchaseOrderManageVC animated:YES];
        }
            break;
            
        case 7:
        {
            MasterShippingManageVC *masterShippingManageVC = [[MasterShippingManageVC alloc] init];
            masterShippingManageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:masterShippingManageVC animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
