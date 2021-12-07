//
//  ReturnGoodsCounterConfigTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/17.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "ReturnGoodsCounterConfigTCell.h"

@interface ReturnGoodsCounterConfigTCell ()

@property (weak, nonatomic) IBOutlet UILabel *pickup_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *piceUp_Type_Lab;
@property (weak, nonatomic) IBOutlet UIView *pickUp_Type_View;


@property (weak, nonatomic) IBOutlet UILabel *return_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *return_Type_Lab;
@property (weak, nonatomic) IBOutlet UIView *return_Type_View;



@property (weak, nonatomic) IBOutlet UILabel *return_reason_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *return_Reason_Lab;
@property (weak, nonatomic) IBOutlet UIView *return_Reason_Type_View;


@end

@implementation ReturnGoodsCounterConfigTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickup_Title_Lab.font = FONTLanTingR(14);
    self.piceUp_Type_Lab.font = FONTLanTingR(14);
    self.return_Title_Lab.font = FONTLanTingR(14);
    self.return_Type_Lab.font = FONTLanTingR(14);
    self.return_reason_Title_Lab.font = FONTLanTingR(14);
    self.return_Reason_Lab.font = FONTLanTingR(14);
    
    
    
    self.pickUp_Type_View.userInteractionEnabled = YES;
    [self.pickUp_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPickUpTypeAction)]];
    
    self.return_Type_View.userInteractionEnabled = YES;
    [self.return_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectReturnTypeAction)]];
    
    self.return_Reason_Type_View.userInteractionEnabled = YES;
    [self.return_Reason_Type_View addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectReturnSeasonAction)]];
}


- (void)showDataWithReturnOrderCounterModel:(ReturnOrderCounterModel *)model
{
    if (model.pickUpStatus.length) {
        self.piceUp_Type_Lab.text = model.pickUpStatus;
    }
    else
    {
        self.piceUp_Type_Lab.text = @"请选择提货方式";
    }
    
    if (model.returnMethod.length) {
        self.return_Type_Lab.text = model.returnMethod;
    }
    else
    {
        self.return_Type_Lab.text = @"请选择退款方式";
    }
    
    if (model.returnReason.length) {
        self.return_Reason_Lab.text = model.returnReason;
    }
    else
    {
        self.return_Reason_Lab.text = @"请选择退货原因";
    }
}


- (void)showDataWithReturnOrderInfoModel:(ReturnOrderInfoModel *)model
{
    if (model.pickUpStatus.length) {
        self.piceUp_Type_Lab.text = model.pickUpStatus;
    }
    else
    {
        self.piceUp_Type_Lab.text = @"请选择提货方式";
    }
    
    if (model.returnMethod.length) {
        self.return_Type_Lab.text = model.returnMethod;
    }
    else
    {
        self.return_Type_Lab.text = @"请选择退款方式";
    }
    
    if (model.returnReason.length) {
        self.return_Reason_Lab.text = model.returnReason;
    }
    else
    {
        self.return_Reason_Lab.text = @"请选择退货原因";
    }
}

- (void)selectPickUpTypeAction
{
    if (self.configTCellSelectBlock) {
        self.configTCellSelectBlock(ReturnGoodsSelectTypePickUp);
    }
}
- (void)selectReturnTypeAction
{
    if (self.configTCellSelectBlock) {
        self.configTCellSelectBlock(ReturnGoodsSelectTypeReturnType);
    }
}
- (void)selectReturnSeasonAction
{
    if (self.configTCellSelectBlock) {
        self.configTCellSelectBlock(ReturnGoodsSelectTypeReturnSeason);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
