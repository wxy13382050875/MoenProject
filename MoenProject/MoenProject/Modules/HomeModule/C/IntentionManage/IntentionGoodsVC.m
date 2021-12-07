//
//  IntentionGoodsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/10.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "IntentionGoodsVC.h"
#import "CommonSingleGoodsTCell.h"
#import "IntentionGoodsModel.h"
#import "SellGoodsScanVC.h"
#import "FDAlertView.h"


@interface IntentionGoodsVC ()<UITableViewDelegate, UITableViewDataSource, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IntentionGoodsModel *dataModel;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *deleteGoodsID;
@end

@implementation IntentionGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"意向管理";
    
    //设置导航栏
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 42)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setImage:ImageNamed(@"i_scan_icon") forState:UIControlStateNormal];
    [rightButton setImage:ImageNamed(@"i_scan_icon") forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
    
}

- (void)configBaseData
{
    
    [self httpPath_intentProductList];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataModel.intentProductList.count > 0) {
        return self.dataModel.intentProductList.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataModel.intentProductList.count > 0) {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 85;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataModel.intentProductList.count == 0) {
        if (section == 0) {
            return 85;
        }
    }
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsTCell" forIndexPath:indexPath];
    [cell showDataWithIntentionProductModel:self.dataModel.intentProductList[indexPath.section]];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
        headerView.backgroundColor = AppBgWhiteColor;
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        topLine.backgroundColor = AppBgBlueGrayColor;
        [headerView addSubview:topLine];
        if (self.dataModel.remark.length > 0) {
            UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 40)];
            markLab.font = FONTSYS(14);
            markLab.textColor = AppTitleBlackColor;
            if (self.dataModel.remark.length) {
                markLab.text = self.dataModel.remark;
            }
            else
            {
                markLab.text = @"暂无备注";
            }
            [headerView addSubview:markLab];
            
            UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 50, 100, 20)];
            actionBtn.titleLabel.font = FONTSYS(14);
            [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
            [actionBtn setTitle:@"修改备注" forState:UIControlStateNormal];
            [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
            [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
            [headerView addSubview:actionBtn];
        }
        else
        {
            UIButton *actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 50, 5, 100, 75)];
            actionBtn.titleLabel.font = FONTSYS(14);
            [actionBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
            [actionBtn setTitle:@"添加备注" forState:UIControlStateNormal];
            [actionBtn setImage:ImageNamed(@"i_message_icon") forState:UIControlStateNormal];
            [actionBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchDown];
            [headerView addSubview:actionBtn];
        }
        
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 5)];
        bottomLine.backgroundColor = AppBgBlueGrayColor;
        [headerView addSubview:bottomLine];
    }
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    if (self.dataModel.intentProductList.count == 0) {
        if (section == 0) {
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

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)){
    
    WEAKSELF
    if (@available(iOS 11.0, *)) {
        UIContextualAction *deleteAction = [UIContextualAction  contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action,__kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                            {
                                                [tableView setEditing:NO animated:YES];// 这句很重要，退出编辑模式，隐藏左滑菜单
                                                [weakSelf handleDeleteIntentProduce:indexPath.section];
                                                /*这中间为代码删除的具体逻辑实现*/
                                                completionHandler(false);
                                            }];
        UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        actions.performsFirstActionWithFullSwipe = NO;
        return actions;
    }
    else
    {
        return nil;
    }
}

- (void)handleDeleteIntentProduce:(NSInteger)atIndex
{
    IntentionProductModel *model = self.dataModel.intentProductList[atIndex];
    self.deleteGoodsID = model.ID;
    [self ShowDeleteGoodsTips];
//    [self httpPath_deleteIntentProductWithID:model.ID];
}

- (void)ShowDeleteGoodsTips
{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否删除此意向商品" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
    [alert show];
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    //    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (void)modifyAction:(UIButton *)sender
{
//    if (self.dataModel.ID.length == 0) {
//        [[NSToastManager manager] showtoast:@"请先添加意向商品"];
//        return;
//    }
    NSString *tipsStr = @"";
    if (self.remark.length) {
        tipsStr = @"修改备注信息";
    }
    else
    {
        tipsStr = @"添加备注信息";
    }
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:tipsStr alterType:FDAltertViewTypeAddMark message:self.remark delegate:self buttonTitles:@"取消", @"确定", nil];
    [alert show];
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr
{
    if (alertView.alterType == FDAltertViewTypeTips) {
        [self httpPath_deleteIntentProductWithID:self.deleteGoodsID];
    }
    else
    {
        if (inputStr.length && ![self.remark isEqualToString:inputStr]) {
            self.remark = inputStr;
            [self httpPath_updateRemark];
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
        if ([operation.urlTag isEqualToString:Path_intentProductList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_intentProductList]) {
                IntentionGoodsModel *model = (IntentionGoodsModel *)parserObject;
                self.dataModel = model;
                self.remark = model.remark;
                [self.tableview reloadData];
            }
            if ([operation.urlTag isEqualToString:Path_updateRemark]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"成功"];
                    [self httpPath_intentProductList];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
            }
            
            if ([operation.urlTag isEqualToString:Path_deleteIntentProduct]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"删除成功"];
                    [self httpPath_intentProductList];
                }
            }
            
            
            
            
        }
    }
}

/**会员意向商品列表Api*/
- (void)httpPath_intentProductList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
    self.requestURL = Path_intentProductList;
}

/**修改意向备注信息Api*/
- (void)httpPath_updateRemark
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (self.dataModel.ID != nil) {
        [parameters setValue:self.dataModel.ID forKey:@"id"];
    }
    else
    {
        [parameters setValue:self.userID forKey:@"customerId"];
    }
    
    [parameters setValue:self.remark forKey:@"remark"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_updateRemark;
}

/**删除意向商品Api*/
- (void)httpPath_deleteIntentProductWithID:(NSString *)goodsID
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:goodsID forKey:@"id"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_deleteIntentProduct;
}



- (IntentionGoodsModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[IntentionGoodsModel alloc] init];
    }
    return _dataModel;
}

@end
