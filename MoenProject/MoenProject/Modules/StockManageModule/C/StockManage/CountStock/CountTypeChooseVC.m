//
//  CountTypeChooseVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "CountTypeChooseVC.h"
#import "StartCountStockVC.h"
#import "RadioButton.h"
@interface CountTypeChooseVC()
@property(nonatomic,strong)UILabel* warehouseLabel;//仓库类型

@property(nonatomic,strong)RadioButton* radioGoods;//商品库存

@property(nonatomic,strong)RadioButton* radiosample;//样品库存

@property(nonatomic,strong)NSMutableArray* buttons1;//仓库类型

@property(nonatomic,strong)UILabel* InventoryLabel;//盘点方式

@property(nonatomic,strong)RadioButton* radioInventory;//日常盘点

@property(nonatomic,strong)RadioButton* radioAdjust;//库存调整

@property(nonatomic,strong)NSMutableArray* buttons2;//盘点方式

@property(nonatomic,strong)UIButton* startBtn;//开始调库

@property(nonatomic,strong)NSString* goodsType;

@property (nonatomic, assign) PurchaseOrderManageVCType controllerType;

@end

@implementation CountTypeChooseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"开始盘库";
    self.view.backgroundColor = AppBgWhiteColor;
    
    [self configBaseUI];
    [self configBaseData];
    self.goodsType = @"product";
    self.controllerType = PurchaseOrderManageVCTypeStockDaily;
    
}
-(void)configBaseUI{
    [self.view addSubview: self.warehouseLabel];
    [self.view addSubview: self.radioGoods];
    [self.view addSubview:self.radiosample];
    
    [self.view addSubview: self.InventoryLabel];
    [self.view addSubview: self.radioInventory];
    [self.view addSubview: self.radioAdjust];
    
    [self.view addSubview: self.startBtn];
    
    self.warehouseLabel.sd_layout.leftSpaceToView(self.view, 15).topEqualToView(self.view).rightSpaceToView(self.view, 15).heightIs(80);
    
    self.radioGoods.sd_layout.leftSpaceToView(self.view, 80).topSpaceToView(self.warehouseLabel, 10).widthIs(80).heightIs(80);
    ViewBorderRadius(self.radioGoods, 40, 1, COLOR(@"#646464"))
    
    self.radiosample.sd_layout.rightSpaceToView(self.view, 80).topSpaceToView(self.warehouseLabel, 10).widthIs(80).heightIs(80);
    ViewBorderRadius(self.radiosample, 40, 1, COLOR(@"#646464"))
    
    self.InventoryLabel.sd_layout.leftSpaceToView(self.view, 15).topSpaceToView(self.radioGoods, 10).rightSpaceToView(self.view, 15).heightIs(80);
    
    self.radioInventory.sd_layout.leftSpaceToView(self.view, 80).topSpaceToView(self.InventoryLabel, 10).widthIs(80).heightIs(80);
    ViewBorderRadius(self.radioInventory, 40, 1, COLOR(@"#646464"))
    
    self.radioAdjust.sd_layout.rightSpaceToView(self.view, 80).topSpaceToView(self.InventoryLabel, 10).widthIs(80).heightIs(80);
    ViewBorderRadius(self.radioAdjust, 40, 1, COLOR(@"#646464"))
    
    self.startBtn.sd_layout.leftSpaceToView(self.view, 30).rightSpaceToView(self.view, 30).bottomSpaceToView(self.view, KWTabBarHeight +30).heightIs(40);
    
    [self.buttons1 addObject:self.radioGoods];
    [self.buttons1 addObject:self.radiosample];
    [self.buttons1[0] setGroupButtons:self.buttons1]; // Setting buttons into the group
    [self.buttons1[0] setSelected:YES]; // Making the first button initially selected
    
    [self.buttons2 addObject:self.radioInventory];
    [self.buttons2 addObject:self.radioAdjust];
    [self.buttons2[0] setGroupButtons:self.buttons2]; // Setting buttons into the group
    [self.buttons2[0] setSelected:YES]; // Making the first button initially selected
}
-(void)configBaseData{
//    [self httpPath_stores_dealerStockerList];
}

