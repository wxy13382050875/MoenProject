//
//  xw_StockInfoVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_StockInfoVC.h"
#import "CommonSingleGoodsDarkTCell.h"
//#import "xw_StoreOrderViewModel.h"
#import "XwStockInfoModel.h"
@interface xw_StockInfoVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
//@property (nonatomic, strong) xw_StoreOrderViewModel *viewModel;
@end

@implementation xw_StockInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    [self xw_setupUI];
    [self xw_bindViewModel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self xw_layoutNavigation];
    [self xw_loadDataSource];
}
-(void)xw_layoutNavigation{
    self.title = @"库存参考信息";
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0)) ;
}
-(void)xw_loadDataSource{
    
    
//    kSetMJRefresh(self.tableView);
    [self httpPath_stores_getShopDealerStock];
    
}
-(void)xw_loadNewData{
    
    [self.dataSource removeAllObjects];
//    self.page = 1;
    [self getData];
}
-(void)xw_loadMoreData{
    if ([self.tableView.mj_header isRefreshing]) {
        return;
    }
//    self.page ++;
    [self getData];
}
-(void)getData{
    
}

-(void)xw_bindViewModel{
    
}
//库存参考信息
-(void)httpPath_stores_getShopDealerStock{
    NSMutableArray* arr= [NSMutableArray array];
    
    for (CommonGoodsModel* model in self.array) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:model.code forKey:@"goodsSKU"];
        [dict setObject:@(model.kGoodsCount) forKey:@"num"];
        
        [arr addObject:dict];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:arr forKey:@"goodsSkuInfos"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_getShopDealerStock;
}
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([parserObject.code isEqualToString:@"200"]) {
                if ([operation.urlTag isEqualToString:Path_stores_getShopDealerStock]) {//进货单详情
                    self.dataSource = [XwStockInfoModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"productList"]];
                }
                [self.tableView reloadData];
            }
            else
            {
                self.isShowEmptyData = YES;
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingleGoodsDarkTCell class])];
//    [cell showDataWithOrderManageModel:model];
    cell.stockInfoModel = self.dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCommonSingleGoodsDarkTCellH;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
 
    XwStockInfoModel* model = self.dataSource[section];
    
    UILabel *titleLa =[UILabel labelWithText:[NSString stringWithFormat:@"本店库存数量：%@",model.shopNum] WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    UILabel *titleLb =[UILabel labelWithText:[NSString stringWithFormat:@"AD库存数量：%@",model.dealerNum] WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    [footer addSubview:titleLa];
    [footer addSubview:titleLb];
    titleLa.sd_layout.
    leftSpaceToView(footer, 10).rightSpaceToView(footer, 10).topEqualToView(footer).heightIs(30);
    titleLb.sd_layout.
    leftSpaceToView(footer, 10).rightSpaceToView(footer, 10).bottomEqualToView(footer).heightIs(30);
    return footer;
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableHeaderView = [UIView new];
        kRegistCell(_tableView,@"CommonSingleGoodsDarkTCell",@"CommonSingleGoodsDarkTCell")
    }
    return _tableView;
}
//
-(NSMutableArray*)dataSource{
 
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
@end
