//
//  UserIdentifyVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/11/29.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "UserIdentifyVC.h"
#import "CommonSearchView.h"
#import "UserIdentifySuccessVC.h"
#import "MembershipInfoModel.h"
#import "SellGoodsScanVC.h"
#import "ReturnGoodsVC.h"
#import "FDAlertView.h"
#import "CustomerRegistVC.h"

@interface UserIdentifyVC ()<SearchViewCompleteDelete, FDAlertViewDelegate>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, copy) NSString *phoneNumber;


/** 规避连点错误 设置阻尼
 *  是否在阻断状态
 */
@property (nonatomic, assign) BOOL isNowDamping;
@end

@implementation UserIdentifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
    [self configBaseData];
}
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = NSLocalizedString(@"customer_identification", nil);
    [self.view addSubview:self.searchView];
}

- (void)configBaseData
{
    
}



#pragma  mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    if (!self.isNowDamping) {
        if (keyStr.length == 0) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"t_please_enter_phone_number", nil)];
            return;
        }
        if (![Utils checkTelNumber:keyStr]) {
            [[NSToastManager manager] showtoast:NSLocalizedString(@"t_incorrect_format_phone", nil)];
            return;
        }
        self.isNowDamping = YES;
        self.phoneNumber = keyStr;
        [self httpPath_getCustomerWithPhoneNumber:keyStr];
    }
}


- (void)skipToSellGoodsScanVCWithModel:(MembershipInfoModel *)model
{
    if (self.controllerType == UserIdentifyVCTypeSaleGoods) {
        SellGoodsScanVC *sellGoodsScanVC = [[SellGoodsScanVC alloc] init];
        sellGoodsScanVC.customerId = model.customerId;
        sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
    }
    else
    {
        ReturnGoodsVC *returnGoodsVC = [[ReturnGoodsVC alloc] init];
        returnGoodsVC.customerId = model.customerId;
        returnGoodsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:returnGoodsVC animated:YES];
    }
    
}

#pragma mark -- FDAlertViewDelegate
- (void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex WithInputStr:(NSString *)inputStr {
    NSLog(@"%ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        //用户注册
        CustomerRegistVC *customerRegistVC = [[CustomerRegistVC alloc] init];
        customerRegistVC.userPhone = self.phoneNumber;
        customerRegistVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customerRegistVC animated:YES];
    }
    else
    {
        [self.searchView clearContent];
    }
    

}


#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_getCustomer]) {
            self.isNowDamping = NO;
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_getCustomer])
            {
                MembershipInfoModel *model = (MembershipInfoModel *)parserObject;
                if ([model.code isEqualToString:@"200"]) {
                    [weakSelf skipToSellGoodsScanVCWithModel:model];
                }
                else if ([model.code isEqualToString:@"3002"])
                {
                    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提醒" alterType:FDAltertViewTypeTips message:@"用户还未注册，请确认是否注册？" delegate:self buttonTitles:@"取消", @"确定", nil];
                    [alert show];
                }
                
                else
                {
                    [[NSToastManager manager] showtoast:model.message];
                }
                
                self.isNowDamping = NO;
            }
        }
    }
}

/**获取会员信息Api*/
- (void)httpPath_getCustomerWithPhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:phoneNumber forKey:@"phone"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_getCustomer;
}

#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
        _searchView.frame = CGRectMake(0, 10, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.viewType = CommonSearchViewTypeCustomer;
    }
    return _searchView;
}




@end
