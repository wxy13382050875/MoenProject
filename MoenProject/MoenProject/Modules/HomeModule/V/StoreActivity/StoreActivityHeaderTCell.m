//
//  StoreActivityHeaderTCell.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/3.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "StoreActivityHeaderTCell.h"
@interface StoreActivityHeaderTCell()

@property (weak, nonatomic) IBOutlet UILabel *name_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *name_Lab;


@property (weak, nonatomic) IBOutlet UILabel *start_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *time_Lab;


@property (weak, nonatomic) IBOutlet UILabel *end_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *endTime_Lab;

@property (weak, nonatomic) IBOutlet UILabel *des_Title_Lab;
@property (weak, nonatomic) IBOutlet UILabel *des_Lab;



@end


@implementation StoreActivityHeaderTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.name_Title_Lab.font = FONTLanTingR(14);
    self.name_Lab.font = FONTLanTingR(14);
    
    self.start_Title_Lab.font = FONTLanTingR(14);
    self.time_Lab.font = FontBinB(14);
    
    self.end_Title_Lab.font = FONTLanTingR(14);
    self.endTime_Lab.font = FontBinB(14);
    
    self.des_Title_Lab.font = FONTLanTingR(14);
    self.des_Lab.font = FONTLanTingR(14);
}

- (void)showDataWtihStoreActivityDetailModel:(StoreActivityDetailModel *)model
{
    self.name_Lab.text = model.promoName;
    self.time_Lab.text = model.startTime;
    self.endTime_Lab.text = model.endTime;
    if (model.activityAbstract.length == 0) {
        [self.des_Title_Lab setHidden:YES];
         self.des_Lab.text = @"";
    }
    else
    {
        [self.des_Title_Lab setHidden:NO];
         self.des_Lab.text = model.activityAbstract;
    }
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
