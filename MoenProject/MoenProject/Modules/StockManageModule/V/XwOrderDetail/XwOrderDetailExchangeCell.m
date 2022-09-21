//
//  XwOrderDetailExchangeCell.m
//  MoenProject
//
//  Created by 武新义 on 2022/8/28.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailExchangeCell.h"

@interface XwOrderDetailExchangeCell ()
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *deliverynameLabel;
@property (strong, nonatomic) UILabel *voucherLabel;
@end
@implementation XwOrderDetailExchangeCell
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
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.deliverynameLabel];
    [self.contentView addSubview:self.voucherLabel];
}
-(void)xw_updateConstraints{
    self.dateLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.tagLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.dateLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.numberLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.tagLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.deliverynameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.numberLabel, 5).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    self.voucherLabel.sd_layout.topSpaceToView(self.numberLabel, 5).rightSpaceToView(self.contentView, 15).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    
    
}
-(void)setModel:(XwOrderDetailModel *)model{
    self.dateLabel.text = model.orderTime;
    self.stateLabel.text = model.orderStatusText;
    self.tagLabel.text = [NSString stringWithFormat:@"换货单编号:%@",model.orderID];
    self.numberLabel.text =[NSString stringWithFormat:@"订单编号:%@",model.orderCode];
  
    self.deliverynameLabel.text =[NSString stringWithFormat:@"制单人：%@",model.createUser];
    self.voucherLabel.text =[NSString stringWithFormat:@"客户：%@",model.customer];
}
-(UILabel*)dateLabel{
    if(!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _dateLabel;
}
-(UILabel*)stateLabel{
    if(!_stateLabel){
        _stateLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _stateLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _stateLabel;
}
-(UILabel*)tagLabel{
    if(!_tagLabel){
        _tagLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _tagLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _tagLabel;
}
-(UILabel*)numberLabel{
    if(!_numberLabel){
        _numberLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _numberLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _numberLabel;
}
-(UILabel*)deliverynameLabel{
    if(!_deliverynameLabel){
        _deliverynameLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        _deliverynameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _deliverynameLabel;
}
-(UILabel*)voucherLabel{
    if(!_voucherLabel){
        _voucherLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#646464") WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentRight WithFont:14];
        _voucherLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _voucherLabel;
}
@end
