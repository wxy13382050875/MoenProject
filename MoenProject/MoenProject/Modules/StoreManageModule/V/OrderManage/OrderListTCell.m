//
//  OrderListTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/9.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderListTCell.h"
@interface OrderListTCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollview;

@end

@implementation OrderListTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configScrollview];
    // Initialization code
}

- (void)configScrollview
{
    /**添加ScrollView*/
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH, 115)];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.backgroundColor = UIColorFromRGB(0xFBFAFA);
    
//    self.scrollView.contentSize = CGSizeMake(totalWidth, CGRectGetHeight(self.scrollView.frame));
    self.scrollview.delegate = self;
    
    
    [self addSubview:self.scrollview];
    
    
    self.scrollview.userInteractionEnabled = NO;//关闭scrollView的用户交互
    [self.contentView addGestureRecognizer:self.scrollview.panGestureRecognizer];
    
}
-(void)setExchangeModel:(ExchangeGoodsModel *)exchangeModel{
    [self.scrollview removeAllSubviews];
    CGFloat contentWidth = 15;
    for (GoodslistModel *goodsModel in exchangeModel.goodsList) {
        UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 14, 88, 88)];
        [goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
        [self.scrollview addSubview:goodsImg];
        contentWidth += 98;
    }
    self.scrollview.contentSize = CGSizeMake(contentWidth, 115);
}

- (void)showDataWithOrderManageModel:(OrderManageModel *)model
{
    [self.scrollview removeAllSubviews];
    CGFloat contentWidth = 15;
    for (OrderItemInfoModel *goodsModel in model.orderItemInfos) {
        UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 14, 88, 88)];
        [goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
        [self.scrollview addSubview:goodsImg];
        contentWidth += 98;
    }
    self.scrollview.contentSize = CGSizeMake(contentWidth, 115);
}

- (void)showDataWithOrderManageModelForReturnGoodsManage:(OrderManageModel *)model
{
    [self.scrollview removeAllSubviews];
    CGFloat contentWidth = 15;
    for (OrderItemInfoModel *goodsModel in model.productList) {
        UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 14, 88, 88)];
        [goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.photo] placeholderImage:ImageNamed(@"defaultImage")];
        [self.scrollview addSubview:goodsImg];
        contentWidth += 98;
    }
    self.scrollview.contentSize = CGSizeMake(contentWidth, 115);
}

-(void)setModel:(Orderlist *)model{
    [self.scrollview removeAllSubviews];
    CGFloat contentWidth = 15;
    for (Goodslist *goodsModel in model.goodsList) {
        UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(contentWidth, 14, 88, 88)];
        [goodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsIMG] placeholderImage:ImageNamed(@"defaultImage")];
        [self.scrollview addSubview:goodsImg];
        contentWidth += 98;
    }
    self.scrollview.contentSize = CGSizeMake(contentWidth, 115);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//
//{
//
//    albumTableViewCell * cell = self.superview;
//
//    [cell touchesBegan:touches withEvent:event];
//
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//
//{
//
//    albumTableViewCell * cell = self.superview;
//
//    [cell touchesEnded:touches withEvent:event];
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
