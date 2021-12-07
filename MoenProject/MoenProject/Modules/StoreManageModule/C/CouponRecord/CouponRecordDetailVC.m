//
//  CouponRecordDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CouponRecordDetailVC.h"
#import "CouponRecordDetailTCell.h"
#import "CouponRecordDetailModel.h"

@interface CouponRecordDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) CouponRecordDetailListModel *dataModel;

@end

@implementation CouponRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}


- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"ccoupon_reocrd", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无优惠券使用信息";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"CouponRecordDetailTCell" bundle:nil] forCellReuseIdentifier:@"CouponRecordDetailTCell"];
}

- (void)configBaseData
{
    [self httpPath_couponUsageRecord];
    
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_couponUsageRecord];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataModel.couponUsageRecordDetail.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponRecordDetailTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponRecordDetailTCell" forIndexPath:indexPath];
    [cell showDataWithCouponRecordDetailModel:self.dataModel.couponUsageRecordDetail[indexPath.section]];
    return cell;
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


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_couponUsageRecord]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_couponUsageRecord]) {
                
                CouponRecordDetailListModel *listModel = (CouponRecordDetailListModel *)parserObject;
                self.dataModel = listModel;
                [self.tableview reloadData];
                if (listModel.couponUsageRecordDetail.count > 0) {
                    self.isShowEmptyData = NO;
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                
            }
        }
    }
}

/**优惠券使用记录详情Api*/
- (void)httpPath_couponUsageRecord
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.registerDate forKey:@"registerDate"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_couponUsageRecord;
}


#pragma Getter&&Setter
- (CouponRecordDetailListModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[CouponRecordDetailListModel alloc] init];
    }
    return _dataModel;
}

@end
