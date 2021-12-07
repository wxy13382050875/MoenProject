
//
//  GoodsDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "GoodsDetailVC.h"
#import "GoodsDetailBannerTCell.h"
#import "GoodsDetailInfoTCell.h"
#import "GoodsDetailExtraInfoTCell.h"
#import "GoodsDetailModel.h"
#import "SDPhotoBrowser.h"

@interface GoodsDetailVC ()<UITableViewDelegate, UITableViewDataSource, SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) GoodsDetailModel *goodsModel;

@end

@implementation GoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"商品详情";
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodsDetailBannerTCell" bundle:nil] forCellReuseIdentifier:@"GoodsDetailBannerTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodsDetailInfoTCell" bundle:nil] forCellReuseIdentifier:@"GoodsDetailInfoTCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodsDetailExtraInfoTCell" bundle:nil] forCellReuseIdentifier:@"GoodsDetailExtraInfoTCell"];
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    
}

- (void)configBaseData
{
    [self httpPath_getProductDetail];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_getProductDetail];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.goodsModel.ID == 0) {
        return 0;
    }
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return SCREEN_WIDTH;
    }
    else if(indexPath.section == 1)
    {
        return 115;
    }
    else
    {
        return 56;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GoodsDetailBannerTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailBannerTCell" forIndexPath:indexPath];
        [cell showDataWithArray:self.goodsModel.list];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        GoodsDetailInfoTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailInfoTCell" forIndexPath:indexPath];
        [cell showDataWithGoodsDetailModel:self.goodsModel];
        return cell;
    }
    else
    {
        GoodsDetailExtraInfoTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsDetailExtraInfoTCell" forIndexPath:indexPath];
        NSString *dispayStr = @"";
        if (indexPath.section == 2) {
            dispayStr = [NSString stringWithFormat:@"品类: %@",self.goodsModel.firstCategory];
        }
        if (indexPath.section == 3) {
            dispayStr = [NSString stringWithFormat:@"系列: %@",self.goodsModel.series];
        }
        if (indexPath.section == 4) {
            dispayStr = [NSString stringWithFormat:@"规格: %@",self.goodsModel.specification];
        }
        if (indexPath.section == 5) {
            dispayStr = [NSString stringWithFormat:@"销售单位: %@",self.goodsModel.packUnit];
        }
        if (indexPath.section == 6) {
            dispayStr = [NSString stringWithFormat:@"摩恩PR00售价: ¥%@",self.goodsModel.retailPrice];
        }
        [cell showDataWithString:dispayStr];
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SDPhotoBrowser * broser = [[SDPhotoBrowser alloc] init];
        broser.currentImageIndex = 0;
        broser.isHideSaveBtn = YES;
        broser.imageCount = self.goodsModel.list.count;
        broser.delegate = self;
        [broser show];
    }
}



- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.goodsModel.list[0]];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getProductDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getProductDetail]) {
                GoodsDetailModel *model = (GoodsDetailModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    self.isShowEmptyData = NO;
                    self.goodsModel = model;
                    [self.tableview reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                
            }
        }
    }
}

/**商品详情Api*/
- (void)httpPath_getProductDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.productID) forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_getProductDetail;
}



#pragma  mark -- Getter&Setter

- (GoodsDetailModel *)goodsModel
{
    if (!_goodsModel) {
        _goodsModel = [[GoodsDetailModel alloc] init];
    }
    return _goodsModel;
}
@end
