//
//  StatisticsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/27.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StatisticsVC.h"
#import "RoleProfileModel.h"
#import "HomePageItemCCell.h"
#import "CurrentDayStatisticsCCell.h"
#import "StoreCustomerDetailVC.h"

#import "GoodsSalesVolumeVC.h"
#import "StoreSalesVolumeVC.h"
#import "PackageRankVC.h"
#import "GoodsCategoryRankVC.h"
#import "StatisticsModel.h"
#import "StoreSalesPersonalVC.h"



@interface StatisticsVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;

@property (nonatomic, strong)NSMutableArray *roleProfileArr;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation StatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
    [self configBaseUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.titleLab.text = [QZLUserConfig sharedInstance].shopName;
    if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
        [self httpPath_firstPage];
    }
}

- (void)configBaseUI
{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageBannerCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageBannerCCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageItemCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageItemCCell"];
    [self.collectionview registerNib:[UINib nibWithNibName:@"HomePageSearchCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageSearchCCell"];
    
    [self.collectionview registerNib:[UINib nibWithNibName:@"CurrentDayStatisticsCCell" bundle:nil] forCellWithReuseIdentifier:@"CurrentDayStatisticsCCell"];
    
    
    
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
        me_Config = ME_Store_Owner_Statistics;
//        [self httpPath_firstPage];
    }else
    {
        me_Config = ME_Store_Guide_Statistics;
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
        return self.roleProfileArr.count;
    }
    else
    {
        return self.floorsAarr.count;
    }
    
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
    StatisticsTVModel *model = self.floorsAarr[indexPath.row];
    return CGSizeMake(SCREEN_WIDTH, model.cellHeight);
}

//定义collection 头部和底部的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return CGSizeZero;
    }
    if (self.floorsAarr.count) {
        return CGSizeMake(SCREEN_WIDTH, 47);
    }
    return CGSizeZero;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeMake(SCREEN_WIDTH, 5);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HomePageItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCCell" forIndexPath:indexPath];
        [cell showDataWithRoleProfileModel:self.roleProfileArr[indexPath.row]];
        return cell;
    }
    else
    {
        CurrentDayStatisticsCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CurrentDayStatisticsCCell" forIndexPath:indexPath];
        [cell showDataWithStatisticsTVModel:self.floorsAarr[indexPath.row]];
        return cell;
    }
    

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    NSInteger section = indexPath.section;
    if (kind == UICollectionElementKindSectionHeader) {
        if (section == 1 &&
            self.floorsAarr.count) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionHeaderEmptyView" forIndexPath:indexPath];
            reusableview.backgroundColor = AppBgWhiteColor;
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 45)];
            titleLab.text = @"当日门店经营总览";
            titleLab.font = FONTSYS(14);
            titleLab.textColor = AppTitleBlackColor;
            [reusableview addSubview:titleLab];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 2)];
            lineView.backgroundColor = AppBgBlueGrayColor;
            [reusableview addSubview:lineView];
            
        }
    }
    
    if (kind == UICollectionElementKindSectionFooter){
//        if (section == 1) {
            reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionFooterEmptyView" forIndexPath:indexPath];
            reusableview.backgroundColor = AppBgBlueGrayColor;
//        }
        
    }
    return reusableview;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RoleProfileModel * model = self.roleProfileArr[indexPath.row];
        switch (model.skipid) {
            case 0:
            {
                if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]) {
                    StoreSalesVolumeVC *storeSalesVolumeVC = [[StoreSalesVolumeVC alloc] init];
                    storeSalesVolumeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:storeSalesVolumeVC animated:YES];
                }else
                {
                    StoreSalesPersonalVC *storeSalesPersonalVC = [[StoreSalesPersonalVC alloc] init];
                    storeSalesPersonalVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:storeSalesPersonalVC animated:YES];
                }
                
            }
                break;
            case 1:
            {
                
                GoodsSalesVolumeVC *goodsSalesVolumeVC = [[GoodsSalesVolumeVC alloc] init];
                if ([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_SELLER"]) {
                    goodsSalesVolumeVC.controllerType = GoodsSalesVolumeVCTypeSeller;
                }
                else
                {
                    goodsSalesVolumeVC.controllerType = GoodsSalesVolumeVCTypeLeader;
                }
                goodsSalesVolumeVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodsSalesVolumeVC animated:YES];
            }
                break;
            case 2:
            {
                PackageRankVC *packageRankVC = [[PackageRankVC alloc] init];
                packageRankVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:packageRankVC animated:YES];
            }
                break;
            case 3:
            {
                GoodsCategoryRankVC *goodsCategoryRankVC = [[GoodsCategoryRankVC alloc] init];
                goodsCategoryRankVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodsCategoryRankVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        StatisticsTVModel * model = self.floorsAarr[indexPath.row];
        if ([model.type isEqualToString:@"shop"]) {
            StoreSalesVolumeVC *storeSalesVolumeVC = [[StoreSalesVolumeVC alloc] init];
            storeSalesVolumeVC.isTheBest = YES;
            storeSalesVolumeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:storeSalesVolumeVC animated:YES];
        }
        else if ([model.type isEqualToString:@"meal"])
        {
            PackageRankVC *packageRankVC = [[PackageRankVC alloc] init];
            packageRankVC.isTheBest = YES;
            packageRankVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:packageRankVC animated:YES];
        }
        else if ([model.type isEqualToString:@"category"])
        {
            GoodsCategoryRankVC *goodsCategoryRankVC = [[GoodsCategoryRankVC alloc] init];
            goodsCategoryRankVC.isTheBest = YES;
            goodsCategoryRankVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsCategoryRankVC animated:YES];
        }
        else if ([model.type isEqualToString:@"product"])
        {
            GoodsSalesVolumeVC *goodsSalesVolumeVC = [[GoodsSalesVolumeVC alloc] init];
            goodsSalesVolumeVC.controllerType = GoodsSalesVolumeVCTypeIsTheBest;
            goodsSalesVolumeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsSalesVolumeVC animated:YES];
        }
        else if ([model.type isEqualToString:@"reigst"])
        {
            StoreCustomerDetailVC *storeCustomerDetailVC = [[StoreCustomerDetailVC alloc] init];
            storeCustomerDetailVC.hidesBottomBarWhenPushed = YES;
            storeCustomerDetailVC.isTheBest = YES;
            [self.navigationController pushViewController:storeCustomerDetailVC animated:YES];
        }
    }
    
}


