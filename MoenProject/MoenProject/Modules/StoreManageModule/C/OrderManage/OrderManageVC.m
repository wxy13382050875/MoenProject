//
//  OrderManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "OrderManageVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderManageModel.h"
#import "OrderListTCell.h"
#import "OrderDetailVC.h"
#import "CommonCategoryModel.h"
#import "OrderScreenSideslipView.h"
#import "xw_SelectDeliveryWayVC.h"
#import "XwSubscribeTakeVC.h"
@interface OrderManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) OrderScreenSideslipView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, strong) NSMutableArray *selectDataArr;

@property (nonatomic, copy) NSString *selectedTimeType;

@property (nonatomic, copy) NSString *dataStart;

@property (nonatomic, copy) NSString *dataEnd;

@end

@implementation OrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"order_list", nil);
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
    [self httpPath_load];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_orderList];
    [weakSelf httpPath_load];
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
    return 115;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    OrderManageModel *model = self.dataList[section];
    if([QZLUserConfig sharedInstance].useInventory){
        if([model.orderStatus isEqualToString:@"waitDeliver"]||
           [model.orderStatus isEqualToString:@"partDeliver"]||
           [model.orderStatus isEqualToString:@"allDeliver"]){
            return 85;
        } else if([model.orderStatus isEqualToString:@"allDeliver"]){
            return 45;
        }
    }
    
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderManageModel *model = self.dataList[indexPath.section];
    if (model.orderItemInfos.count > 1) {
        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
        [cell showDataWithOrderManageModel:model];
        return cell;
    }
    else
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        [cell showDataWithOrderManageModel:model];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderManageModel *model = self.dataList[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    UILabel *timeLab = [UILabel new];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.createDate;;
    [headerView addSubview:timeLab];
    timeLab.sd_layout.leftSpaceToView(headerView, 15).topEqualToView(headerView).widthIs(200).heightIs(40);
    
    UILabel *statueLab = [UILabel new];
    statueLab.font = FontBinB(14);
    statueLab.textColor = AppTitleBlackColor;
    statueLab.text = [self getOrderStatus:model.orderStatus];
    statueLab.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:statueLab];
    statueLab.sd_layout.rightSpaceToView(headerView, 15).topEqualToView(headerView).leftSpaceToView(timeLab, 0).heightIs(40);
    
    UILabel *orderLab = [UILabel new];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    
