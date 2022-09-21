//
//  ExchangeGoodsSelectVC.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/19.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "ExchangeGoodsSelectVC.h"
#import "SelectExchangeGoodsCell.h"
#import "ExchangeGoodsModel.h"
@interface ExchangeGoodsSelectVC ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *floorsAarr;

@end

@implementation ExchangeGoodsSelectVC

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
    self.title = @"选择换货商品";
    
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0)) ;
}
-(void)xw_loadDataSource{
    
    
    [self httpPath_SelectExchangeProduct];
    
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
    return self.floorsAarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    
    
    SelectExchangeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectExchangeGoodsCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model.Data;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];
    return model.cellHeight;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonTVDataModel *model = self.floorsAarr[indexPath.section][indexPath.row];

    if(self.selectBlock){
        self.selectBlock(model.Data);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.tableHeaderView = [UIView new];
        
        
        [_tableView registerNib:[UINib nibWithNibName:@"SelectExchangeGoodsCell" bundle:nil] forCellReuseIdentifier:@"SelectExchangeGoodsCell"];
    }
    return _tableView;
}


//库存参考信息
-(void)httpPath_SelectExchangeProduct{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.goodsID forKey:@"goodsID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_SelectExchangeProduct;
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
                if ([operation.urlTag isEqualToString:Path_SelectExchangeProduct]) {
                    self.dataSource = [GoodslistModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"goodsList"]];
//                    self.model = [XwUpdateDeliveryModel mj_objectWithKeyValues:parserObject.datas[@"orderProductData"]];
                    [self.floorsAarr removeAllObjects];
                    [self handleTableViewFloorsData];
                    
                   
                    [self.tableView reloadData];
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

- (void)handleTableViewFloorsData
{
    
    
    for (GoodslistModel *model in self.dataSource) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        //当前商品的Cell
        CommonTVDataModel *cellModel = [[CommonTVDataModel alloc] init];
        cellModel.cellIdentify = @"SelectExchangeGoodsCell";
        cellModel.cellHeight = 116;
        cellModel.cellHeaderHeight = 5;
        cellModel.cellFooterHeight =  0.01;
        cellModel.Data = model;
        [sectionArr addObject:cellModel];
        
        [self.floorsAarr addObject:sectionArr];
    }
    
}

#pragma mark -- Getter&Setter
- (NSMutableArray *)floorsAarr
{
    if (!_floorsAarr) {
        _floorsAarr = [[NSMutableArray alloc] init];
    }
    return _floorsAarr;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end