#pragma  mark -- 配置楼层信息
- (void)handleCollectionViewFloorsDataWithStatisticsModel:(StatisticsModel *)model
{
    [self.floorsAarr removeAllObjects];
    StatisticsTVModel *firstModel = [[StatisticsTVModel alloc] init];
    firstModel.title = @"今日门店销售额";
    firstModel.image = @"s_store_sales_icon";
    firstModel.value = model.shopCount;
    if (model.saleRemind.length) {
        firstModel.content = model.saleRemind;
        firstModel.contentColor = AppTitleGoldenColor;
        firstModel.cellHeight = 67;
    }
    else
    {
        firstModel.cellHeight = 56;
    }
    
    firstModel.type = @"shop";
    [self.floorsAarr addObject:firstModel];
    
    StatisticsTVModel *secondModel = [[StatisticsTVModel alloc] init];
    secondModel.title = @"今日套餐销售最佳";
    secondModel.image = @"s_package_sales_icon";
    secondModel.content = model.setMealInfo;
    secondModel.value = model.setMealName;
    secondModel.cellHeight = 67;
    secondModel.type = @"meal";
    [self.floorsAarr addObject:secondModel];
    
    
    StatisticsTVModel *thirdModel = [[StatisticsTVModel alloc] init];
    thirdModel.title = @"今日品类销售最佳";
    thirdModel.image = @"s_type_sales_icon";
    thirdModel.value = model.categoryName;
    thirdModel.cellHeight = 56;
    thirdModel.type = @"category";
    [self.floorsAarr addObject:thirdModel];
    
    
    StatisticsTVModel *forthModel = [[StatisticsTVModel alloc] init];
    forthModel.title = @"今日单品销售最佳";
    forthModel.image = @"s_single_sales_icon";
    forthModel.content = model.productName;
    forthModel.value = model.productSku;
    forthModel.cellHeight = 67;
    forthModel.type = @"product";
    [self.floorsAarr addObject:forthModel];
    
    
    StatisticsTVModel *fifthModel = [[StatisticsTVModel alloc] init];
    fifthModel.title = @"今日客户注册数";
    fifthModel.image = @"s_register_number_icon";
    fifthModel.content = @"通过门店POS和扫描门店二维码注册的普通客户数量";
    fifthModel.value = model.customerCount;
    fifthModel.cellHeight = 67;
    fifthModel.type = @"reigst";
    [self.floorsAarr addObject:fifthModel];
    
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_firstPage]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_firstPage]) {
                StatisticsModel *model = (StatisticsModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [self handleCollectionViewFloorsDataWithStatisticsModel:model];
                    [self.collectionview reloadData];
                }
                
            }
        }
    }
}

/**首页统计Api*/
- (void)httpPath_firstPage
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_firstPage;
}


#pragma mark- getters and setters
- (NSMutableArray *)roleProfileArr
{
    if (!_roleProfileArr) {
        _roleProfileArr = [[NSMutableArray alloc] init];
    }
    return _roleProfileArr;
}

- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}

@end