//    orderLab.text = [NSString stringWithFormat:@"订单编号: %@",model.orderCode];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@",model.orderCode]];
    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6, str.length - 6)];
    orderLab.attributedText = str;
    [headerView addSubview:orderLab];
    
    
    
    orderLab.sd_layout.rightSpaceToView(headerView, 15).topSpaceToView(timeLab, 0).leftSpaceToView(headerView, 15).heightIs(40);
    
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    OrderManageModel *model = self.dataList[section];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = AppBgWhiteColor;
    
    if (self.controllerType == OrderManageVCTypeMAJOR ||
        self.controllerType == OrderManageVCTypeGROOM) {
        UILabel *userLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)];
        userLab.font = FONTLanTingR(14);
        userLab.textColor = AppTitleBlackColor;
        userLab.textAlignment = NSTextAlignmentLeft;
        userLab.text = model.recommender;
        [footerView addSubview:userLab];
    }
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)];
    infoLab.font = FONTLanTingR(14);
    infoLab.textColor = AppTitleBlackColor;
    infoLab.textAlignment = NSTextAlignmentRight;
    
    
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%@",model.giftNum];
    NSString *productNumCountStr = [NSString stringWithFormat:@"%@",model.productNum];
    if (model.giftNum > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品, %@件赠品  实付款:￥%@",model.productNum,giftGoodsCountStr, model.payAmount]];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.productNum].length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.productNum].length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];

        
        infoLab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品 实付款:￥%@",model.productNum, model.payAmount]];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.productNum].length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%@",model.productNum].length)];
        
           [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
           [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
           infoLab.attributedText = str;
    }

    
    [footerView addSubview:infoLab];
    
    if([QZLUserConfig sharedInstance].useInventory){
       
//        waitDeliver partDeliver allDeliver
        UIButton *againBtn =[UIButton buttonWithTitie:@"再来一单" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            [self buttonClick:0 orderID:model.ID];
        }];
        ViewRadius(againBtn, 5)
        UIButton *pickBtn =[UIButton buttonWithTitie:@"预约自提" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            [self buttonClick:2 orderID:model.ID];
        }];
        ViewRadius(pickBtn, 5)
        UIButton *updateBtn =[UIButton buttonWithTitie:@"更新发货" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            [self buttonClick:1 orderID:model.ID];
        }];
        ViewRadius(updateBtn, 5)
        if([model.orderStatus isEqualToString:@"waitDeliver"]||
           [model.orderStatus isEqualToString:@"partDeliver"]){
            [footerView addSubview:againBtn];
            [footerView addSubview:pickBtn];
            [footerView addSubview:updateBtn];
            updateBtn.sd_layout.rightSpaceToView(footerView, 15).bottomSpaceToView(footerView, 10).widthIs(90).heightIs(30);
            pickBtn.sd_layout.rightSpaceToView(updateBtn, 15).bottomSpaceToView(footerView, 10).widthIs(90).heightIs(30);
            againBtn.sd_layout.rightSpaceToView(pickBtn, 15).bottomSpaceToView(footerView, 10).widthIs(90).heightIs(30);
        } else if([model.orderStatus isEqualToString:@"allDeliver"]){
            [footerView addSubview:againBtn];
            againBtn.sd_layout.rightSpaceToView(footerView, 15).bottomSpaceToView(footerView, 10).widthIs(90).heightIs(30);
        }
    }
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    lineView.sd_layout.leftEqualToView(footerView).rightEqualToView(footerView).bottomEqualToView(footerView).heightIs(5);
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderManageModel *model = self.dataList[indexPath.section];
    OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
    orderDetailVC.orderID = model.ID;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.orderCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
}

- (void)selectedTimeAction
{
    [self showConditionSelectView];
}

- (void)showConditionSelectView
{
    WEAKSELF
    [self.conditionSelectView showWithArray:self.selectDataArr WithActionBlock:^(XwScreenModel *model, NSInteger type) {
        //
                weakSelf.dataStart = model.dateStart;
                weakSelf.dataEnd = model.dateEnd;
                for (XWSelectModel* tm in model.selectList) {
                    if([tm.module isEqualToString:@"TimeQuantum"]){
                        weakSelf.selectedTimeType = tm.selectID;
                    }
                }
                [[NSToastManager manager] showprogress];
        [weakSelf httpPath_orderList];
    }];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [weakSelf.tableview cancelRefreshAction];
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_orderList]) {
                OrderManageListModel *listModel = (OrderManageListModel *)parserObject;
                if (listModel.orderList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.orderList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            }
            if ([operation.urlTag isEqualToString:Path_load]) {
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"TimeQuantum"]) {
                        [self.selectDataArr removeAllObjects];
                        
                        for (CommonCategoryDataModel *model in itemModel.datas) {
                            KWOSSVDataModel *itemModel = [[KWOSSVDataModel alloc] init];
                            if ([model.ID isEqualToString:@"ALL"]) {
                                itemModel.isSelected = YES;
                            }
                            itemModel.title = model.des;
                            itemModel.itemId = model.ID;
                            [self.selectDataArr addObject:itemModel];
                        }
                    }
                }
            }
        }
    }
}

/**订单列表Api*/
- (void)httpPath_orderList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    if (self.isIdentifion) {
        [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"identifion"];
    }
    [parameters setValue:self.customerId forKey:@"customerId"];
    if (self.orderCode.length) {
         [parameters setValue:self.orderCode forKey:@"orderCode"];
    }
    
    if (self.selectedTimeType.length) {
        [parameters setValue:self.selectedTimeType forKey:@"timeQuantum"];
    }
    else
    {
        [parameters setValue:@"ALL" forKey:@"timeQuantum"];
    }
    if (self.controllerType == OrderManageVCTypeMAJOR) {
        [parameters setValue:@"MAJOR" forKey:@"type"];
    }
    else if (self.controllerType == OrderManageVCTypeGROOM)
    {
        [parameters setValue:@"GROOM" forKey:@"type"];
    }
    else
    {
        [parameters setValue:@"ALL" forKey:@"type"];
    }
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isReturn"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_orderList;
}

