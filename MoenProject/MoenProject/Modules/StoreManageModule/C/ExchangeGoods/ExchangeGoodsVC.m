//
//  ExchangeGoodsVC.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "ExchangeGoodsVC.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderListTCell.h"
#import "ExchangeGoodsCounterVC.h"
#import "ExchangeGoodsModel.h"
@interface ExchangeGoodsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation ExchangeGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"select_order", nil);
    
    [self.view addSubview:self.tableview];
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
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
    return 95;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExchangeGoodsModel *model = self.dataList[indexPath.section];
    if (model.goodsList.count > 1) {
        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderManageModel:model];
        cell.exchangeModel = model;
        return cell;
    }
    else
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
//        [cell showDataWithOrderManageModel:model];
        cell.exchangeModel = model;
        return cell;
    }
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ExchangeGoodsModel *model = self.dataList[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.orderTime;
    [headerView addSubview:timeLab];
    
    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 20)];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@",model.orderID]];
    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6, str.length - 6)];
    orderLab.attributedText = str;
    [headerView addSubview:orderLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    ExchangeGoodsModel *model = self.dataList[section];
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = AppBgWhiteColor;
    
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 20)];
    infoLab.font = FONTLanTingR(14);
    infoLab.textColor = AppTitleBlackColor;
    infoLab.textAlignment = NSTextAlignmentRight;
    
    
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%ld件商品 实付款:￥%@",(long)model.productNum, model.payAmount]];
//    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
//    [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.payAmount.length - 1, model.payAmount.length + 1)];
//    infoLab.attributedText = str;
    
    NSString *giftGoodsCountStr = [NSString stringWithFormat:@"%@",model.giftCount];
    NSString *productNumCountStr = [NSString stringWithFormat:@"%@",model.goodsCount];
    if (model.giftCount > 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品, %@件赠品  实付款:￥%@",productNumCountStr,giftGoodsCountStr, model.amount]];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",productNumCountStr].length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%@",productNumCountStr].length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6 + productNumCountStr.length, giftGoodsCountStr.length)];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.amount.length - 1, model.amount.length + 1)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.amount.length - 1, model.amount.length + 1)];

        
        infoLab.attributedText = str;
    }
    else
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品 实付款:￥%@",productNumCountStr, model.amount]];
        
        [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(1, [NSString stringWithFormat:@"%@",productNumCountStr].length)];
        [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(1, [NSString stringWithFormat:@"%@",productNumCountStr].length)];
        
           [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(str.length - model.amount.length - 1, model.amount.length + 1)];
           [str addAttribute:NSForegroundColorAttributeName value:AppTitleGoldenColor range:NSMakeRange(str.length - model.amount.length - 1, model.amount.length + 1)];
           infoLab.attributedText = str;
    }
    
    
    
    
    [footerView addSubview:infoLab];
    
    UIView *lineMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineMiddleView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineMiddleView];
    
    UIButton *exchangeBtn = [UIButton buttonWithTitie:@"换货" WithtextColor:AppTitleBlueColor WithBackColor:nil WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
        ExchangeGoodsCounterVC *exchangeGoodsSelectVC = [[ExchangeGoodsCounterVC alloc] init];
        exchangeGoodsSelectVC.orderID = model.orderID;
        [self.navigationController pushViewController:exchangeGoodsSelectVC animated:YES];
    }];
    exchangeBtn.titleLabel.font = FONTLanTingR(14);
    [footerView addSubview:exchangeBtn];
    ViewBorderRadius(exchangeBtn, 14, 1, AppTitleBlueColor)
    exchangeBtn.sd_layout
    .rightSpaceToView(footerView, 15)
    .widthIs(80).heightIs(28).bottomSpaceToView(footerView, 14);
    
