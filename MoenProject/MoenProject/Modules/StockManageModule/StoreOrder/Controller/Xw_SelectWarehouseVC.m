//
//  Xw_SelectWarehouseVC.m
//  MoenProject
//
//  Created by wuxinyi on 2021/12/12.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "Xw_SelectWarehouseVC.h"
#import "RadioButton.h"
#import "LoginInfoModel.h"
#import "ChangeStoreTCell.h"
@interface Xw_SelectWarehouseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIButton* submitBtn;
@property(nonatomic,strong)NSArray* dataSource;

@property(nonatomic,strong)RadioButton* radioBtn1;

@property(nonatomic,strong)RadioButton* radioBtn2;

@property(nonatomic,strong)NSMutableArray* buttons;

@property (nonatomic, strong) UserLoginInfoModel *selectedModel;

@property (nonatomic, strong) NSString* returnAddress;
@end

@implementation Xw_SelectWarehouseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    self.title = @"选择退货仓库";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configBaseUI];
    [self configBaseData];
}
-(void)configBaseUI{
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.radioBtn1];
    [self.view addSubview:self.radioBtn2];
   
    
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.tableView];
    
    
    self.titleLab.sd_layout.topEqualToView(self.view).leftSpaceToView(self.view, 15).widthIs(100).heightIs(40);
    self.radioBtn1.sd_layout.leftSpaceToView(self.titleLab, 5).topEqualToView(self.view).widthIs(100).heightIs(40);
    self.radioBtn2.sd_layout.leftSpaceToView(self.radioBtn1, 5).topEqualToView(self.view).widthIs(100).heightIs(40);
    
    self.submitBtn.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view,KWBottomSafeHeight).heightIs(40);
    self.tableView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topSpaceToView(self.titleLab, 0).bottomSpaceToView(self.submitBtn, 0);
    
    [self.buttons addObject:self.radioBtn1];
    [self.buttons addObject:self.radioBtn2];
    [self.buttons[0] setGroupButtons:self.buttons]; // Setting buttons into the group
    
    [self.buttons[0] setSelected:YES]; // Making the first button initially selected
    self.tableView.hidden = YES;
    self.returnAddress = @"shop";
}
-(void)configBaseData{
    [self httpPath_stores_dealerStockerList];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeStoreTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeStoreTCell" forIndexPath:indexPath];
    UserLoginInfoModel *model = self.dataSource[indexPath.section];
//    [cell showDataWithUserLoginInfoModel:model];
    cell.warehouseModel = model;
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UserLoginInfoModel *model in self.dataSource) {
        model.isSelected = NO;
    }
    UserLoginInfoModel *selectedModel = self.dataSource[indexPath.section];
    selectedModel.isSelected = YES;
    self.selectedModel = selectedModel;
    [self.tableView reloadData];
}
-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = AppBgWhiteColor;
        _tableView.layer.cornerRadius = 3;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"ChangeStoreTCell" bundle:nil] forCellReuseIdentifier:@"ChangeStoreTCell"];
    }
    return _tableView;
}

//订单预约自提信息
-(void)httpPath_stores_dealerStockerList{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:self.orderID forKey:@"orderID"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_stores_dealerStockerList;
}

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
//    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_stores_dealerStockerList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([parserObject.code isEqualToString:@"200"]) {
                if ([operation.urlTag isEqualToString:Path_stores_dealerStockerList]) {
                    
                    self.dataSource = [UserLoginInfoModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"listData"]];
                    [self.tableView reloadData];
                }
                
            }
            else
            {
                self.isShowEmptyData = YES;
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}
-(UILabel*)titleLab{
    if(!_titleLab){
        _titleLab = [UILabel labelWithText:@"退货地点" WithTextColor:COLOR(@"646464") WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
    }
    return _titleLab;
}

-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"确定" WithtextColor:COLOR(@"#ffffff") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            NSString* stockeId = @"";
            if([self.returnAddress isEqualToString:@"stocke"]){
                if (self.selectedModel.id.length == 0) {
                    [[NSToastManager manager] showtoast:@"请选择总仓"];
                    return;
                } else {
                    stockeId = self.selectedModel.id;
                }
            }
            if(self.operaBlock){
                self.operaBlock(self.returnAddress, stockeId);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _submitBtn;
}
-(NSMutableArray*)buttons{
    if(!_buttons){
        _buttons = [NSMutableArray arrayWithCapacity:2];
    }
    return _buttons;
}
-(RadioButton*)radioBtn1{
    if(!_radioBtn1){
        _radioBtn1 = [RadioButton new];
        [_radioBtn1 addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radioBtn1 setTitle:@"门店" forState:UIControlStateNormal];
        [_radioBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _radioBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_radioBtn1 setImage:[UIImage imageNamed:@"icon_checked_false.png"] forState:UIControlStateNormal];
        [_radioBtn1 setImage:[UIImage imageNamed:@"icon_checked_true.png"] forState:UIControlStateSelected];
        _radioBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _radioBtn1.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return _radioBtn1;
}
-(RadioButton*)radioBtn2{
    if(!_radioBtn2){
        _radioBtn2 = [RadioButton new];
        [_radioBtn2 addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_radioBtn2 setTitle:@"总仓" forState:UIControlStateNormal];
        [_radioBtn2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _radioBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_radioBtn2 setImage:[UIImage imageNamed:@"icon_checked_false.png"] forState:UIControlStateNormal];
        [_radioBtn2 setImage:[UIImage imageNamed:@"icon_checked_true.png"] forState:UIControlStateSelected];
        _radioBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _radioBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }
    return _radioBtn2;
}
-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        NSLog(@"Selected color: %@", sender.titleLabel.text);
        if([sender.titleLabel.text isEqualToString:@"门店"]){
            self.tableView.hidden = YES;
            self.returnAddress = @"shop";
        } else {
            self.tableView.hidden = NO;
            self.returnAddress = @"stocke";
        }
    }
}
@end
