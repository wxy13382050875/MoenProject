//
//  MemberIntentionVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/11.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "MemberIntentionVC.h"
#import "IntentionGoodsModel.h"
#import "SellGoodsScanVC.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "FDAlertView.h"

@interface MemberIntentionVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, assign) NSInteger actionAtIndex;

@property (nonatomic, assign) BOOL isShowNoDataTips;

@property (nonatomic, copy) NSString *deleteGoodsID;
@end

@implementation MemberIntentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    self.actionAtIndex = -1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"intent_manage", nil);
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setImage:ImageNamed(@"i_scan_icon") forState:UIControlStateNormal];
    [rightButton setImage:ImageNamed(@"i_scan_icon") forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
    self.comScrollerView = self.tableview;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
    
}

- (void)configBaseData
{
    [self httpPath_shopCustomerIntent];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf httpPath_shopCustomerIntent];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataArr.count == 0) {
        return 1;
    }
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) {
        return 0;
    }
    IntentionGoodsModel *model = self.dataArr[section];
    return model.productList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) {
        return 65;
    }
    IntentionGoodsModel *model = self.dataArr[section];
    if ([model.ID isEqualToString:[QZLUserConfig sharedInstance].employeeId]) {
        if (model.isSimulation) {
            return 60;
        }
        else
        {
            if (model.remark.length) {
                return 110;
            }
        }
        return 90;
    }
    else
    {
        if (model.remark.length) {
            return 90;
        }
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //判断接口是否返回意向商品 遍历数组
    NSInteger arrCount = 0;
    for (IntentionGoodsModel *model in self.dataArr) {
        if (model.productList.count) {
            arrCount = 1;
            break;
        }
    }
    if (arrCount == 0) {
        if (self.dataArr.count == 0) {
            self.isShowNoDataTips = YES;
            return 85;
        }
        if (section == self.dataArr.count - 1) {
            self.isShowNoDataTips = YES;
            return 85;
        }
    }
    else
    {
        self.isShowNoDataTips = NO;
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
    IntentionGoodsModel *model = self.dataArr[indexPath.section];
    [cell showDataWithIntentionProductModel:model.productList[indexPath.row]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] init];
    if (self.dataArr.count == 0) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
        headerView.backgroundColor = AppBgWhiteColor;
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        topLine.backgroundColor = AppBgBlueGrayColor;
        [headerView addSubview:topLine];
        
        UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 5, 100, 60)];
        actionBtn.titleLabel.font = FONTLanTingR(14);
        [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
        [actionBtn setTitle:NSLocalizedString(@"add_notes", nil) forState:UIControlStateNormal];
        [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
        actionBtn.tag = 13000 + section;
        [headerView addSubview:actionBtn];
        
    }
    else
    {
        headerView.backgroundColor = AppBgWhiteColor;
        IntentionGoodsModel *model = self.dataArr[section];
        
        if ([model.ID isEqualToString:[QZLUserConfig sharedInstance].employeeId]) {
            if (model.isSimulation) {
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
                
                UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
                topLine.backgroundColor = AppBgBlueGrayColor;
                [headerView addSubview:topLine];
                
                UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 5, 100, 60)];
                actionBtn.titleLabel.font = FONTLanTingR(14);
                [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                [actionBtn setTitle:NSLocalizedString(@"add_notes", nil) forState:UIControlStateNormal];
                [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
                [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
                actionBtn.tag = 13000 + section;
                [headerView addSubview:actionBtn];
            }
            else
            {
                UILabel *businessLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
                businessLab.font = FONTLanTingR(14);
                businessLab.textColor = AppTitleBlackColor;
                businessLab.backgroundColor = AppBgBlueColor;
                businessLab.text = [NSString stringWithFormat:@"    %@ (%@)",model.name, model.businessRole];
                [headerView addSubview:businessLab];
                
                if (model.remark.length) {
                    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
                    UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 40)];
                    markLab.font = FONTLanTingR(14);
                    markLab.textColor = AppTitleBlackColor;
                    markLab.text = model.remark;
                    [headerView addSubview:markLab];
                    
                    UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 85, 100, 20)];
                    actionBtn.titleLabel.font = FONTLanTingR(14);
                    [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                    [actionBtn setTitle:NSLocalizedString(@"modify_notes", nil) forState:UIControlStateNormal];
                    [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
                    [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
                    actionBtn.tag = 13000 + section;
                    [headerView addSubview:actionBtn];
                }
                else
                {
                    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
                    
                    UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 40, 100, 50)];
                    actionBtn.titleLabel.font = FONTLanTingR(14);
                    [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
                    [actionBtn setTitle:NSLocalizedString(@"add_notes", nil) forState:UIControlStateNormal];
                    [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
                    [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
                    actionBtn.tag = 13000 + section;
                    [headerView addSubview:actionBtn];
                }
            }
        }
        else
        {
            UILabel *businessLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            businessLab.font = FONTLanTingR(14);
            businessLab.textColor = AppTitleBlackColor;
            businessLab.backgroundColor = AppBgBlueColor;
            businessLab.text = [NSString stringWithFormat:@"    %@ (%@)",model.name, model.businessRole];
            [headerView addSubview:businessLab];
            
            if (model.remark.length) {
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
                UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 40)];
                markLab.font = FONTLanTingR(14);
                markLab.textColor = AppTitleBlackColor;
                markLab.text = model.remark;
                [headerView addSubview:markLab];
            }
            else
            {
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            }
        }
    }
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (self.isShowNoDataTips) {
        if (self.dataArr.count == 0) {
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
            footerView.backgroundColor = UIColor.clearColor;
            UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 40)];
            markLab.font = FontBinR(15);
            markLab.textAlignment = NSTextAlignmentCenter;
            markLab.textColor = AppTitleBlackColor;
            markLab.text = @"暂无意向商品信息";
            [footerView addSubview:markLab];
        }
        if (section == self.dataArr.count - 1) {
            footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
            footerView.backgroundColor = UIColor.clearColor;
            UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, SCREEN_WIDTH - 30, 40)];
            markLab.font = FontBinR(15);
            markLab.textAlignment = NSTextAlignmentCenter;
            markLab.textColor = AppTitleBlackColor;
            markLab.text = @"暂无意向商品信息";
            [footerView addSubview:markLab];
        }
    }
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    //    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    IntentionGoodsModel *model = self.dataArr[indexPath.section];
    if ([model.ID isEqualToString:[QZLUserConfig sharedInstance].employeeId]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    
    WEAKSELF
    if (@available(iOS 11.0, *)) {
            UIContextualAction *deleteAction = [UIContextualAction  contextualActionWithStyle:UIContextualActionStyleDestructive title:NSLocalizedString(@"c_delete", nil) handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                                {
                                                    [tableView setEditing:NO animated:NO];// 这句很重要，退出编辑模式，隐藏左滑菜单
                                                    [weakSelf handleGoodsDeleteActionWithAtIndex:indexPath];
                                                    /*这中间为代码删除的具体逻辑实现*/
                                                    completionHandler(false);
                                                }];
            UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
            actions.performsFirstActionWithFullSwipe = NO;
            return actions;

        return nil;
    }
    else
    {
        return nil;
    }
}

