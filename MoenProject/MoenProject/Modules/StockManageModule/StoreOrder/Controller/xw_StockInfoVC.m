//
//  xw_StockInfoVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_StockInfoVC.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "xw_StoreOrderViewModel.h"
@interface xw_StockInfoVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) xw_StoreOrderViewModel *viewModel;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
           
//            [[self.viewModel.requestCommand execute: nil] subscribeNext:^(id x) {;
//                [self.tableView.mj_header endRefreshing];
//
////                if (array.count < 10) {
////
////                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
////                }
////                [self.dataSource addObjectsFromArray:array];
////                [self.tableView reloadData];
//
//            } error:^(NSError *error) {
////                Dialog().wTypeSet(DialogTypeAuto).wMessageSet(error.localizedDescription).wDisappelSecondSet(1).wStart();
//                [self.tableView.mj_header endRefreshing];
//            }];
    //
        });
}

-(void)xw_bindViewModel{
    
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingleGoodsDarkTCell class])];
//    [cell showDataWithOrderManageModel:model];
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
 
    UILabel *titleLa =[UILabel labelWithText:[NSString stringWithFormat:@"本店库存数量：%@",@"0"] WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    UILabel *titleLb =[UILabel labelWithText:[NSString stringWithFormat:@"AD库存数量：%@",@"0"] WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
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