//-(void) goodsStockAction{
//    StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
//    startCountStockVC.hidesBottomBarWhenPushed = YES;
//    startCountStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockGoods;
//    [self.navigationController pushViewController:startCountStockVC animated:YES];
//}
//-(void) sampleStockAction{
//    StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
//    startCountStockVC.hidesBottomBarWhenPushed = YES;
//    startCountStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockSample;
//    [self.navigationController pushViewController:startCountStockVC animated:YES];
//}
#pragma mark 懒加载
-(UILabel*)warehouseLabel{
    if(!_warehouseLabel){
        _warehouseLabel = [UILabel labelWithText:@"请选择仓库类型" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _warehouseLabel;
}
-(RadioButton*)radioGoods{
    if(!_radioGoods){
        _radioGoods = [RadioButton new];
        [_radioGoods addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radioGoods setTitle:@"商品库存" forState:UIControlStateNormal];
        [_radioGoods setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radioGoods setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _radioGoods.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_radioGoods setBackgroundImage:[UIImage imageWithColor:AppBgWhiteColor] forState:UIControlStateNormal];
        [_radioGoods setBackgroundImage:[UIImage imageWithColor:COLOR(@"#338CCE")] forState:UIControlStateSelected];
    }
    return _radioGoods;
}
-(RadioButton*)radiosample{
    if(!_radiosample){
        _radiosample = [RadioButton new];
        [_radiosample addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radiosample setTitle:@"样品库存" forState:UIControlStateNormal];
        [_radiosample setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radiosample setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _radiosample.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_radiosample setBackgroundImage:[UIImage imageWithColor:AppBgWhiteColor] forState:UIControlStateNormal];
        [_radiosample setBackgroundImage:[UIImage imageWithColor:COLOR(@"#338CCE")] forState:UIControlStateSelected];
    }
    return _radiosample;
}
-(NSMutableArray*)buttons1{
    if(!_buttons1){
        _buttons1 = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttons1;
}
-(UILabel*)InventoryLabel{
    if(!_InventoryLabel){
        _InventoryLabel = [UILabel labelWithText:@"请选择盘点方式" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _InventoryLabel;
}
-(RadioButton*)radioInventory{
    if(!_radioInventory){
        _radioInventory = [RadioButton new];
        [_radioInventory addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radioInventory setTitle:@"日常盘点" forState:UIControlStateNormal];
        [_radioInventory setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radioInventory setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _radioInventory.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_radioInventory setBackgroundImage:[UIImage imageWithColor:AppBgWhiteColor] forState:UIControlStateNormal];
        [_radioInventory setBackgroundImage:[UIImage imageWithColor:COLOR(@"#338CCE")] forState:UIControlStateSelected];
    }
    return _radioInventory;
}
-(RadioButton*)radioAdjust{
    if(!_radioAdjust){
        _radioAdjust = [RadioButton new];
        [_radioAdjust addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radioAdjust setTitle:@"库存调整" forState:UIControlStateNormal];
        [_radioAdjust setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_radioAdjust setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _radioAdjust.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [_radioAdjust setBackgroundImage:[UIImage imageWithColor:AppBgWhiteColor] forState:UIControlStateNormal];
        [_radioAdjust setBackgroundImage:[UIImage imageWithColor:COLOR(@"#338CCE")] forState:UIControlStateSelected];
    }
    return _radioAdjust;
}
-(NSMutableArray*)buttons2{
    if(!_buttons2){
        _buttons2 = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttons2;
}
-(UIButton*)startBtn{
    if(!_startBtn){
        _startBtn = [UIButton buttonWithTitie:@"开始" WithtextColor:AppBgWhiteColor WithBackColor:COLOR(@"#338CCE") WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
            
            [self httpPath_inventory_haveInventory];
        }];
        ViewRadius(_startBtn, 5)
    }
    return _startBtn;
}

-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        
        if(sender == self.radioGoods){
            NSLog(@"商品库存");
            self.goodsType = @"product";
        } else if(sender == self.radiosample){
            NSLog(@" 样品库存");
            self.goodsType = @"sample";
        } else if(sender == self.radioInventory){
            NSLog(@" 日常盘点");
            self.controllerType = PurchaseOrderManageVCTypeStockDaily;
        } else if(sender == self.radioAdjust){
            NSLog(@" 调整库存");
            self.controllerType = PurchaseOrderManageVCTypeStockAdjust;
        }
    }
}
- (void)httpPath_inventory_haveInventory
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:self.goodsType forKey:@"goodsType"];
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    if(self.controllerType == PurchaseOrderManageVCTypeStockAdjust){
        self.requestURL = Path_inventory_haveCallInventory;
    } else {
        self.requestURL = Path_inventory_haveInventoryCheckChoice;
    }
    
}
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_inventory_haveCallInventory]||
                [operation.urlTag isEqualToString:Path_inventory_haveInventoryCheckChoice]) {
                 if([parserObject.code integerValue]== 200){
//                    self.isShowHis = [parserObject.datas[@"info"] boolValue];
                     StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
                     startCountStockVC.hidesBottomBarWhenPushed = YES;
                     startCountStockVC.controllerType = self.controllerType;
                     startCountStockVC.goodsType = self.goodsType;
                     [self.navigationController pushViewController:startCountStockVC animated:YES];

                } else if([parserObject.code integerValue]== 2003){
                    NSLog(@"parserObject.code = %@",parserObject);
//                    self.baseModel = parserObject;
//                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
                

            }

        }
    }
}
@end
