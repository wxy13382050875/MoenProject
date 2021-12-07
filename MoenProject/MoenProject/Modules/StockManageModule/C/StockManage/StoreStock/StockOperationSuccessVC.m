//
//  StockOperationSuccessVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/7.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "StockOperationSuccessVC.h"

@interface StockOperationSuccessVC ()
@property (strong, nonatomic)  UILabel *tip_Lab;

@property (strong, nonatomic)  UILabel *operation_Lab;

@property (strong, nonatomic)  UILabel *doneTime_Lab;
@end

@implementation StockOperationSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configBaseUI];
    [self configBaseData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    self.title = @"盘库提交";
    [self.view addSubview:self.tip_Lab];
    [self.view addSubview:self.operation_Lab];
    [self.view addSubview:self.doneTime_Lab];
    self.tip_Lab.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.view, 80).heightIs(60);
    self.operation_Lab.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.tip_Lab, 10).heightIs(40);
    self.doneTime_Lab.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.operation_Lab, 5).heightIs(40);
    if([self.dict[@"operateType"] isEqualToString:@"save"] ){
        
        self.tip_Lab.text =@"本次盘库已保存！";
    } else {
        self.tip_Lab.text =@"本次盘库结果已提交，待AD进行审核!";
    }
    self.operation_Lab.text = [NSString stringWithFormat:@"操作人:%@",self.dict[@"operator"]];
    self.doneTime_Lab.text = [NSString stringWithFormat:@"完成时间:%@",self.dict[@"operateTime"]];
}

- (void)configBaseData
{
}
-(UILabel*)tip_Lab{
    if(!_tip_Lab){
        _tip_Lab =[UILabel labelWithText:@"" WithTextColor:[UIColor blackColor] WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentCenter WithFont:17];
    }
    return _tip_Lab;
}
-(UILabel*)operation_Lab{
    if(!_operation_Lab){
        _operation_Lab =[UILabel labelWithText:@"" WithTextColor:[UIColor grayColor] WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentCenter WithFont:13];
    }
    return _operation_Lab;
}
-(UILabel*)doneTime_Lab{
    if(!_doneTime_Lab){
        _doneTime_Lab =[UILabel labelWithText:@"" WithTextColor:[UIColor grayColor] WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentCenter WithFont:13];
    }
    return _doneTime_Lab;
}
@end
