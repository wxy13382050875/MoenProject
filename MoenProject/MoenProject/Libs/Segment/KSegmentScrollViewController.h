//
//  KSegmentScrollViewController.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/19.
//

#import <UIKit/UIKit.h>

@interface KSegmentScrollViewController : BaseViewController

- (instancetype)initWithControllers:(NSArray *)controllers
                              frame:(CGRect)frame
                         menuHeight:(CGFloat)menuHeight
                             titles:(NSArray *)titles
                          titleFont:(UIFont *)titleFont
                      selectedColor:(UIColor *)selectedColor
                        normalColor:(UIColor *)normalColor
                          lineColor:(UIColor *)lineColor
                      selectedIndex:(NSInteger)selectdIndex;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

@property (nonatomic ,copy) void (^selectedActionBlock) (NSInteger seletedIndex);

@end
