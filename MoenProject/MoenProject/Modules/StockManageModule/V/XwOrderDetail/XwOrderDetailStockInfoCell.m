//
//  XwOrderDetailStockInfoCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailStockInfoCell.h"
@interface XwOrderDetailStockInfoCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIImageView *arrowImg;
@end
@implementation XwOrderDetailStockInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self xw_setupUI];
        [self xw_updateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)xw_setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.arrowImg];
}
-(void)xw_updateConstraints{
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.numberLabel.sd_layout.topSpaceToView(self.titleLabel, 5).rightSpaceToView(self.contentView, 15).leftSpaceToView(self.contentView, 15).heightIs(30);
    self.dateLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.numberLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.arrowImg.sd_layout.rightSpaceToView(self.contentView, 5).centerYEqualToView(self.contentView).widthIs(10).heightIs(15);
    
}
-(void)setModel:(XwOrderDetailModel *)model{
    if([model.progressName isEqualToString:@"总仓任务进度"]){
        self.titleLabel.text = @"订单信息";
        self.numberLabel.text =[NSString stringWithFormat:@"%@编号:%@",@"订单",model.orderCode];
    } else if([model.progressName isEqualToString:@"总仓发货"]){
        self.titleLabel.text = @"总仓发货信息";
        self.numberLabel.text =[NSString stringWithFormat:@"%@编号:%@",@"任务",model.orderCode];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@信息",model.progressName];;
        self.numberLabel.text =[NSString stringWithFormat:@"%@编号:%@",model.progressName,model.orderCode];
    }
//    if([model.progressName isEqualToString:@"订单"]||
//       [model.progressName isEqualToString:@"总仓任务进度"]){
//        self.arrowImg.hidden = NO;
//    } else {
//        self.arrowImg.hidden = YES;
//    }
        
    
  
    if([model.progressName isEqualToString:@"进货单"]){
        self.dateLabel.text =[NSString stringWithFormat:@"下单时间:%@",model.sendOrderTime];
    } else {
        self.dateLabel.text =[NSString stringWithFormat:@"下单时间:%@",model.orderTime];
    }
    
    
}
-(UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}
-(UILabel*)numberLabel{
    if(!_numberLabel){
        _numberLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _numberLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _numberLabel;
}
-(UILabel*)dateLabel{
    if(!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _dateLabel;
}

-(UIImageView*)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [UIImageView new];
        _arrowImg.image =[UIImage imageNamed:@"c_detail_right_icon"];
    }
    return _arrowImg;
}
@end
