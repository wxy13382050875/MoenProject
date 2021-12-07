//
//  KWConditionSelectView.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/31.
//

#import <UIKit/UIKit.h>

@interface KWCSVDataModel:MoenBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *minValue;

@property (nonatomic, copy) NSString *maxValue;

@property (nonatomic, assign) NSInteger statusValue;

@property (nonatomic, assign) BOOL isSelected;


@end


typedef void(^KWConditionSelectViewActionBlock)(KWCSVDataModel *model, NSInteger type);

/**条件选择 View*/
@interface KWConditionSelectView : UIView

- (instancetype)initWithMarginTop:(CGFloat)marginTop;

- (void)showWithArray:(NSMutableArray *)dataArr WithActionBlock:(KWConditionSelectViewActionBlock)actionBlock;

- (void)dismiss;
@end
