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
    orderManageVC.title = [[self.titleArr objectAtIndex:0] objectForKey:@"titleName"];
    orderManageVC.controllerType = [[[self.titleArr objectAtIndex:0] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC];
    [titles addObject:[[self.titleArr objectAtIndex:0] objectForKey:@"titleName"]];
    
    PurchaseOrderManageVC *orderManageVC1 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC1.title = [[self.titleArr objectAtIndex:1] objectForKey:@"titleName"];
    orderManageVC1.controllerType = [[[self.titleArr objectAtIndex:1] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC1];
    [titles addObject:[[self.titleArr objectAtIndex:1] objectForKey:@"titleName"]];
    
    PurchaseOrderManageVC *orderManageVC2 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC2.title = [[self.titleArr objectAtIndex:2] objectForKey:@"titleName"];
    orderManageVC2.controllerType = [[[self.titleArr objectAtIndex:2] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC2];
    [titles addObject:[[self.titleArr objectAtIndex:2] objectForKey:@"titleName"]];
    
    PurchaseOrderManageVC *orderManageVC3 = [[PurchaseOrderManageVC alloc] init];
    orderManageVC3.title = [[self.titleArr objectAtIndex:3] objectForKey:@"titleName"];
    orderManageVC3.controllerType = [[[self.titleArr objectAtIndex:3] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC3];
    [titles addObject:[[self.titleArr objectAtIndex:3] objectForKey:@"titleName"]];
    
    KSegmentScrollViewController *controller = [[KSegmentScrollViewController alloc] initWithControllers:controllers frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) menuHeight:45 titles:titles titleFont:[UIFont systemFontOfSize:15] selectedColor:AppTitleBlackColor normalColor:AppTitleBlackColor lineColor:AppTitleBlackColor selectedIndex:self.initIndex];
    
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
