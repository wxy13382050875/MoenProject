//
//  PhotoDisplayView.h
//  NewHaoXiaDan
//
//  Created by 鞠鹏 on 2017/9/16.
//  Copyright © 2017年 YouZheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDisplayView : UIView

@property (nonatomic,strong) NSArray *phtotoArray;

/*从0开始*/
@property (nonatomic,assign) NSInteger selectIndex;

@end
