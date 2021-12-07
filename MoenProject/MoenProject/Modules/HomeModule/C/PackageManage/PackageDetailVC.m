//
//  PackageDetailVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/21.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PackageDetailVC.h"
#import "PackageDetailInfoTCell.h"
#import "OrderPromotionTCell.h"
#import "CommonSingleGoodsTCell.h"
#import "PackageDetailModel.h"

@interface PackageDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) PackageDetailModel *dataModel;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation PackageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"package_detail", nil);
    
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [self httpPath_getComboInfo];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_getComboInfo];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataModel.comId != 0) {
        return 3;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return self.dataModel.list.count;
    }
    else
    {
        return self.dataModel.productList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([NSTool getHeightWithContent:self.dataModel.comboName width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:3] > 20 ||
            [NSTool getHeightWithContent:self.dataModel.comboDescribe width:SCREEN_WIDTH - 30 font:FONTSYS(14) lineOffset:3] > 20) {
            return 123;
        }
        return 103;
    }
    else if(indexPath.section == 1)
    {
        return 40;
    }
    else
    {
        return 115;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PackageDetailInfoTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PackageDetailInfoTCell" forIndexPath:indexPath];
        [cell showDataWithPackageDetailModel:self.dataModel];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        OrderPromotionTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPromotionTCell" forIndexPath:indexPath];
        [cell showDataWithPromotionInfoModel:self.dataModel.list[indexPath.row]];
        return cell;
    }
    else
    {
        CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
        [cell showDataWithGoodsDetailModel:self.dataModel.productList[indexPath.row] WithCellType:CommonSingleGoodsTCellTypePackageDetail];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 1) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        headerView.backgroundColor = AppBgWhiteColor;
    }
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    return footerView;
}
#pragma mark -- UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getComboInfo]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getComboInfo]) {
                PackageDetailModel *model = (PackageDetailModel *)parserObject;
                self.dataModel = model;
                [self.tableview reloadData];
            }
        }
    }
}

/**套餐详情Api*/
- (void)httpPath_getComboInfo
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.packageID) forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_getComboInfo;
}

#pragma mark -- Getter&Setter

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        
        [_tableview registerNib:[UINib nibWithNibName:@"OrderPromotionTCell" bundle:nil] forCellReuseIdentifier:@"OrderPromotionTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"PackageDetailInfoTCell" bundle:nil] forCellReuseIdentifier:@"PackageDetailInfoTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        
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
