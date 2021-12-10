//
//  XwOrderDetailDeliveryCell.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/9.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "XwOrderDetailDeliveryCell.h"
@interface XwOrderDetailDeliveryCell ()
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *stateLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *deliverynameLabel;
@property (strong, nonatomic) UILabel *voucherLabel;
@end
@implementation XwOrderDetailDeliveryCell
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
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.tagLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.deliverynameLabel];
    [self.contentView addSubview:self.voucherLabel];
}
-(void)xw_updateConstraints{
    self.dateLabel.sd_layout.leftSpaceToView(self.contentView, 15).topEqualToView(self.contentView).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    self.stateLabel.sd_layout.topEqualToView(self.contentView).rightSpaceToView(self.contentView, 15).leftSpaceToView(self.dateLabel, 5).heightIs(30);
    self.tagLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.dateLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.numberLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.tagLabel, 5).rightSpaceToView(self.contentView, 15).heightIs(30);
    self.deliverynameLabel.sd_layout.leftSpaceToView(self.contentView, 15).topSpaceToView(self.numberLabel, 5).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    self.voucherLabel.sd_layout.topSpaceToView(self.numberLabel, 5).rightSpaceToView(self.contentView, 15).widthIs((SCREEN_WIDTH-30)/2).heightIs(30);
    
    
}
-(void)setModel:(XwOrderDetailModel *)model{
    self.dateLabel.text = model.sendOrderTime;
    self.stateLabel.text = model.orderStatusText;
    self.tagLabel.text = [NSString stringWithFormat:@"业务标识:%@",model.businessMark];
    self.numberLabel.text =[NSString stringWithFormat:@"发货单编号:%@",model.sendOrderID];
    
    self.deliverynameLabel.text =[NSString stringWithFormat:@"发货方:%@",model.sender];
    self.voucherLabel.text =[NSString stringWithFormat:@"制单人:%@",model.orderCreater];
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
