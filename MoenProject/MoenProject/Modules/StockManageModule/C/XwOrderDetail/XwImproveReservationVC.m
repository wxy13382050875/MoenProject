//
//  XwImproveReservationVC.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/29.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "XwImproveReservationVC.h"
#import "CommonSingleGoodsTCell.h"
#import "ExchangeGoodsModel.h"
#import "SalesCounterVC.h"
#import "SalesCounterDataModel.h"
@interface XwImproveReservationVC ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UIButton *submitBtn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@end

@implementation XwImproveReservationVC

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
    self.title = @"完善预定商品";
    
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, isIphoneX?55:40, 0)) ;
    [self.view addSubview:self.submitBtn];
    self.submitBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).heightIs(isIphoneX?55:40);

}
-(void)xw_loadDataSource{
    
    
    [self httpPath_ReserveProduct];
    
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
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    
    
    CommonSingleGoodsTCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommonSingleGoodsTCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [cell showDataWithCommonGoodsModelForGift:nil AtIndex:indexPath.section];
    cell.reserveModel = self.dataSource[indexPath.section];
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KCommonSingleGoodsTCellSingleH;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [UIView new];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"CommonSingleGoodsTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsTCell"];
    }
    return _tableView;
}


//库存参考信息
-(void)httpPath_ReserveProduct{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_ReserveProduct;
}
//库存参考信息
-(void)httpPath_ReserveProductFix{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.orderID forKey:@"id"];
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (GoodslistModel* model in self.dataSource) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setObject:model.orderItemId forKey:@"orderItemId"];
        [dict setObject:[NSString stringWithFormat:@"%.3f",model.square] forKey:@"square"];
        [array addObject:dict];
    }
    [parameters setValue:array forKey:@"products"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_ReserveProductFix;
}
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
//    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_stores_getOrderProductInfo]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([parserObject.code isEqualToString:@"200"]) {
                if ([operation.urlTag isEqualToString:Path_ReserveProduct]) {
                    self.dataSource = [GoodslistModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"orderProductList"]];

                   
                    [self.tableView reloadData];
                } else if ([operation.urlTag isEqualToString:Path_ReserveProductFix]) {
                    SalesCounterDataModel* model =[SalesCounterDataModel mj_objectWithKeyValues:parserObject.datas[@"order"]];
                    
                    SalesCounterVC *salesCounterVC = [[SalesCounterVC alloc] init];
                    salesCounterVC.counterDataModel = model;
                    salesCounterVC.customerId = self.customerId;
                    salesCounterVC.type = SalesCounterTypeReserve;
                    salesCounterVC.code = model.code;
                    salesCounterVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:salesCounterVC animated:YES];
                }
                
            }
            
            else
            {
                self.isShowEmptyData = YES;
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}


#pragma mark -- Getter&Setter

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"完善预定信息" WithtextColor:COLOR(@"#FFFFFF")  WithBackColor:AppBtnDeepBlueColor WithBackImage:nil WithImage: nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            
            FDAlertView *alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"确认提交完善预定商品" block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    [self httpPath_ReserveProductFix];
                    
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil),  nil];
            [alert show];
            
        }];
    }
    return _submitBtn;
}
@end
