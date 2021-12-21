//
//  InvoiceOrderManageVC.m
//  MoenProject
//
//  Created by 王渊浩 on 2021/8/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "InvoiceOrderManageVC.h"
#import "PurchaseOrderManageVC.h"
#import "KSegmentScrollViewController.h"

@interface InvoiceOrderManageVC ()

@property (nonatomic, strong) KSegmentScrollViewController *scrollViewController;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, assign) BOOL isClickBack;

@end

@implementation InvoiceOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configBaseUI];
    
    [self configBaseData];
}


- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"发货单管理";
    [self setupMenuController];
}

- (void)configBaseData
{
    
    
}

- (void)setupMenuController
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    
    
    PurchaseOrderManageVC *orderManageVC = [[PurchaseOrderManageVC alloc] init];
    orderManageVC.title = NSLocalizedString(@"purchase_apply", nil);
    orderManageVC.controllerType = PurchaseOrderManageVCTypeDeliveryOrder;
    [controllers addObject:orderManageVC];
    [titles addObject:NSLocalizedString(@"purchase_apply", nil)];
    
    PurchaseOrderManageVC *orderManageVC1 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC1.title = NSLocalizedString(@"stocker_apply", nil);
    orderManageVC1.controllerType = PurchaseOrderManageVCTypeDeliveryStocker;
    [controllers addObject:orderManageVC1];
    [titles addObject:NSLocalizedString(@"stocker_apply", nil)];
    
    PurchaseOrderManageVC *orderManageVC2 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC2.title = NSLocalizedString(@"allocate_apply", nil);
    orderManageVC2.controllerType = PurchaseOrderManageVCTypeDeliveryApply;
    [controllers addObject:orderManageVC2];
    [titles addObject:NSLocalizedString(@"allocate_apply", nil)];
    
    PurchaseOrderManageVC *orderManageVC3 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC3.title = NSLocalizedString(@"store_self_apply", nil);
    orderManageVC3.controllerType = PurchaseOrderManageVCTypeDeliveryShopSelf;
    [controllers addObject:orderManageVC3];
    [titles addObject:NSLocalizedString(@"store_self_apply", nil)];
    
    KSegmentScrollViewController *controller = [[KSegmentScrollViewController alloc] initWithControllers:controllers frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) menuHeight:45 titles:titles titleFont:[UIFont systemFontOfSize:15] selectedColor:AppTitleBlackColor normalColor:AppTitleBlackColor lineColor:AppTitleBlackColor selectedIndex:self.initIndex];
    
    controller.selectedActionBlock = ^(NSInteger selectedIndex){
    };
    
    self.scrollViewController = controller;
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    [self.scrollViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    [self skipToViewControllerAtIndex:self.initIndex];
}

- (void)skipToViewControllerAtIndex:(NSInteger)index
{
    [self.scrollViewController setSelectedIndex:index];
    
}



#pragma mark -- Getter

- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSMutableArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"purchase_apply", nil),@"titleName",[NSNumber numberWithInteger:PurchaseOrderManageVCTypeDeliveryOrder],@"controllerType", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"stocker_apply", nil),@"titleName",[NSNumber numberWithInteger:PurchaseOrderManageVCTypeDeliveryStocker],@"controllerType", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"allocate_apply", nil),@"titleName",[NSNumber numberWithInteger:PurchaseOrderManageVCTypeDeliveryApply],@"controllerType", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"store_self_apply", nil),@"titleName",[NSNumber numberWithInteger:PurchaseOrderManageVCTypeDeliveryShopSelf],@"controllerType", nil],
                     
                     nil];
        
    }
    return _titleArr;
}

@end
