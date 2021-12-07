//
//  CountTypeChooseVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "CountTypeChooseVC.h"
#import "StartCountStockVC.h"

@interface CountTypeChooseVC()


@end

@implementation CountTypeChooseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"开始盘库";
    
    int leftMargin = 50;
    int btnHeight = 50;
    int topMargin = 150;
    int btnMargin = 30;
    
    UIButton *goodsStockBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight)];
    [goodsStockBtn setTitle:@"商品库存" forState:(UIControlStateNormal)];
    goodsStockBtn.backgroundColor = AppTitleBlueColor;
    goodsStockBtn.layer.cornerRadius = 20;
    [goodsStockBtn addTarget:self action:@selector(goodsStockAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:goodsStockBtn];
    
    
    UIButton *sampleStockBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin + btnHeight + btnMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight)];
    [sampleStockBtn setTitle:@"样品库存" forState:(UIControlStateNormal)];
    sampleStockBtn.backgroundColor = AppTitleBlueColor;
    sampleStockBtn.layer.cornerRadius = 20;
    [sampleStockBtn addTarget:self action:@selector(sampleStockAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:sampleStockBtn];
}

-(void) goodsStockAction{
    StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
    startCountStockVC.hidesBottomBarWhenPushed = YES;
    startCountStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockGoods;
    [self.navigationController pushViewController:startCountStockVC animated:YES];
}
-(void) sampleStockAction{
    StartCountStockVC *startCountStockVC = [[StartCountStockVC alloc] init];
    startCountStockVC.hidesBottomBarWhenPushed = YES;
    startCountStockVC.controllerType = PurchaseOrderManageVCTypeInventoryStockSample;
    [self.navigationController pushViewController:startCountStockVC animated:YES];
}
@end
