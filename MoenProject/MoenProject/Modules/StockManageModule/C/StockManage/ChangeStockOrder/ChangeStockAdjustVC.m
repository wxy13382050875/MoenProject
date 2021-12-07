//
//  ChangeStockAdjustVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/7.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "ChangeStockAdjustVC.h"
#import "ChangeStockTCell.h"
@interface ChangeStockAdjustVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)UIButton* submitBtn;
@property(nonatomic,strong)NSArray* dataList;

@end

@implementation ChangeStockAdjustVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configBaseUI];
    [self configBaseData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    [self.view addSubview:self.tableview];
    
    self.title = @"调库单调整";
    
    [self.view addSubview:self.submitBtn];
    self.submitBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    self.tableview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(self.submitBtn, 0);
}

- (void)configBaseData
{
    
//    [[NSToastManager manager] showprogress];
//    [self httpPath_getProductList];
    self.dataList = self.model.goodsList;
    [self.tableview reloadData];
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
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeStockTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeStockTCell" forIndexPath:indexPath];
//    [cell showDataWithGoodsDetailModel:self.dataList[indexPath.section]];
    
    cell.goodsModel = self.dataList[indexPath.section];
//    if (self.controllerType == PurchaseOrderManageVCTypeStocktakingStockGoods||
//             self.controllerType == PurchaseOrderManageVCTypeStocktakingStockSample)
//    {
//
//    } else {
//        cell.model =self.dataList[indexPath.section];
//    }
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
//    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    timeLab.font = FontBinB(14);
//    timeLab.textColor = AppTitleBlackColor;
//    timeLab.text = @"本店库存";
//    [headerView addSubview:timeLab];
    
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
//    GoodsDetailModel *model = self.dataList[indexPath.section];
//    GoodsDetailVC *goodsDetailVC = [[GoodsDetailVC alloc] init];
//    goodsDetailVC.productID = model.ID;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    [self.tableview cancelRefreshAction];
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getProductList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_inventory_callInventoryOrderOperate]
                ) {
                [self.navigationController popViewControllerAnimated:YES];
//                XwInventoryModel *listModel = [XwInventoryModel mj_objectWithKeyValues:parserObject.datas];
//                if (listModel.inventoryList.count) {
//                    self.isShowEmptyData = NO;
//                    if (weakSelf.pageNumber == 1) {
//                        [weakSelf.dataList removeAllObjects];
//                    }
//                    [weakSelf.dataList addObjectsFromArray:listModel.inventoryList];
//                    [weakSelf.tableview reloadData];
//                }
//                else
//                {
//                    if (weakSelf.pageNumber == 1) {
////                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
//                        [weakSelf.dataList removeAllObjects];
//                        [weakSelf.tableview reloadData];
//                        self.isShowEmptyData = YES;
//                    }
//                    else
//                    {
//                        weakSelf.pageNumber -= 1;
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
//                    }
//                    [weakSelf.tableview hidenRefreshFooter];
//                }
            }
           
        }
    }
}

///**门店商品列表Api*/
//- (void)httpPath_getProductList
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//
//    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//
//    self.requestURL = Path_inventory_inventoryCheckChoice;
//
//
//}

/**盘库操作（保存或确认）Api*/
- (void)httpPath_Path_inventory_inventoryCheckOperate
{
    NSMutableArray* array = [NSMutableArray array];
    for(Goodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCount isEqualToString:@""]&&model.goodsCount !=nil){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCount forKey:@"goodsCount"];
            [dict setObject:@"" forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:self.model.orderID forKey:@"callInventoryOrderID"];
        
        [parameters setValue:array forKey:@"goodsList"];
        self.requestType = NO;
        self.requestParams = parameters;
        self.requestURL = Path_inventory_callInventoryOrderOperate;
    } else {
        [[NSToastManager manager] showtoast:@"请输入库存数"];
    }
    
}






- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"ChangeStockTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStockTCell"];
        
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无商品信息";
        
    }
    return _tableview;
}



//- (NSMutableArray *)dataList
//{
//    if (!_dataList) {
//        _dataList = [[NSMutableArray alloc] init];
//    }
//    return _dataList;
//}




#pragma mark -- 刷新重置等设置

-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"确认" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"盘库确认");
            [self httpPath_Path_inventory_inventoryCheckOperate];
        }];
    }
    return  _submitBtn;
}
@end
