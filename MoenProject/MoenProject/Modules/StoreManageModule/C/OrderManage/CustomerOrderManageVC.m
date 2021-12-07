//
//  CustomerOrderManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "CustomerOrderManageVC.h"
#import "KSegmentScrollViewController.h"
#import "OrderManageVC.h"

@interface CustomerOrderManageVC ()

@property (nonatomic, strong) KSegmentScrollViewController *scrollViewController;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, assign) BOOL isClickBack;

@end

@implementation CustomerOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"order_list", nil);
    [self setupMenuController];
}

- (void)configBaseData
{
    
    
}

- (void)setupMenuController
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    OrderManageVC *orderManageVC = [[OrderManageVC alloc] init];
    orderManageVC.title = [[self.titleArr objectAtIndex:0] objectForKey:@"titleName"];
    orderManageVC.controllerType = [[[self.titleArr objectAtIndex:0] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC];
    [titles addObject:[[self.titleArr objectAtIndex:0] objectForKey:@"titleName"]];
    
    OrderManageVC *orderManageVC1 = [[OrderManageVC alloc] init];
    orderManageVC1.title = [[self.titleArr objectAtIndex:1] objectForKey:@"titleName"];
    orderManageVC1.controllerType = [[[self.titleArr objectAtIndex:1] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:orderManageVC1];
    [titles addObject:[[self.titleArr objectAtIndex:1] objectForKey:@"titleName"]];
    
    
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
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"professional_order", nil),@"titleName",[NSNumber numberWithInteger:OrderManageVCTypeMAJOR],@"controllerType", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"recommend_order", nil),@"titleName",[NSNumber numberWithInteger:OrderManageVCTypeGROOM],@"controllerType", nil],
                     nil];
    }
    return _titleArr;
}

@end
