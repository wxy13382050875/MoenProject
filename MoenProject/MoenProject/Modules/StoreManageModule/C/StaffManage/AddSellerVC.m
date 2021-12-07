//
//  AddSellerVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddSellerVC.h"
#import "FDAlertView.h"

@interface AddSellerVC ()<UITextFieldDelegate, FDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *duties_Txt;

@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UITextField *name_Txt;


@end

@implementation AddSellerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}



- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"添加导购账号";
    
    self.phone_Txt.delegate = self;
    self.duties_Txt.delegate = self;
    self.name_Txt.delegate = self;
}

- (void)configBaseData
{
    
}




- (IBAction)addBtnAction:(id)sender {
    
    NSString *noticeStr = @"";
    if (self.phone_Txt.text.length == 0) {
        noticeStr = @"请输入手机号";
    }
    else if (![Utils checkTelNumber:self.phone_Txt.text]) {
        noticeStr = @"手机号格式不正确";
    }
    else if (self.name_Txt.text.length == 0) {
        noticeStr = @"请输入姓名";
    }
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
    }else{
        
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否确认添加该员工？ 添加后不可修改" delegate:self buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil), nil];
        [alert show];
        
        
    }
}

- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        [self httpPath_addPersonal];
    }
}

#pragma Mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_Txt) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_addPersonal]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_addPersonal]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                
            }
            
        }
    }
}

/**新增导购Api*/
- (void)httpPath_addPersonal
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.phone_Txt.text forKey:@"phone"];
    [parameters setValue:self.name_Txt.text forKey:@"name"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_addPersonal;
}


@end
