//
//  IntentionUnregisterVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "IntentionUnregisterVC.h"
#import "IntentionUnregisterTCell.h"
#import "UnLabelUserInfoModel.h"
#import "IntentionGoodsVC.h"

@interface IntentionUnregisterVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) BOOL isAgainEnter;

@end

@implementation IntentionUnregisterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configBaseUI];
    [self configBaseData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isAgainEnter) {
        [self httpPath_notLabel];
    }
    self.isAgainEnter = YES;
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"未标记";
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    
    [self httpPath_notLabel];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_notLabel];
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
    return 80;
    
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
    IntentionUnregisterTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntentionUnregisterTCell" forIndexPath:indexPath];
    [cell showDataWithUnLabelUserInfoModel:self.dataList[indexPath.section]];
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
    UnLabelUserInfoModel *model = self.dataList[indexPath.section];
    IntentionGoodsVC *intentionGoodsVC = [[IntentionGoodsVC alloc] init];
    intentionGoodsVC.userID = model.customerId;
    intentionGoodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:intentionGoodsVC animated:YES];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_notLabel]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_notLabel]) {
                UnLabelUserListModel *listModel = (UnLabelUserListModel *)parserObject;
                if (listModel.notLabelList.count) {
                    self.isShowEmptyData = NO;
                    [self.dataList removeAllObjects];
                    [self.dataList addObjectsFromArray:listModel.notLabelList];
                    [self.tableview reloadData];
                }
                else
                {
                    self.isShowEmptyData = YES;
//                    [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                    [self.dataList removeAllObjects];
                    [self.tableview reloadData];
                }
            }
        }
    }
}

/**未标注的会员Api*/
- (void)httpPath_notLabel
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_notLabel;
}


#pragma mark -- Getter&Setter
- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"IntentionUnregisterTCell" bundle:nil] forCellReuseIdentifier:@"IntentionUnregisterTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无未标记客户";
    }
    return _tableview;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
@end
