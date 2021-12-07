//
//  xwStoreOrderGoodsCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/2.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xwStoreOrderGoodsCell.h"
@interface xwStoreOrderGoodsCell ()<NumberCalculateDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet NumberCalculate *numberCalculate;

@property (weak, nonatomic) IBOutlet UIView *orderBg;
@property (weak, nonatomic) IBOutlet UILabel *markupLabel;
@property (weak, nonatomic) IBOutlet UILabel *PUNoLabel;

@property (weak, nonatomic) IBOutlet UIView *returnBg;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@end
@implementation xwStoreOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberCalculate.delegate=self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setOrderType:(OrderActionType)orderType{
    if (orderType == OrderActionTypeOrder) {
        self.orderBg.hidden = NO;
        self.returnBg.hidden = YES;
    } else {
        self.orderBg.hidden = YES;
        self.returnBg.hidden = NO;
    }
}
- (void)resultNumber:(NSInteger)number{
    NSLog(@"%ld>>>resultDelegate>>",number);
}
@end