/**获取下拉数据Api*/
- (void)httpPath_load
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_load;
}



#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeOrder;
        
    }
    return _searchView;
}



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH, SCREEN_HEIGHT - 125) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderListTCell" bundle:nil] forCellReuseIdentifier:@"OrderListTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无订单信息";
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
- (NSMutableArray *)selectDataArr
{
    if (!_selectDataArr) {
        _selectDataArr = [[NSMutableArray alloc] init];
    }
    return _selectDataArr;
}


- (OrderScreenSideslipView *)conditionSelectView
{
    if (!_conditionSelectView) {
        _conditionSelectView = [[OrderScreenSideslipView alloc] initWithMarginTop:SCREEN_NavTop_Height];
    }
    return _conditionSelectView;
}



#pragma mark -- 刷新重置等设置
- (void)configPagingData
{
    self.pageNumber = 1;
    self.pageSize = 10;
}
- (void)handlePageSize
{
    if (self.pageNumber > 1) {
        self.pageSize = self.pageSize * self.pageNumber;
        self.pageNumber = 1;
    }
}
- (void)handlePageNumber
{
    if (self.pageSize > 10) {
        self.pageNumber = self.pageSize / 10;
        self.pageSize = 10;
    }
}

- (void)dealloc
{
    NSLog(@"d订单列表页面释放");
}
-(NSString*)getOrderStatus:(NSString*)status{
    NSString* orderStatus= @"";
    if([status isEqualToString:@"all"]){
        orderStatus = @"全部";
    }
    else if([status isEqualToString:@"waitSub"]){
        orderStatus = @"待提交";
    }
    else if([status isEqualToString:@"wait"]){
        orderStatus = @"待审核";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
           self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"待门店审核";
        }
    } else if([status isEqualToString:@"waitDeliver"]){
        orderStatus = @"待发货";
    }  else if([status isEqualToString:@"waitAllocate"]){
        orderStatus = @"待配货";
    } else if([status isEqualToString:@"allocate"]){
        orderStatus = @"配货中";
    } else if([status isEqualToString:@"partAllocate"]){
        orderStatus = @"部分配货";
    } else if([status isEqualToString:@"allAllocate"]){
        orderStatus = @"全部配货";
    } else if([status isEqualToString:@"partDeliver"]){
        orderStatus = @"部分发货";
    }else if([status isEqualToString:@"allDeliver"]){
        orderStatus = @"全部发货";
    }else if([status isEqualToString:@"finish"]){
        orderStatus = @"已完成";
    }else if([status isEqualToString:@"refuse"]){
        orderStatus = @"已拒绝";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
           self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"门店已拒绝";
        }
    }else if([status isEqualToString:@"waitGoods"]){
        orderStatus = @"待收货";
    }else if([status isEqualToString:@"refuseAD"]){
        orderStatus = @"AD已拒绝";
    } else if([status isEqualToString:@"waitAD"]){
        orderStatus = @"待AD审核";
    }
    
    
   
    
    return orderStatus;
}
-(void)buttonClick:(NSInteger)type orderID:(NSString*)orderID{
    if(type == 1){//更新发货
        xw_SelectDeliveryWayVC *orderDetailVC = [[xw_SelectDeliveryWayVC alloc] init];
        orderDetailVC.orderID = orderID;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    } else if(type == 2){//预约自提
        XwSubscribeTakeVC *orderDetailVC = [[XwSubscribeTakeVC alloc] init];
        orderDetailVC.orderID = orderID;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    } else {
        NSLog(@"再来一单");
    }

}
@end
