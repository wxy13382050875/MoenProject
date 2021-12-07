//
//  patrolStoreCheckDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/7.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PatrolStoreCheckDetailVC.h"
#import "PatrolStoreCheckResultTcell.h"
#import "CheckedUnqualifiedVC.h"
#import "PatrolShopDetailModel.h"

@interface PatrolStoreCheckDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) PatrolShopDetailListModel *dataModel;
@end

@implementation PatrolStoreCheckDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"巡店结果";
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = AppBgBlueGrayColor;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    self.noDataDes = @"暂无巡店信息";
    
    [self.tableview registerNib:[UINib nibWithNibName:@"PatrolStoreCheckResultTcell" bundle:nil] forCellReuseIdentifier:@"PatrolStoreCheckResultTcell"];
}

- (void)configBaseData
{
    [self httpPath_patrolShopDetail];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_patrolShopDetail];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.patrolShopDetail.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolShopDetailModel *model = self.dataModel.patrolShopDetail[indexPath.row];
    return model.itemCellHeight;;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataModel.remarks.length) {
        return 56;
    }
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolStoreCheckResultTcell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolStoreCheckResultTcell" forIndexPath:indexPath];
    [cell showDataWithPatrolShopDetailModel:self.dataModel.patrolShopDetail[indexPath.row]];
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
    if (self.dataModel.remarks.length) {
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        footerView.backgroundColor = AppBgWhiteColor;
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 36)];
        titleLab.font = FONTSYS(14);
        titleLab.textColor = AppTitleBlackColor;
        titleLab.text = [NSString stringWithFormat:@"总结说明:  %@",self.dataModel.remarks];
        [footerView addSubview:titleLab];
    }
    return footerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolShopDetailModel *model = self.dataModel.patrolShopDetail[indexPath.row];
    if ([model.questionStatus.ID isEqualToString:@"NO_QUALIFIED"]) {
        CheckedUnqualifiedVC *checkedUnqualifiedVC = [[CheckedUnqualifiedVC alloc] init];
        checkedUnqualifiedVC.questionId = model.questionId;
        checkedUnqualifiedVC.patrolShopId = model.patrolShopId;
        [self.navigationController pushViewController:checkedUnqualifiedVC animated:YES];
    }
    
    
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_patrolShopDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_patrolShopDetail]) {
                PatrolShopDetailListModel *listModel = (PatrolShopDetailListModel *)parserObject;
                if (listModel.patrolShopDetail.count) {
                    self.isShowEmptyData = NO;
                }
                else
                {
                    self.isShowEmptyData = YES;
                }
                self.dataModel = listModel;
                [self.tableview reloadData];
            }
        }
    }
}

/**巡店详情Api*/
- (void)httpPath_patrolShopDetail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.patrolShopId) forKey:@"patrolShopId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_patrolShopDetail;
}



#pragma mark -- Getter&Setter
- (PatrolShopDetailListModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[PatrolShopDetailListModel alloc] init];
    }
    return _dataModel;
}
@end
