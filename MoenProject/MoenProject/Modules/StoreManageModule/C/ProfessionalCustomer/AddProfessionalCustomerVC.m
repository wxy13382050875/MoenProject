//
//  AddProfessionalCustomerVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/28.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "AddProfessionalCustomerVC.h"
#import "KWCommonPickView.h"
#import "CommonCategoryModel.h"

@interface AddProfessionalCustomerVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *company_Txt;

@property (weak, nonatomic) IBOutlet UITextField *phone_Txt;
@property (weak, nonatomic) IBOutlet UITextField *name_Txt;
@property (weak, nonatomic) IBOutlet UITextField *identify_Txt;
@property (weak, nonatomic) IBOutlet UIButton *add_Btn;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, strong) KWCommonPickView *kwPickView;

@property (nonatomic, strong) NSMutableArray *pickUpDataArr;

/**按钮点击事件 阻尼*/
@property (nonatomic, assign) BOOL isDamping;

@end

@implementation AddProfessionalCustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    [self configBaseData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.kwPickView releasePickView];
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"添加专业客户";
    self.company_Txt.delegate = self;
    self.phone_Txt.delegate = self;
    self.name_Txt.delegate = self;
    self.identify_Txt.delegate = self;
    
}

- (void)configBaseData
{
    [self httpPath_load];
}

- (IBAction)addAction:(UIButton *)sender {
    if (self.isDamping) {
        return;
    }
    NSString *noticeStr = @"";
    if (self.company_Txt.text.length == 0) {
        noticeStr = @"请输入公司名称";
    }
    //备注格式错误
    else if ([Utils stringContainsEmoji:self.company_Txt.text]) {
        noticeStr = @"公司名称请勿包含表情";
    }
    else if (self.phone_Txt.text.length == 0) {
        noticeStr = @"请输入手机号";
    }
    else if (![Utils checkTelNumber:self.phone_Txt.text]) {
        noticeStr = @"手机号格式不正确";
    }
    else if (self.name_Txt.text.length == 0) {
        noticeStr = @"请输入姓名";
    }
    //备注格式错误
    else if ([Utils stringContainsEmoji:self.name_Txt.text]) {
        noticeStr = @"姓名请勿包含表情";
    }
    else if (self.identify_Txt.text.length == 0) {
        noticeStr = @"请选择身份";
    }
    
    if (noticeStr.length) {
        [[NSToastManager manager] showtoast:noticeStr];
    }else{
        self.isDamping = YES;
        [self httpPath_addCustomer];
    }
}


- (void)selectUserType
{
    [self.view endEditing:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (CommonCategoryDataModel *model in self.pickUpDataArr) {
        KWCPDataModel *model_1 = [[KWCPDataModel alloc] init];
        model_1.titleName = model.des;
        model_1.ID = model.ID;
        [arr addObject:model_1];
    }
    if (arr.count == 0) {
        [[NSToastManager manager] showtoast:@"数据为空"];
    }
    else
    {
        WEAKSELF
        [self.kwPickView showWithDataArray:arr WithConfirmBlock:^(KWCPDataModel *model) {
            weakSelf.identify_Txt.text = model.titleName;
            weakSelf.userType = model.ID;
        }];
    }
    
}


#pragma Mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.name_Txt) {
        textField.text = [textField.text noEmoji];
    }
    if (textField == self.company_Txt) {
        textField.text = [textField.text noEmoji];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.identify_Txt) {
        [self selectUserType];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone_Txt) {
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    if (textField == self.name_Txt) {
        if (textField.text.length >= 10 && ![string isEqualToString:@""]) {
            return NO;
        }
        if ([Utils stringContainsEmojiE:string]) {
            [[NSToastManager manager] showtoast:@"请不要输入表情！"];
            return NO;
        }
    }
    if (textField == self.company_Txt) {
        if (textField.text.length >= 20 && ![string isEqualToString:@""]) {
            return NO;
        }
        if ([Utils stringContainsEmojiE:string]) {
            [[NSToastManager manager] showtoast:@"请不要输入表情！"];
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
        if ([operation.urlTag isEqualToString:Path_addCustomer]) {
            self.isDamping = NO;
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_addCustomer]) {
                MoenBaseModel *model = (MoenBaseModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [[NSToastManager manager] showtoast:@"添加成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                self.isDamping = NO;
            }
            if ([operation.urlTag isEqualToString:Path_load]) {
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"SpecialtyType"]) {
                        [self.pickUpDataArr removeAllObjects];
                        [self.pickUpDataArr addObjectsFromArray:itemModel.datas];
                    }
                }
            }
        }
    }
}

/**新增专业客户Api*/
- (void)httpPath_addCustomer
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.phone_Txt.text forKey:@"custCode"];
    [parameters setValue:self.name_Txt.text forKey:@"custName"];
    [parameters setValue:self.company_Txt.text forKey:@"companyName"];
    [parameters setValue:[NSDictionary dictionaryWithObject:self.userType forKey:@"id"] forKey:@"career"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showmodalityprogress];
    self.requestURL = Path_addCustomer;
}

/**获取下拉数据Api*/
- (void)httpPath_load
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_load;
}


#pragma mark -- Getter&Setter
- (KWCommonPickView *)kwPickView
{
    if (!_kwPickView) {
        _kwPickView = [[KWCommonPickView alloc] initWithType:1];
    }
    return _kwPickView;
}

- (NSMutableArray *)pickUpDataArr
{
    if (!_pickUpDataArr) {
        _pickUpDataArr = [[NSMutableArray alloc] init];
    }
    return _pickUpDataArr;
}

@end