//    UIButton *exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    exchangeBtn.frame = CGRectMake(SCREEN_WIDTH - 95, 50, 80, 28);
//    exchangeBtn.titleLabel.font = FONTLanTingR(14);
//    [exchangeBtn setTitle:NSLocalizedString(@"partial_return", nil) forState:UIControlStateNormal];
//    [exchangeBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
//    exchangeBtn.clipsToBounds = YES;
//    exchangeBtn.layer.cornerRadius = 14;
//    exchangeBtn.layer.borderColor = AppTitleBlueColor.CGColor;
//    exchangeBtn.layer.borderWidth = 1;
//    exchangeBtn.tag = 10000 + section;
//    [exchangeBtn addTarget:self action:@selector(ReturnPartGoodsAction:) forControlEvents:UIControlEventTouchDown];
//    [footerView addSubview:rightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 5)];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
//    if(!model.wholeOtherReturn){
//        leftBtn.hidden = YES;
//    }
    
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    //    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- Private Method
//
///**部分退货*/
//- (void)ReturnPartGoodsAction:(UIButton *)sender
//{
//    NSInteger atIndex = sender.tag - 10000;
//    OrderManageModel *model = self.dataList[atIndex];
////    ReturnGoodsSelectVC *returnGoodsSelectVC = [[ReturnGoodsSelectVC alloc] init];
////    returnGoodsSelectVC.controllerType = ReturnGoodsSelectVCTypePart;
////    returnGoodsSelectVC.orderID = model.ID;
////    [self.navigationController pushViewController:returnGoodsSelectVC animated:YES];
////    model.wholeOtherReturn = NO;
//    if(!model.wholeOtherReturn){
//        FDAlertView * alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"本订单存在总仓预约商品，此类商品请终止后再进行退货" block:^(NSInteger buttonIndex, NSString *inputStr) {
//                                    if(buttonIndex == 1){
//                                        
//                                    }
//                                    
//                                } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_return", nil), nil];
//                                [alert show];
//        
//    } else {
//        ReturnGoodsSelectVC *returnGoodsSelectVC = [[ReturnGoodsSelectVC alloc] init];
//        returnGoodsSelectVC.controllerType = ReturnGoodsSelectVCTypePart;
//        returnGoodsSelectVC.orderID = model.ID;
//        [self.navigationController pushViewController:returnGoodsSelectVC animated:YES];
//    }
//}
//
///**全部退货*/
//- (void)ReturnGoodsAction:(UIButton *)sender
//{
//    
//    NSInteger atIndex = sender.tag - 9000;
//    OrderManageModel *model = self.dataList[atIndex];
////    model.wholeOtherReturn = NO;
//    if(!model.wholeOtherReturn){
//        FDAlertView * alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"本订单存在总仓预约商品，请终止后再进行退货" block:^(NSInteger buttonIndex, NSString *inputStr) {
//                                    if(buttonIndex == 1){
//                                        ReturnAllGoodsCounterVC *returnAllGoodsCounterVC = [[ReturnAllGoodsCounterVC alloc] init];
//                                        returnAllGoodsCounterVC.orderID = model.ID;
//                                        returnAllGoodsCounterVC.wholeOtherReturn = model.wholeOtherReturn;
//                                        [self.navigationController pushViewController:returnAllGoodsCounterVC animated:YES];
//                                    }
//                                    
//                                } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_show_view", nil), nil];
//                                [alert show];
//        
//    } else {
//        ReturnAllGoodsCounterVC *returnAllGoodsCounterVC = [[ReturnAllGoodsCounterVC alloc] init];
//        returnAllGoodsCounterVC.orderID = model.ID;
//        returnAllGoodsCounterVC.wholeOtherReturn = model.wholeOtherReturn;
//        [self.navigationController pushViewController:returnAllGoodsCounterVC animated:YES];
//    }
//    
//    
//}



#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_ExchangeGoods]) {
//                OrderManageListModel *listModel = (OrderManageListModel *)parserObject;
                NSArray* array = [ExchangeGoodsModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"orderList"]];
                
                if (array.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:array];
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
        }
    }
}

/**选择退货订单列表（和订单列表复用）Api*/
- (void)httpPath_orderList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@(self.pageNumber) forKey:@"pageNum"];
    [parameters setValue:@(self.pageSize) forKey:@"pageSize"];
    [parameters setValue:self.customerId forKey:@"customerId"];
    [parameters setValue:@(self.isIdentifion) forKey:@"identifion"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_ExchangeGoods;
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
        [_tableview registerNib:[UINib nibWithNibName:@"OrderListTCell" bundle:nil] forCellReuseIdentifier:@"OrderListTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无可退订单";
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


@end
