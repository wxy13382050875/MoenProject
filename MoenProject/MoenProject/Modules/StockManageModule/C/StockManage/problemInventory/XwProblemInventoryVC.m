//
//  XwProblemInventoryVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/16.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwProblemInventoryVC.h"
#import "ChangeStockTCell.h"

@interface XwProblemInventoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)NSString* operateType;
@property(nonatomic,strong)UIButton* AdjustBtn;

@end

@implementation XwProblemInventoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
   
    
    
    
    
    if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust) {
        self.title = @"调库单调整";
    }
    else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)
    {
        self.title = @"盘库单调整";
    }
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.AdjustBtn];
    
    self.AdjustBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    self.tableview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(self.AdjustBtn, 0);
}

- (void)configBaseData
{

}



#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.goodsList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
    
    
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

    cell.lastModel =self.model.goodsList[indexPath.section];
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    
    
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

}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    
    if (requestErr) {
       
    }
    else
    {
        if (parserObject.success) {
            if (
                [operation.urlTag isEqualToString:Path_inventory_inventoryCheckOperate]
                ) {
                    if ([parserObject.code isEqualToString:@"200"]) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [[NSToastManager manager] showtoast:parserObject.message];
                    }
                }
            
        }
    }
}


/**盘库操作（保存或确认）Api*/
- (void)httpPath_Path_inventory_inventoryCheckOperate:(NSString*)type
{
    self.operateType = type;
    NSMutableArray* array = [NSMutableArray array];
    for(Lastgoodslist* model in self.model.goodsList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCountAfter isEqualToString:@""]){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCountAfter forKey:@"goodsCount"];
            [dict setObject:model.reason==nil?@"":model.reason forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:[QZLUserConfig sharedInstance].shopId forKey:@"storeID"];
        [parameters setValue:self.operateType forKey:@"operateType"];
        [parameters setValue:@"" forKey:@"inventoryNo"];
        [parameters setValue:self.goodsType forKey:@"goodsType"];
        [parameters setValue:array forKey:@"goodsList"];
        self.requestType = NO;
        self.requestParams = parameters;
        self.requestURL = Path_inventory_inventoryCheckOperate;
    } else {
        [[NSToastManager manager] showtoast:@"请输入库存数"];
    }
    
}
/**调库单调整（保存或确认）Api*/
- (void)httpPath_inventory_callInventoryOrderOperate
{
    NSMutableArray* array = [NSMutableArray array];
    for(Goodslist* model in self.model.goodsList){
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
//        [parameters setValue:self.inventoryNo forKey:@"callInventoryOrderID"];
        
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
      
        [_tableview registerNib:[UINib nibWithNibName:@"ChangeStockTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStockTCell"];
        
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无商品信息";
        
    }
    return _tableview;
}




#pragma mark -- 刷新重置等设置

-(UIButton*)AdjustBtn{
    if(!_AdjustBtn){
        _AdjustBtn = [UIButton buttonWithTitie:@"调整" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnGoldenColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"保存");
            [self httpPath_Path_inventory_inventoryCheckOperate:@"save"];
        }];
    }
    return  _AdjustBtn;
}


@end
