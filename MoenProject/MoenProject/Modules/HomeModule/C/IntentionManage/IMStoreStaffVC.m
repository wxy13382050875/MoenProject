//
//  IMStoreStaffVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "IMStoreStaffVC.h"
#import "ShopPersonalModel.h"
#import "SamplingInputTCell.h"
#import "IMSellerManageVC.h"
#import "IntentionManageVC.h"

@interface IMStoreStaffVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) BOOL isAgainEnter;
@end

@implementation IMStoreStaffVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAgainEnter) {
        [self httpPath_shopPersonal];
    }
    self.isAgainEnter = YES;
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"store_staff", nil);
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"SamplingInputTCell" bundle:nil] forCellReuseIdentifier:@"SamplingInputTCell"];
}

- (void)configBaseData
{
    [self httpPath_shopPersonal];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_shopPersonal];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SamplingInputTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SamplingInputTCell" forIndexPath:indexPath];
    cell.cellType = SamplingInputTCellForStoreStaff;
    [cell showDataWithShopPersonalModel:self.dataList[indexPath.section]];
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
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopPersonalModel *model = self.dataList[indexPath.section];
    IntentionManageVC *intentionManageVC = [[IntentionManageVC alloc] init];
    intentionManageVC.personalId = model.ID;
    intentionManageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:intentionManageVC animated:YES];
    
    //    IMSellerManageVC
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_shopPersonal]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_shopPersonal]) {
                
                ShopPersonalListModel *listModel = (ShopPersonalListModel *)parserObject;
                if (listModel.shopPersonalList.count) {
                    self.isShowEmptyData = NO;
                    [self.dataList removeAllObjects];
                    [self.dataList addObjectsFromArray:listModel.shopPersonalList];
                    [self.tableview reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
//                    [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                }
            }
        }
    }
}

/**门店员工（店长）Api*/
- (void)httpPath_shopPersonal
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_shopPersonal;
}


- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

@end
