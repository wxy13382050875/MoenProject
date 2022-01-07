//
//  XwProblemInventoryVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/16.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwProblemInventoryVC.h"
#import "ChangeStockTCell.h"
#import "StockOperationSuccessVC.h"
#import "StockManageChildVC.h"
@interface XwProblemInventoryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableview;
@property(nonatomic,strong)NSString* operateType;
@property(nonatomic,strong)UIButton* AdjustBtn;
@property(nonatomic,strong)NSArray* dataList;
@end

@implementation XwProblemInventoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    [self configBaseData];
}
-(void)backBthOperate{
    NSLog(@"返回");
    
   
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    BOOL isStock = NO;
    UIViewController* stVC;
    for (UIViewController* vc in marr) {
        if ([vc isKindOfClass:[StockManageChildVC class]]) {
//            [marr removeObject:vc];
            isStock = YES;
            stVC = vc;
        }
    }
    if (isStock) {
        
        [self.navigationController popToViewController:stVC animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
   
    
    
    
    
    if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust) {
        self.title = @"调库问题商品修正";
    }
    else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)
    {
        self.title = @"盘库问题商品修正";
    }
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.AdjustBtn];
    
    self.AdjustBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).heightIs(40);
    self.tableview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).bottomSpaceToView(self.AdjustBtn, 0);
}

- (void)configBaseData
{
    [self httpPath_getProblemProducts];
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

    cell.problemModel =self.dataList[indexPath.section];
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
    WEAKSELF
    if (requestErr) {
       
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getProblemProducts]||
                [operation.urlTag isEqualToString:Path_getProblemList]) {
                    if ([parserObject.code isEqualToString:@"200"]) {
                        
                        weakSelf.dataList = [Goodslist mj_objectArrayWithKeyValuesArray:parserObject.datas[@"goodsList"]];
                        [weakSelf.tableview reloadData];

                    }
                    else
                    {
                        [[NSToastManager manager] showtoast:parserObject.message];
                    }
                }
            if ([operation.urlTag isEqualToString:Path_inventory_callInventoryOrderOperate]||
                [operation.urlTag isEqualToString:Path_inventory_inventoryCheckOperate]
                ) {
                    if ([parserObject.code isEqualToString:@"200"]) {
                        
                        if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust) {
                            [[NSToastManager manager] showtoast:@"调库问题商品修正成功"];
                        }
                        else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)
                        {
                            [[NSToastManager manager] showtoast:@"盘库问题商品修正成功"];
                        }
//                        [self.navigationController popViewControllerAnimated:YES];
                        StockOperationSuccessVC *orderOperationSuccessVC = [[StockOperationSuccessVC alloc] init];
                        NSMutableDictionary* dict = [parserObject.datas[@ "datas"] mutableCopy];
                        [dict setValue:self.operateType forKey:@"operateType"];
                        
                        orderOperationSuccessVC.dict = [dict copy];
                        orderOperationSuccessVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:orderOperationSuccessVC animated:YES];
                    }
                    else
                    {
                        [[NSToastManager manager] showtoast:parserObject.message];
                    }
                }
        }
    }
}

/**问题商品列表 Api*/
- (void)httpPath_getProblemProducts
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue:self.inventoryNo forKey:@"inventoryNo"];
    self.requestType = NO;
    self.requestParams = parameters;
    if(self.controllerType ==PurchaseOrderManageVCTypeStockDaily){
        self.requestURL = Path_getProblemProducts;
    } else {
        self.requestURL = Path_getProblemList;
    }
    
}
/**盘库操作（保存或确认）Api*/
- (void)httpPath_Path_inventory_inventoryCheckOperate:(NSString*)type
{
    self.operateType = type;
    NSMutableArray* array = [NSMutableArray array];
    for(Goodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCountAfter isEqualToString:@""]&&
           ![model.goodsCountAfter isEqualToString:@"0"]&&
           model.goodsCountAfter != nil){
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
        [parameters setValue:self.inventoryNo forKey:@"inventoryNo"];
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
    for(Goodslist* model in self.dataList){
        NSMutableDictionary* dict =[NSMutableDictionary dictionary];
        if(![model.goodsCountAfter isEqualToString:@""]&&model.goodsCountAfter !=nil){
            [dict setObject:model.goodsID forKey:@"goodsID"];
            [dict setObject:model.goodsCountAfter forKey:@"goodsCount"];
            [dict setObject:@"" forKey:@"reason"];
            [array addObject:dict];
        }
    }
    if (array.count > 0) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
        [parameters setValue:self.inventoryNo forKey:@"callInventoryOrderID"];
        
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
        _AdjustBtn = [UIButton buttonWithTitie:@"修正" WithtextColor:AppTitleWhiteColor WithBackColor:AppBtnGoldenColor WithBackImage:nil WithImage:nil WithFont:15 EventBlock:^(id  _Nonnull params) {
            NSLog(@"保存");
            NSString * message= @"";
            if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust) {
//                self.title = @"调库问题商品修正";
                message= @"是否确认提交调库信息？";
            }
            else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)
            {
                message= @"是否确认提交修正商品信息？";
            }
            FDAlertView* alert = [[FDAlertView alloc] initWithBlockTItle:@"" alterType:FDAltertViewTypeTips message:message block:^(NSInteger buttonIndex, NSString *inputStr) {
                if(buttonIndex == 1){
                    if (self.controllerType == PurchaseOrderManageVCTypeStockAdjust) {
        //                self.title = @"调库问题商品修正";
                        [self httpPath_inventory_callInventoryOrderOperate];
                    }
                    else if (self.controllerType == PurchaseOrderManageVCTypeStockDaily)
                    {
                        [self httpPath_Path_inventory_inventoryCheckOperate:@"problem"];
                    }
                }
            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
            [alert show];
           
            
        }];
    }
    return  _AdjustBtn;
}


@end