- (void)handleGoodsDeleteActionWithAtIndex:(NSIndexPath *)atIndexPath
{
    
    IntentionGoodsModel *model = self.dataArr[atIndexPath.section];
    IntentionProductModel *goodsModel = model.productList[atIndexPath.row];
    self.deleteGoodsID = goodsModel.ID;
    [self ShowDeleteGoodsTips];
//    [self httpPath_deleteIntentProduct:goodsModel.ID];
}


- (void)ShowDeleteGoodsTips
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否删除此意向商品" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}


- (void)modifyAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 13000;
    self.actionAtIndex = atIndex;
    NSString *message = @"";
    NSString *tipsStr = @"";
    if (self.dataArr.count != 0) {
        IntentionGoodsModel *model = self.dataArr[atIndex];
        message = model.remark;
    }
    if (message.length > 0) {
        tipsStr = @"修改备注信息";
    }
    else
    {
        tipsStr = @"添加备注信息";
    }
    
    
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:tipsStr alterType:FDAltertViewTypeAddMark message:message delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr
{
    if (buttonIndex == 1) {
        if (alertView.alterType == FDAltertViewTypeTips) {
            [self httpPath_deleteIntentProduct:self.deleteGoodsID];
        }
        else
        {
            if (inputStr.length == 0) {
                [[NSToastManager manager] showtoast:@"输入内容为空"];
            }
            else
            {
                NSInteger intentID = 0;
                if (self.dataArr.count == 0) {
                    [self httpPath_updateRemark:intentID WithRemark:inputStr];
                }
                else
                {
                    IntentionGoodsModel *model = self.dataArr[self.actionAtIndex];
                    if (model.isSimulation) {
                        [self httpPath_updateRemark:intentID WithRemark:inputStr];
                    }
                    else
                    {
                        [self httpPath_updateRemark:model.intentId WithRemark:inputStr];
                    }
                    
                }
                
            }
        }
        
    }
}

