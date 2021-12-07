//
//  UITabBarController+AddChildController.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/8.
//

#import <UIKit/UIKit.h>

/**
 *  UITabBarController的分类 用于自定义TabBar
 */
@interface UITabBarController (AddChildController)

- (void)setupContentControllers;

- (void)addChildViewController:(UIViewController *)childCtrl imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName title:(NSString *)title;


@end
