//
//  xw_AttentionItem.m
//  MoenProject
//
//  Created by wuxinyi on 2022/3/22.
//  Copyright © 2022 Kevin Jin. All rights reserved.
//

#import "xw_AttentionItemVC.h"
#import "xw_AttentionItemCell.h"
#import "XwActivityModel.h"
@interface xw_AttentionItemVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation xw_AttentionItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    [self xw_setupUI];
    [self xw_bindViewModel];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self xw_layoutNavigation];
    [self xw_loadDataSource];
}
-(void)backBthOperate{
   
    if(self.isDetail){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self disposeData];
    }
    
    
    
}
-(void)xw_layoutNavigation{
    self.title = @"填写重点关注项";
}
-(void)xw_setupUI{
    [self.view addSubview:self.tableView];
    
    
    if(self.isDetail){
        self.tableView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0)) ;
    } else {
        [self.view addSubview:self.clearBtn];
        [self.view addSubview:self.submitBtn];
        self.tableView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight+ 40);
        self.clearBtn.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).widthIs(SCREEN_WIDTH/2).heightIs(40);
        self.submitBtn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, KWBottomSafeHeight).widthIs(SCREEN_WIDTH/2).heightIs(40);
    }
    
}
-(void)xw_loadDataSource{
    
    if(self.isDetail){
        self.dataSource = [self.activityIndexIdList mutableCopy];
    } else {
        
        [self httpPath_getActivityIndexIdList];
    }
    
//    kSetMJRefresh(self.tableView);
    
    
}
-(void)xw_loadNewData{
    
    [self.dataSource removeAllObjects];
//    self.page = 1;
    [self getData];
}
-(void)xw_loadMoreData{
    if ([self.tableView.mj_header isRefreshing]) {
        return;
    }
//    self.page ++;
    [self getData];
}
-(void)getData{
    
}

-(void)xw_bindViewModel{
    
}
//活动重点关注项
-(void)httpPath_getActivityIndexIdList{
    NSMutableArray* arr= [NSMutableArray array];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:arr forKey:@"goodsSkuInfos"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    [[NSToastManager manager] showprogress];
//
    self.requestURL = Path_getActivityIndexIdList;
}
#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderDetail]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([parserObject.code isEqualToString:@"200"]) {

                self.dataSource = [XwActivityModel mj_objectArrayWithKeyValuesArray:parserObject.datas[@"activityIndexIdList"]];
                if(self.activityIndexIdList.count > 0){
                    for (XwActivityModel* tmAcModel in self.dataSource) {
                        for (XwActivityModel* tm in self.activityIndexIdList) {
                            if([tm.activityIndexId isEqualToString:tmAcModel.activityIndexId]){
                                tmAcModel.num = tm.num;
                            }
                        }
                    }
                }

                [self.tableView reloadData];
            }
            else
            {
                self.isShowEmptyData = YES;
                [[NSToastManager manager] showtoast:parserObject.message];
            }
            
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    
    xw_AttentionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xw_AttentionItemCell" forIndexPath:indexPath];
//    [cell showDataWithOrderManageModel:model];
//    cell.stockInfoModel = self.dataSource[indexPath.section];
    cell.model = self.dataSource[indexPath.section];
    cell.isEnabled = !self.isDetail ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.tableHeaderView = [UIView new];
        [_tableView registerClass:[xw_AttentionItemCell class] forCellReuseIdentifier:@"xw_AttentionItemCell"];
    }
    return _tableView;
}
-(UIButton*)clearBtn{
    if(!_clearBtn){
        _clearBtn = [UIButton buttonWithTitie:@"清除" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:[UIColor grayColor]  WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            NSLog(@"%@",@"清除");
            for (XwActivityModel* model in self.dataSource) {
                model.num = @"";
            }
            [self.tableView reloadData];
        }];
    }
    return _clearBtn;
}
-(void)disposeData{
    NSMutableArray* array = [NSMutableArray array];
    for (XwActivityModel* model in self.dataSource) {
        if(model.num != nil && ![model.num isEqualToString:@""]){
//            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//            [dict setObject:model.num forKey:@"num"];
//            [dict setObject:model.activityIndexName forKey:@"activityIndexName"];
//            [dict setObject:model.activityIndexId forKey:@"activityIndexId"];
            [array addObject:model];
        }
    }
    if (self.refreshBlock) {
        self.refreshBlock([array copy]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIButton*)submitBtn{
    if(!_submitBtn){
        _submitBtn = [UIButton buttonWithTitie:@"确定" WithtextColor:COLOR(@"#FFFFFF") WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:17 EventBlock:^(id  _Nonnull params) {
            NSLog(@"%@",@"确定");
            [self disposeData];
        }];
    }
    return _submitBtn;
}
//
-(NSMutableArray*)dataSource{
 
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