- (void)addAction:(UIButton *)sender
{
    SellGoodsScanVC *sellGoodsScanVC = [[SellGoodsScanVC alloc] init];
    sellGoodsScanVC.customerId = self.userID;
    sellGoodsScanVC.controllerType = SellGoodsScanVCIntention;
    sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_shopCustomerIntent]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_shopCustomerIntent]) {
                IntentionListModel *model = (IntentionListModel *)parserObject;
                [self.dataArr removeAllObjects];
                BOOL isHaveSelf = false;
                for (IntentionGoodsModel *itemModel in model.intentInfoList) {
                    if ([itemModel.ID isEqualToString:[QZLUserConfig sharedInstance].employeeId]) {
                        isHaveSelf = true;
                        break;
                    }
                }
                if (isHaveSelf == false) {
                    IntentionGoodsModel *intentModel = [[IntentionGoodsModel alloc] init];
                    intentModel.ID = [QZLUserConfig sharedInstance].employeeId;
                    intentModel.isSimulation = YES;
//                    intentModel.name = [QZLUserConfig sharedInstance].employeeId;
//                    intentModel.businessRole = [QZLUserConfig sharedInstance].employeeId;
                    [self.dataArr addObject:intentModel];
                }
                [self.dataArr addObjectsFromArray:model.intentInfoList];
                [self.tableview reloadData];
            }
        }
        
        if ([operation.urlTag isEqualToString:Path_updateRemark]) {
            MoenBaseModel *model = (MoenBaseModel *)parserObject;
            if ([model.code isEqualToString:@"200"]) {
                if (self.dataArr.count == 0) {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"add_notes_success", nil)];
                }
                else
                {
                    [[NSToastManager manager] showtoast:NSLocalizedString(@"modify_success", nil)];
                }
                
                [self httpPath_shopCustomerIntent];
            }
            else
            {
                [[NSToastManager manager] showtoast:model.message];
            }
        }
        if ([operation.urlTag isEqualToString:Path_deleteIntentProduct]) {
            MoenBaseModel *model = (MoenBaseModel *)parserObject;
            if ([model.code isEqualToString:@"200"]) {
                [[NSToastManager manager] showtoast:NSLocalizedString(@"delete_success", nil)];
                [self httpPath_shopCustomerIntent];
            }
        }
    }
}

/**会员意向----会员识别之后Api*/
- (void)httpPath_shopCustomerIntent
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userID forKey:@"customerId"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_shopCustomerIntent;
}


/**修改意向备注信息Api*/
- (void)httpPath_updateRemark:(NSInteger)ID WithRemark:(NSString *)remark
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (ID == 0) {
        [parameters setValue:self.userID forKey:@"customerId"];
    }
    else
    {
        [parameters setValue:@(ID) forKey:@"id"];
    }
    [parameters setValue:remark forKey:@"remark"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_updateRemark;
}

/**删除意向商品Api*/
- (void)httpPath_deleteIntentProduct:(NSString *)ID
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:ID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_deleteIntentProduct;
}


- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
