//
//  ReturnGoodsVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsVC.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderListTCell.h"
#import "ReturnGoodsSelectVC.h"

#import "ReturnAllGoodsCounterVC.h"

@interface ReturnGoodsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation ReturnGoodsVC

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
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderManageModel *model = self.dataList[section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.createDate;
    [headerView addSubview:timeLab];
    
    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, SCREEN_WIDTH - 30, 20)];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@",model.orderCode]];
    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6, str.length - 6)];
    orderLab.attributedText = str;
    [headerView addSubview:orderLab];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    OrderManageModel *model = self.dataList[section];
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
    
    UIView *lineMiddleView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineMiddleView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineMiddleView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(SCREEN_WIDTH - 185, 50, 80, 28);
    leftBtn.titleLabel.font = FONTLanTingR(13);
    [leftBtn setTitle:NSLocalizedString(@"whole_return", nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
    leftBtn.clipsToBounds = YES;
    leftBtn.layer.borderColor = AppTitleBlueColor.CGColor;
    leftBtn.layer.cornerRadius = 14;
    leftBtn.layer.borderWidth = 1;
    leftBtn.tag = 9000 + section;
    [leftBtn addTarget:self action:@selector(ReturnGoodsAction:) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 95, 50, 80, 28);
    rightBtn.titleLabel.font = FONTLanTingR(14);
    [rightBtn setTitle:NSLocalizedString(@"partial_return", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:AppTitleBlueColor forState:UIControlStateNormal];
    rightBtn.clipsToBounds = YES;
    rightBtn.layer.cornerRadius = 14;
    rightBtn.layer.borderColor = AppTitleBlueColor.CGColor;
    rightBtn.layer.borderWidth = 1;
    rightBtn.tag = 10000 + section;
    [rightBtn addTarget:self action:@selector(ReturnPartGoodsAction:) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:rightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 5)];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
    if(!model.wholeOtherReturn){
        leftBtn.hidden = YES;
    }
    
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
    //    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma mark -- Private Method

/**部分退货*/
- (void)ReturnPartGoodsAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 10000;
    OrderManageModel *model = self.dataList[atIndex];
    ReturnGoodsSelectVC *returnGoodsSelectVC = [[ReturnGoodsSelectVC alloc] init];
    returnGoodsSelectVC.controllerType = ReturnGoodsSelectVCTypePart;
    returnGoodsSelectVC.orderID = model.ID;
    [self.navigationController pushViewController:returnGoodsSelectVC animated:YES];
}

/**全部退货*/
- (void)ReturnGoodsAction:(UIButton *)sender
{
    NSInteger atIndex = sender.tag - 9000;
    OrderManageModel *model = self.dataList[atIndex];
    
    ReturnAllGoodsCounterVC *returnAllGoodsCounterVC = [[ReturnAllGoodsCounterVC alloc] init];
    returnAllGoodsCounterVC.orderID = model.ID;
    [self.navigationController pushViewController:returnAllGoodsCounterVC animated:YES];
}



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
    [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"identifion"];
    [parameters setValue:[NSNumber numberWithBool:YES] forKey:@"isReturn"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_orderList;
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
