//
//  xw_SelectDeliveryWayVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/12.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_SelectDeliveryWayVC.h"
#import "xw_DeliveryInfoVC.h"
@interface xw_SelectDeliveryWayVC ()

@end

@implementation xw_SelectDeliveryWayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"select_purchase_delivery_type", nil);
    
    int leftMargin = 50;
    int btnHeight = 50;
    int topMargin = 150;
    int btnMargin = 30;
    
    UIButton *applyGoodsBtn = [UIButton buttonWithTitie:@"门店自提" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
        
        [self returnAction:DeliveryWayTypeShopSelf];
    }];
    applyGoodsBtn.frame = CGRectMake(leftMargin, topMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight);
    ViewRadius(applyGoodsBtn, 20)
    
    [self.view addSubview:applyGoodsBtn];
    
    
    if(![[QZLUserConfig sharedInstance].storeTypeKey isEqualToString:@"Showroom-Dealer"]){
        UIButton *applySampleBtn = [UIButton buttonWithTitie:@"总仓发货" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            [self returnAction:DeliveryWayTypeStocker];
        }];
        applySampleBtn.frame = CGRectMake(leftMargin, topMargin + btnHeight + btnMargin, SCREEN_WIDTH - leftMargin * 2, btnHeight);
        ViewRadius(applySampleBtn, 20)
        
        [self.view addSubview:applySampleBtn];
    }
    
    
    
}

-(void) returnAction:(DeliveryWayType )type{
    xw_DeliveryInfoVC *storeInfoVC = [xw_DeliveryInfoVC new];
    storeInfoVC.hidesBottomBarWhenPushed = YES;
    storeInfoVC.controllerType =  type;
    storeInfoVC.orderID = self.orderID;
    storeInfoVC.customerId = self.customerId;
    [self.navigationController pushViewController:storeInfoVC animated:YES];
}
@end
