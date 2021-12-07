//
//  KWCommonPickView.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/10/30.
//

#import <UIKit/UIKit.h>

@interface KWCPDataModel:MoenBaseModel

@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) NSString *extra_1;

@property (nonatomic, copy) NSString *extra_2;

@property (nonatomic, copy) NSString *extra_3;

@property (nonatomic, copy) NSString *ID;


@end

typedef void(^ConfirmBlock)(KWCPDataModel *model);

@interface KWCommonPickView : UIView

- (instancetype)initWithType:(NSInteger)type;

- (void)showWithDataArray:(NSArray *)dataArr WithConfirmBlock:(ConfirmBlock)confirmBlock;

- (void)releasePickView;

@end
