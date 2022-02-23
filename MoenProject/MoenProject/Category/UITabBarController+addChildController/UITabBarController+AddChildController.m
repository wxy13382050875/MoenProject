//
//  UITabBarController+AddChildController.m
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/8.
//

#import "UITabBarController+AddChildController.h"

#import "HomePageVC.h"
#import "StoreManageVC.h"
#import "StatisticsVC.h"
#import "MineVC.h"
#import "StockManageVC.h"


@implementation UITabBarController (AddChildController)

- (void)setupContentControllers{
    
    //首页
    HomePageVC *homeViewController = [[HomePageVC alloc] init];
    [self addChildViewController:homeViewController imageName:@"tb_home_icon" selectedImageName:@"tb_home_hl_icon" title:NSLocalizedString(@"home",nil)];
    
    //理财
    StoreManageVC *storeManageVC = [[StoreManageVC alloc] init];
    [self addChildViewController:storeManageVC imageName:@"tb_store_icon" selectedImageName:@"tb_store_hl_icon" title:NSLocalizedString(@"storeManage",nil)];
    
    //我的
    StatisticsVC *statisticsVC = [[StatisticsVC alloc] init];
    [self addChildViewController:statisticsVC imageName:@"tb_statistics_icon" selectedImageName:@"tb_statistice_hl_icon" title:NSLocalizedString(@"statistics",nil)];
    
    if ([QZLUserConfig sharedInstance].useInventory){
        StockManageVC *stockManageVC = [[StockManageVC alloc] init];
        [self addChildViewController:stockManageVC imageName:@"tb_store_icon" selectedImageName:@"tb_store_hl_icon" title:NSLocalizedString(@"stock_manage",nil)];
    }
    
    
    
    //我的
    MineVC *mineVC = [[MineVC alloc] init];
    [self addChildViewController:mineVC imageName:@"tb_mine_icon" selectedImageName:@"tb_mine_hl_icon" title:NSLocalizedString(@"mine",nil)];
    
    
    self.selectedIndex = 0;
}




- (void)addChildViewController:(UIViewController *)childCtrl imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title{
    
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    UIImage *unSelectedImage = [UIImage imageNamed:imageName];
    childCtrl.title = title;
    childCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                         image:[unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                 selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : AppTabBarTitleSelected} forState:UIControlStateSelected];
//    [childCtrl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : AppWhiteColor} forState:UIControlStateNormal];
    childCtrl.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childCtrl];
    [self addChildViewController:nav];
}

@end
