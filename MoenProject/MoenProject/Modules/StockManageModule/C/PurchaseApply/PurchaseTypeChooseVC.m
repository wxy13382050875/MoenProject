//
//  PurchaseTypeChooseVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/7/28.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "PurchaseTypeChooseVC.h"
#import "StockSearchGoodsVC.h"

@interface PurchaseTypeChooseVC()


@end

@implementation PurchaseTypeChooseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"select_purchase_apply_type", nil);
    
    int leftMargin = 50;
    int btnHeight = 50;
    int topMargin = 150;
    int btnMargin = 30;
    
//    UIButton *applyGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight)];
//    [applyGoodsBtn setTitle:@"申请商品" forState:(UIControlStateNormal)];
//    applyGoodsBtn.backgroundColor = AppTitleBlueColor;
//    applyGoodsBtn.layer.cornerRadius = 20;
//    [applyGoodsBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:applyGoodsBtn];
    
    UIButton *applyGoodsBtn = [UIButton buttonWithTitie:@"申请商品" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        
        [self returnAction:@"product"];
    }];
    applyGoodsBtn.frame = CGRectMake(leftMargin, topMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight);
    ViewRadius(applyGoodsBtn, 20)
    
    [self.view addSubview:applyGoodsBtn];
    
    UIButton *applySampleBtn = [UIButton buttonWithTitie:@"申请样品" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        [self returnAction:@"sample"];
    }];
    applySampleBtn.frame = CGRectMake(leftMargin, topMargin + btnHeight + btnMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight);
    ViewRadius(applySampleBtn, 20)
    
    [self.view addSubview:applySampleBtn];
    
//    UIButton *applySampleBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin + btnHeight + btnMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight)];
//    [applySampleBtn setTitle:@"申请样品" forState:(UIControlStateNormal)];
//    applySampleBtn.backgroundColor = AppTitleBlueColor;
//    applySampleBtn.layer.cornerRadius = 20;
//    [applySampleBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:applySampleBtn];
}

-(void) returnAction:(NSString* )type{
    StockSearchGoodsVC *sellGoodsScanVC = [[StockSearchGoodsVC alloc] init];
    sellGoodsScanVC.goodsType = type;
    sellGoodsScanVC.controllerType = SearchGoodsVCType_Stock;
    sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
}

@end
