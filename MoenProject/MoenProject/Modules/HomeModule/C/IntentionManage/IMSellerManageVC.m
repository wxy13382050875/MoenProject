//
//  IMSellerManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/26.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "IMSellerManageVC.h"
#import "KSegmentScrollViewController.h"
#import "IntentionManageVC.h"
#import "IntentionUnregisterVC.h"

@interface IMSellerManageVC ()
@property (nonatomic, strong) KSegmentScrollViewController *scrollViewController;

@property (nonatomic, strong) NSMutableArray *titleArr;

@property (nonatomic, assign) BOOL isClickBack;

@end

@implementation IMSellerManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"意向管理";
    [self setupMenuController];
}

- (void)configBaseData
{
    
    
}

- (void)setupMenuController
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    IntentionManageVC *intentionManageVC = [[IntentionManageVC alloc] init];
    intentionManageVC.title = [[self.titleArr objectAtIndex:0] objectForKey:@"titleName"];
    intentionManageVC.controllerType = IntentionManageVCTypeWithHeader;
    [controllers addObject:intentionManageVC];
    [titles addObject:[[self.titleArr objectAtIndex:0] objectForKey:@"titleName"]];
    
    IntentionUnregisterVC *intentionUnregisterVC = [[IntentionUnregisterVC alloc] init];
    intentionUnregisterVC.title = [[self.titleArr objectAtIndex:1] objectForKey:@"titleName"];
    //    intentionCustomerVC.controllerType = [[[self.titleArr objectAtIndex:i] objectForKey:@"controllerType"] integerValue];
    [controllers addObject:intentionUnregisterVC];
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
                     [NSDictionary dictionaryWithObjectsAndKeys:@"意向客户",@"titleName",[NSNumber numberWithInt:@""],@"controllerType", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"未标记",@"titleName",[NSNumber numberWithInt:@""],@"controllerType", nil],
                     nil];
    }
    return _titleArr;
}

@end
