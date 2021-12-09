//
//  OrderOperationSuccessVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderOperationSuccessVC.h"
#import "OrderDetailVC.h"
#import "SalesCounterVC.h"
#import "ReturnOrderDetailVC.h"

#import "ReturnAllGoodsCounterVC.h"
#import "ReturnGoodsCounterVC.h"
#import "ReturnGoodsSelectVC.h"
#import "XwOrderDetailVC.h"

@interface OrderOperationSuccessVC ()

@property (weak, nonatomic) IBOutlet UIImageView *top_Img;
@property (weak, nonatomic) IBOutlet UILabel *tip_Lab;

@property (weak, nonatomic) IBOutlet UILabel *top_Lab;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_Img;
@property (weak, nonatomic) IBOutlet UILabel *bottom_Lab;

@end

@implementation OrderOperationSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//        if (marr.count > 1) {
//            UIViewController *vc = [marr objectAtIndex:marr.count - 2];
//            if ([vc isKindOfClass:[ReturnGoodsSelectVC class]]) {
//                [marr removeObject:vc];
//            }
//            self.navigationController.viewControllers = marr;
//        }
    
        //清除上一个视图控制器
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    if (marr.count > 1) {
        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
        if ([vc isKindOfClass:[SalesCounterVC class]] ||
            [vc isKindOfClass:[ReturnAllGoodsCounterVC class]] ||
            [vc isKindOfClass:[ReturnGoodsCounterVC class]]) {
            [marr removeObject:vc];
            
            UIViewController *vc = [marr objectAtIndex:marr.count - 2];
            if ([vc isKindOfClass:[ReturnGoodsSelectVC class]]) {
                [marr removeObject:vc];
            }
//            if (self.controllerType == OrderOperationSuccessVCTypePlacing) {
                UIViewController *scanView = [marr objectAtIndex:marr.count - 2];
                [marr removeObject:scanView];
//            }
        }
        self.navigationController.viewControllers = marr;
    }
}


- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    self.top_Lab.font = FONTLanTingB(17);
    self.bottom_Lab.font = FONTLanTingR(14);
    self.tip_Lab.font = FONTLanTingR(14);
    
    if (self.controllerType == OrderOperationSuccessVCTypePlacing) {
        self.title = NSLocalizedString(@"order_complete", nil);
        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
        self.top_Lab.text = NSLocalizedString(@"order_complete_t", nil);
        self.bottom_Lab.text = NSLocalizedString(@"order_detail", nil);
    } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {
        self.title = NSLocalizedString(@"order_complete", nil);
        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
        if(self.controllerType == OrderOperationSuccessVCTypeStockSave){
            self.top_Lab.text = NSLocalizedString(@"stock_save", nil);
        } else {
            self.top_Lab.text = NSLocalizedString(@"stock_submit", nil);
        }
        
        self.bottom_Lab.text = NSLocalizedString(@"stock_order_detail", nil);
    }
    else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSave||self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
        self.title = NSLocalizedString(@"order_complete", nil);
        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
        self.top_Lab.text = NSLocalizedString(@"transfers_submit", nil);
        
        self.bottom_Lab.text = NSLocalizedString(@"transfers_order_detail", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"return_complete", nil);
        [self.top_Img setImage:ImageNamed(@"o_return_order_icon")];
        [self.bottom_Img setImage:ImageNamed(@"o_return_orderDetail_icon")];
        self.top_Lab.text =NSLocalizedString(@"return_complete_t", nil);
        self.bottom_Lab.text = NSLocalizedString(@"return_order_detail", nil);
    }
    
}

- (void)configBaseData
{
    self.bottom_Lab.userInteractionEnabled = YES;
    self.bottom_Img.userInteractionEnabled = YES;
    [self.bottom_Lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)]];
    [self.bottom_Img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)]];
}


- (void)selectAction
{
//    [[NSToastManager manager] showtoast:@"跳转详情"];
    if (self.controllerType == OrderOperationSuccessVCTypeReturn) {
        
        ReturnOrderDetailVC *returnOrderDetailVC = [[ReturnOrderDetailVC alloc] init];
        returnOrderDetailVC.orderID = self.orderID;
        [self.navigationController pushViewController:returnOrderDetailVC animated:YES];
    } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {
        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
        orderDetailVC.orderID = self.orderID;
        orderDetailVC.controllerType = PurchaseOrderManageVCTypeSTOCK;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
        orderDetailVC.orderID = self.orderID;
        orderDetailVC.controllerType = PurchaseOrderManageVCTypeAllocteOrder;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    else
    {
        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
        orderDetailVC.orderID = self.orderID;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    
}

@end
