//
//  xw_StoreOrderVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_StoreOrderVC.h"
#import "xw_StoreOrderViewModel.h"
#import "SKSTableView.h"
#import "CounterAddressTCell.h"
#import "SellGoodsOrderConfigTCell.h"
#import "SellGoodsOrderStatisticsTCell.h"
#import "xwStoreOrderGoodsCell.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "xw_StockInfoVC.h"
#import "xw_DeliveryInfoVC.h"
@interface xw_StoreOrderVC ()<UITableViewDataSource, UITableViewDelegate,SKSTableViewDelegate>
@property (nonatomic, strong) SKSTableView *tableView;
@property (nonatomic, strong) UIButton *confirmBth;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) xw_StoreOrderViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation xw_StoreOrderVC




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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)xw_layoutNavigation{
    self.title = @"卖货柜台";
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 40, 0)) ;
    [self.view addSubview:self.confirmBth];
    self.confirmBth.sd_layout
    .leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(40);
}
-(void)xw_loadDataSource{
    
    
//    kSetMJRefresh(self.tableView);
    
}
-(void)xw_loadNewData{
    
    [self.dataSource removeAllObjects];
    self.page = 1;
    [self getData];
}
-(void)xw_loadMoreData{
    if ([self.tableView.mj_header isRefreshing]) {
        return;
    }
    self.page ++;
    [self getData];
}
-(void)getData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
           
            [[self.viewModel.requestCommand execute: nil] subscribeNext:^(id x) {;
                [self.tableView.mj_header endRefreshing];
                
//                if (array.count < 10) {
//
//                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//                [self.dataSource addObjectsFromArray:array];
//                [self.tableView reloadData];

            } error:^(NSError *error) {
//                Dialog().wTypeSet(DialogTypeAuto).wMessageSet(error.localizedDescription).wDisappelSecondSet(1).wStart();
                [self.tableView.mj_header endRefreshing];
            }];
    //
        });
}

-(void)xw_bindViewModel{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    } else if(section == 1){
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
   
    return 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            CounterAddressTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CounterAddressTCell class])];
            return cell;
        } else {
            SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKSTableViewCell class])];
            cell.textLabel.text = @"库存参考信息";
            cell.expandable = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }
    } else if(indexPath.section == 1){
        if (indexPath.row < 2) {
            xwStoreOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([xwStoreOrderGoodsCell class])];
            cell.orderType = OrderActionTypeOrder;
            return cell;
        } else {
            SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SKSTableViewCell class])];
            cell.textLabel.text = @"KAC0211+KAC0271";
            cell.expandable = YES;
            return cell;
        }
        
    } else if(indexPath.section == 2){
        SellGoodsOrderConfigTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SellGoodsOrderConfigTCell class])];
        return cell;
    } else {
        
        SellGoodsOrderStatisticsTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SellGoodsOrderStatisticsTCell class])];
        return cell;
    }
    
    
    
//    cell.textLabel.text = self.contents[indexPath.section][indexPath.row][0];
    
//    if ((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 0)) || (indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 2)))
//        cell.expandable = YES;
//    else
//        cell.expandable = NO;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingleGoodsDarkTCell class])];
//    [cell showDataWithOrderManageModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            return KCounterAddressTCellH;
        } else {
            return 40;
            
        }
    } else if(indexPath.section == 1){
        if (indexPath.row < 2) {
            return KXwStoreOrderGoodsCellH;
        } else {
            return 40;
        }
    } else if(indexPath.section == 2){
        return KSellGoodsOrderConfigTCellH;
    } else {
        
        return KSellGoodsOrderStatisticsTCellH;
    }
}
-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return KCommonSingleGoodsDarkTCellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
    if(indexPath.section == 0&& indexPath.row == 1){
//        xw_StockInfoVC *storeInfoVC = [xw_StockInfoVC new];
//        storeInfoVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:storeInfoVC animated:YES];
        
        xw_DeliveryInfoVC *storeInfoVC = [xw_DeliveryInfoVC new];
        storeInfoVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:storeInfoVC animated:YES];
        
    }
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

//-(CGFloat)tableView:(SKSTableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 5;
//}
//-(UIView*)tableView:(SKSTableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    return view;
//}
//-(CGFloat)tableView:(SKSTableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.1f;
//}
//-(UIView*)tableView:(SKSTableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

-(SKSTableView*)tableView{
    if (!_tableView) {
        _tableView = [[SKSTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.SKSTableViewDelegate = self;

        kRegistCell(_tableView,@"CounterAddressTCell",@"CounterAddressTCell")
        kRegistCell(_tableView,@"SellGoodsOrderStatisticsTCell",@"SellGoodsOrderStatisticsTCell")
        kRegistCell(_tableView,@"xwStoreOrderGoodsCell",@"xwStoreOrderGoodsCell")
        kRegistCell(_tableView,@"CommonSingleGoodsDarkTCell",@"CommonSingleGoodsDarkTCell")
        
        kRegistClassCell(_tableView,[SKSTableViewCell class],@"SKSTableViewCell")
        kRegistCell(_tableView,@"SellGoodsOrderConfigTCell",@"SellGoodsOrderConfigTCell")
    }
    return _tableView;
}
-(UIButton*)confirmBth{
    if(!_confirmBth){
        _confirmBth = [UIButton buttonWithTitie:@"确认订单" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"确认订单");
        }];
    }
    return  _confirmBth;
}
-(xw_StoreOrderViewModel*)viewModel{
    if (!_viewModel) {
        _viewModel = [[xw_StoreOrderViewModel alloc] init];
    }
    return _viewModel;
}
-(NSMutableArray*)dataSource{
 
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
@end
