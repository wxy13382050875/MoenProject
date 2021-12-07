//
//  WelcomeVC.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import <UIKit/UIKit.h>

typedef void(^WelcomeCompletionBlock)(UIAlertController *alertController);

@interface WelcomeVC : BaseViewController

@property (nonatomic,copy) WelcomeCompletionBlock completionBlock;
@end
