//
//  KSegmentMenuView.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/19.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MenuViewTitleAlinmentDefault = 0,
    MenuViewTitleAlinmentLeft = 1,//靠左
    MenuViewTitleAlinmentCenter //居中
} MenuViewTitleAlinment;

typedef void(^MenuViewSelectBlock)(NSInteger selectIndex);

@interface KSegmentMenuView : UIView

@property (nonatomic,assign) NSInteger selectedIndex;

// 1 居中
@property (nonatomic,assign) MenuViewTitleAlinment titleAliment;

@property (nonatomic,copy) MenuViewSelectBlock priceSelectedBlock;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    titleFont:(UIFont *)titleFont
                selectedColor:(UIColor *)selectedColor
                  normalColor:(UIColor *)normalColor
                    lineColor:(UIColor *)lineColor
                selectedIndex:(NSInteger)selectdIndex
                  selectBlock:(MenuViewSelectBlock)selectBlock;


- (void)setContentSizeWidthAdjust:(BOOL)yes;

@end
