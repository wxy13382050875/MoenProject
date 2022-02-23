//
//  PurchaseOrderManageVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/24.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import "PurchaseOrderManageVC.h"
#import "CommonSearchView.h"
#import "CommonSingleGoodsDarkTCell.h"
#import "OrderManageModel.h"
#import "OrderListTCell.h"
#import "OrderDetailVC.h"
#import "CommonCategoryModel.h"
#import "OrderScreenSideslipView.h"
#import "xWStockOrderModel.h"
#import "XwOrderDetailVC.h"

#import "XwScreenModel.h"
#import "StockSearchGoodsVC.h"
@interface PurchaseOrderManageVC ()<SearchViewCompleteDelete, UITableViewDelegate, UITableViewDataSource,UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) CommonSearchView *searchView;

@property (nonatomic, strong) OrderScreenSideslipView *conditionSelectView;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataList;

/**页码*/
@property (nonatomic,assign) NSInteger pageNumber;
/**每页数据条数*/
@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *orderCode;

@property (nonatomic, strong) NSMutableArray *selectDataArr;

@property (nonatomic, copy) NSString *selectedTimeType;

@property (nonatomic, copy) NSString *dataStart;

@property (nonatomic, copy) NSString *dataEnd;

@property (nonatomic, copy) NSString *orderStatus;

@end

@implementation PurchaseOrderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseUI];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configBaseData];
}
- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableview];
    self.searchView.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view).heightIs(56);
    
//    self.tableview.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view).topSpaceToView(self.searchView, 0);

//    NSLog(@"12345675432345%@",NSStringFromCGRect(self.tableview.frame))
}

- (void)configBaseData
{
    [self configPagingData];
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
    [self httpPath_load];
    WEAKSELF
    [self.tableview addDropDownRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber = 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
    [self.tableview addPullUpRefreshWithActionHandler:^{
        [weakSelf handlePageNumber];
        weakSelf.pageNumber += 1;
        
        //对应接口
        [weakSelf httpPath_orderList];
    }];
}

- (void)reconnectNetworkRefresh
{
    WEAKSELF
    [weakSelf handlePageSize];
    [[NSToastManager manager] showprogress];
    [weakSelf httpPath_orderList];
    [weakSelf httpPath_load];
}



#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView %ld" ,self.dataList.count);
        return self.dataList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    Orderlist *model = self.dataList[section];;
    BOOL isShowBtn = YES ;
    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
        if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
            if([model.orderStatus isEqualToString:@"wait"]){
                
            }  else if([model.orderStatus isEqualToString:@"waitDeliver"]||
                       [model.orderStatus isEqualToString:@"partDeliver"]){
                
            } else {
    //            againBtn.hidden = YES;
                isShowBtn = NO;
            }
        } else {
            isShowBtn = NO;
        }
        
    } else if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
       
    } else if(
        self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
            if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
                if([model.orderStatus isEqualToString:@"waitGoods"]){
                    if (![model.senderKey isEqualToString:@"thisShop"]) {
                        
                    } else {
                        isShowBtn = NO;
                    }
                } else {
                    isShowBtn = NO;
                }
            } else {
                isShowBtn = NO;
            }
        
    } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
        if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
            if([model.orderStatus isEqualToString:@"wait"]){
                
            } else if([model.orderStatus isEqualToString:@"waitDeliver"]){
                
            } else {
                isShowBtn = NO;
            }
        } else {
            isShowBtn = NO;
        }
        
    } else {
        isShowBtn = NO;
    }
    if(isShowBtn){
        return 85;
    } else {
        return 45;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Orderlist *model = self.dataList[indexPath.section];;
    
        
    
    
    if (model.goodsList.count > 1) {
        OrderListTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListTCell" forIndexPath:indexPath];
        cell.model = model;
       
        return cell;
    }
    else
    {
        CommonSingleGoodsDarkTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonSingleGoodsDarkTCell" forIndexPath:indexPath];
        
        cell.model = model.goodsList[0];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Orderlist *model = self.dataList[section];
    NSString* orderStatus;
//        订单状态（筛选条件）待提交/待审核/待发货/配货中/部分发货/全部发货/已完成/已拒绝等  all/waitSub/wait/waitDeliver/allocate/partDeliver/allDeliver/finish/refuse
    if([model.orderStatus isEqualToString:@"waitSub"]){
        orderStatus = @"待提交";
    } else if([model.orderStatus isEqualToString:@"wait"]){
        orderStatus = @"待审核";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"待门店审核";
        }
    } else if([model.orderStatus isEqualToString:@"waitDeliver"]){
        orderStatus = @"待发货";
    } else if([model.orderStatus isEqualToString:@"waitAllocate"]){
        orderStatus = @"待配货";
    } else if([model.orderStatus isEqualToString:@"allocate"]){
        orderStatus = @"配货中";
    } else if([model.orderStatus isEqualToString:@"partAllocate"]){
        orderStatus = @"部分配货";
    } else if([model.orderStatus isEqualToString:@"allAllocate"]){
        orderStatus = @"全部配货";
    } else if([model.orderStatus isEqualToString:@"partDeliver"]){
        orderStatus = @"部分发货";
    }else if([model.orderStatus isEqualToString:@"allDeliver"]){
        orderStatus = @"全部发货";
    }else if([model.orderStatus isEqualToString:@"finish"]){
        orderStatus = @"已完成";
        if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
           self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker||
           self.controllerType == PurchaseOrderManageVCTypeReturn){
            orderStatus = @"已收货";
        }
        
    }else if([model.orderStatus isEqualToString:@"refuse"]){
        orderStatus = @"已拒绝";
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            orderStatus = @"门店已拒绝";
        }
    }else if([model.orderStatus isEqualToString:@"waitGoods"]){
        orderStatus = @"待收货";
    }else if([model.orderStatus isEqualToString:@"refuseAD"]){
        orderStatus = @"AD已拒绝";
    } else if([model.orderStatus isEqualToString:@"waitAD"]){
        orderStatus = @"待AD审核";
    } else if([model.orderStatus isEqualToString:@"alrea"]){
        orderStatus = @"已发货";
    } else if([model.orderStatus isEqualToString:@"stop"]){
        orderStatus = @"已终止";
    } else if([model.orderStatus isEqualToString:@"completed"]){
        orderStatus = @"已完成";
    } else if([model.orderStatus isEqualToString:@"alrea"]){
        orderStatus = @"已发货";
    }
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppBgWhiteColor;
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
    timeLab.font = FontBinB(14);
    timeLab.textColor = AppTitleBlackColor;
    timeLab.text = model.orderTime;
    [headerView addSubview:timeLab];
    
    
    
    
    UILabel *orderStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 15, 30)];
    orderStatusLab.font = FontBinB(14);
    orderStatusLab.textColor = AppTitleBlackColor;
    orderStatusLab.text = orderStatus;
    orderStatusLab.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:orderStatusLab];
    
    
    
    
    UILabel *orderLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 30)];
    orderLab.font = FONTLanTingR(14);
    orderLab.textColor = AppTitleBlackColor;
    [headerView addSubview:orderLab];
    
    
    UILabel* tagLab = [UILabel labelWithText:@"" WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:[UIColor clearColor] WithTextAlignment:NSTextAlignmentCenter WithFont:12];
    [headerView addSubview:tagLab];
    tagLab.sd_layout.rightSpaceToView(headerView, 15).bottomEqualToView(headerView).widthIs(30).heightIs(30);
    ViewBorderRadius(tagLab, 15, 1, AppTitleBlackColor);
    tagLab.hidden = YES;
    NSString* tagText = @"";
    NSMutableAttributedString *str ;
    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
       self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"调拨单编号: %@",model.orderID]];
    }
    else if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"进货单编号: %@",model.orderID]];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"发货单编号: %@",model.orderID]];
//        tagLab.hidden = NO;
//        if([model.senderKey isEqualToString:@"thisShop"]){
//            tagText = @"本店";
//        } else if([model.senderKey isEqualToString:@"otherShop"]){
//            tagText = @"他店";
//        } else {
//            tagText = model.senderKey;
//        }
//        tagLab.text = tagText;
    } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"退货单编号: %@",model.orderID]];
    } else {
        str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单编号: %@",model.orderID]];
    }
    
    [str addAttribute:NSFontAttributeName value:FontBinB(14) range:NSMakeRange(6, str.length - 6)];
    orderLab.attributedText = str;
    
    
    
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    Orderlist *model = self.dataList[section];
    
    
    
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = AppBgWhiteColor;
    
   
    UILabel *infoLab = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLab.font = FONTLanTingR(14);
    infoLab.textColor = AppTitleBlackColor;
    infoLab.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品",model.goodsCount]];
    infoLab.attributedText = str;
    [footerView addSubview:infoLab];
    
    infoLab.sd_layout.leftSpaceToView(footerView, 15).topEqualToView(footerView).rightSpaceToView(footerView, 15).heightIs(40);
    
    UIButton *againBtn =[UIButton buttonWithTitie:@"" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
        
        [self buttonOperate:model];
    }];
    againBtn.layer.cornerRadius = 5;
    againBtn.frame = CGRectMake(SCREEN_WIDTH - 90 - 16, 45, 90, 30);
    [footerView addSubview:againBtn];
    
    
    UIButton *printBtn =[UIButton buttonWithTitie:@"打印" WithtextColor:AppTitleWhiteColor WithBackColor:AppTitleBlueColor WithBackImage:nil WithImage:nil WithFont:14 EventBlock:^(id  _Nonnull params) {
        
//        [self buttonOperate:model];
        [self printAction:model];
    }];
    printBtn.tag = 10086;
    printBtn.layer.cornerRadius = 5;
    printBtn.frame = CGRectMake(SCREEN_WIDTH - 90 - 16, 45, 90, 30);
    [footerView addSubview:printBtn];
    againBtn.sd_layout.rightSpaceToView(footerView, 15).topSpaceToView(infoLab, 5).widthIs(90).heightIs(30);
    
    printBtn.sd_layout.rightSpaceToView(againBtn, 15).topSpaceToView(infoLab, 5).widthIs(90).heightIs(30);
    
    printBtn.hidden = YES;
    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
        if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
            if([model.orderStatus isEqualToString:@"wait"]){
                [againBtn setTitle:@"审核" forState:UIControlStateNormal];
            }  else if([model.orderStatus isEqualToString:@"waitDeliver"]||
                       [model.orderStatus isEqualToString:@"partDeliver"]){
                [againBtn setTitle:@"发货" forState:UIControlStateNormal];
                printBtn.hidden = NO;
            } else {
                againBtn.hidden = YES;
            }
        } else {
            againBtn.hidden = YES;
        }
//        if([model.orderStatus isEqualToString:@"wait"]){
//            [againBtn setTitle:@"审核" forState:UIControlStateNormal];
//        }  else if([model.orderStatus isEqualToString:@"waitDeliver"]||
//                   [model.orderStatus isEqualToString:@"partDeliver"]){
//            [againBtn setTitle:@"发货" forState:UIControlStateNormal];
//            printBtn.hidden = NO;
//        } else {
//            againBtn.hidden = YES;
//        }
    } else if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
        if([model.orderStatus isEqualToString:@"waitSub"]){
            [againBtn setTitle:@"编辑" forState:UIControlStateNormal];
        }  else {
            [againBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        }
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
            if([model.orderStatus isEqualToString:@"waitGoods"]){
                if (![model.senderKey isEqualToString:@"thisShop"]){
                    [againBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                } else {
                    againBtn.hidden = YES;
                }
                
                
            } else {
                againBtn.hidden = YES;
            }
        } else {
            againBtn.hidden = YES;
        }
        
    } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
        if([[QZLUserConfig sharedInstance].userRole isEqualToString:@"SHOP_LEADER"]){
            if([model.orderStatus isEqualToString:@"wait"]){
                [againBtn setTitle:@"审核" forState:UIControlStateNormal];
            } else if([model.orderStatus isEqualToString:@"waitDeliver"]){
                [againBtn setTitle:@"确认发货" forState:UIControlStateNormal];
                printBtn.hidden = NO;
            } else {
                againBtn.hidden = YES;
            }
        } else {
            againBtn.hidden = YES;
        }
        
    } else{
        againBtn.hidden = YES;
    }
    
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = AppBgBlueGrayColor;
    [footerView addSubview:lineView];
    
    lineView.sd_layout.leftEqualToView(footerView).rightEqualToView(footerView).bottomEqualToView(footerView).heightIs(5);
    return footerView;
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OrderManageModel *model = self.dataList[indexPath.section];
    
    
   
   
    
    Orderlist *model = self.dataList[indexPath.section];
   
    
    XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
    orderDetailVC.orderID = model.orderID;
    orderDetailVC.controllerType = self.controllerType;
    orderDetailVC.refreshBlock = ^{
        [self reconnectNetworkRefresh];
    };
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
-(void)printAction:(Orderlist*)model{
    [[NSToastManager manager] showprogress];
    [self httpPath_print:model];
          
        
}
-(void)buttonOperate:(Orderlist*)model{
    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
//        if([model.orderStatus isEqualToString:@"wait"]){
//            NSLog(@"审批");
//        }  else if([model.orderStatus isEqualToString:@"waitDeliver"]){
//            NSLog(@"发货");
//
//
//
//        }

        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
        orderDetailVC.orderID = model.orderID;
        orderDetailVC.controllerType = self.controllerType;
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
          
            if(([model.orderStatus isEqualToString:@"waitDeliver"]||
               [model.orderStatus isEqualToString:@"partDeliver"])){
                orderDetailVC.isDeliver = YES;
            }
        }
        
        orderDetailVC.refreshBlock = ^{
            [self reconnectNetworkRefresh];
        };
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    } else if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
        
        NSMutableArray* selectArr = [NSMutableArray new];
        NSString* orderID = @"";
//        if([model.orderStatus isEqualToString:@"waitSub"]||
//           [model.orderStatus isEqualToString:@"wait"]){
//            NSLog(@"编辑");
//            
//            
//        }  else {
//            NSLog(@"再来一单");
//            
//        }
        if([model.orderStatus isEqualToString:@"waitSub"]){
            orderID = model.orderID;
        }  else {
            orderID= @"";
        }
        for (Goodslist* tm in model.goodsList) {
            CommonGoodsModel* coModel = [CommonGoodsModel new];
            coModel.id = tm.goodsID;
            coModel.isShowDetail = NO;
            coModel.isSetMeal = tm.goodsPackage!=nil?true:false;
            coModel.code = [tm.goodsSKU mutableCopy];
            coModel.price = [tm.goodsPrice mutableCopy];
            coModel.name = [tm.goodsName mutableCopy];
            coModel.photo = [tm.goodsIMG mutableCopy];
            coModel.kGoodsCount = [tm.goodsCount integerValue];
            if(tm.goodsPackage != nil){
                NSMutableArray* productList =[NSMutableArray new];
                for (Goodslist* packs  in tm.goodsPackage.goodsList) {
                    CommonProdutcModel* prModel = [CommonProdutcModel new];
                    prModel.sku = [packs.goodsSKU mutableCopy];
                    prModel.price = [packs.goodsPrice mutableCopy];
                    prModel.count = [packs.goodsCount integerValue];
                    prModel.photo = [packs.goodsIMG mutableCopy];
                    prModel.name = [packs.goodsName mutableCopy];
                    [productList addObject:prModel];
                }
                coModel.productList = productList;
            }
            
            [selectArr addObject:coModel];
        }
        StockSearchGoodsVC *sellGoodsScanVC = [[StockSearchGoodsVC alloc] init];
        sellGoodsScanVC.goodsType = model.orderType;
        sellGoodsScanVC.controllerType = SearchGoodsVCType_Stock;
        sellGoodsScanVC.selectedDataArr = selectArr;
        sellGoodsScanVC.orderID = orderID;
        sellGoodsScanVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sellGoodsScanVC animated:YES];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
        self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
  
        if([model.orderStatus isEqualToString:@"waitGoods"]){
            NSLog(@"确认收货");
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = model.orderID;
            orderDetailVC.controllerType = self.controllerType;
            orderDetailVC.refreshBlock = ^{
                [self reconnectNetworkRefresh];
            };
            [self.navigationController pushViewController:orderDetailVC animated:YES];
//            FDAlertView *alert = [[FDAlertView alloc] initWithBlockTItle:NSLocalizedString(@"c_remind", nil) alterType:FDAltertViewTypeTips message:@"是否确认收货？" block:^(NSInteger buttonIndex, NSString *inputStr) {
//                if(buttonIndex == 1){
//                    [self httpPath_delivery_confirmReceipt:model];
//                }
//            } buttonTitles:NSLocalizedString(@"c_cancel", nil), NSLocalizedString(@"c_confirm", nil),  nil];
//            [alert show];
//            [self httpPath_delivery_confirmReceipt:model];
        }
    } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
        if([model.orderStatus isEqualToString:@"wait"]||[model.orderStatus isEqualToString:@"waitDeliver"]){
            NSLog(@"审核");
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = model.orderID;
            orderDetailVC.controllerType = self.controllerType;
            orderDetailVC.refreshBlock = ^{
                [self reconnectNetworkRefresh];
            };
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        } 
    }
}

-(void)tuneUpPrinter:(NSString*)url{
    UIPrintInteractionController *printC = [UIPrintInteractionController sharedPrintController];//显示出打印的用户界面。
    printC.delegate = self;
//    UIImage *img = [UIImage imageNamed:@"WelcomeImage2"];
//    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(img)];
 
    if (printC && url.length > 0) {
      
      
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];//准备打印信息以预设值初始化的对象。
        printInfo.outputType = UIPrintInfoOutputGeneral;//设置输出类型。
        printC.showsPageRange = YES;//显示的页面范围
          
//        printInfo.jobName = @"willingseal";
          
//        printC.printInfo = printInfo;
//        NSLog(@"printinfo-%@",printC.printInfo);
        printC.printingItem = [NSURL URLWithString:url];//single NSData, NSURL, UIImage, ALAsset
//        NSLog(@"printingitem-%@",printC);
          
          
        //    等待完成
          
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"可能无法完成，因为印刷错误: %@", error);
            }
        };
          
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
            UIButton* sender = (UIButton*)[self.view viewWithTag:10086];
         UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sender];//调用方法的时候，要注意参数的类型－下面presentFromBarButtonItem:的参数类型是 UIBarButtonItem..如果你是在系统的UIToolbar or UINavigationItem上放的一个打印button，就不需要转换了。
         [printC presentFromBarButtonItem:item animated:YES completionHandler:completionHandler];//在ipad上弹出打印那个页面
 
              
        } else {
            [printC presentAnimated:YES completionHandler:completionHandler];//在iPhone上弹出打印那个页面
        }
      
 
    }
}
#pragma mark -- SearchViewCompleteDelete
- (void)completeInputAction:(NSString *)keyStr
{
    self.orderCode = keyStr;
    [[NSToastManager manager] showprogress];
    [self httpPath_orderList];
}

- (void)selectedTimeAction
{
    [self showConditionSelectView];
}

- (void)showConditionSelectView
{
    WEAKSELF
    [self.conditionSelectView showWithArray:self.selectDataArr WithActionBlock:^(XwScreenModel *model, NSInteger type) {
//
        weakSelf.dataStart = model.dateStart;
        weakSelf.dataEnd = model.dateEnd;
        for (XWSelectModel* tm in model.selectList) {
            if([tm.module isEqualToString:@"TimeQuantum"]){
                weakSelf.selectedTimeType = tm.selectID;
            }
            if([tm.module isEqualToString:@"State"]){
                weakSelf.orderStatus = tm.selectID;
            }
        }
        [[NSToastManager manager] showprogress];
        [weakSelf httpPath_orderList];
    }];
}

#pragma mark -- HTTP

#pragma mark - 接口数据处理
- (void)actionFetchRequest:(NSURLSessionDataTask *)operation result:(MoenBaseModel *)parserObject error:(NSError *)requestErr
{
    WEAKSELF
    [weakSelf.tableview cancelRefreshAction];
    [[NSToastManager manager] hideprogress];
    if (requestErr) {
        if ([operation.urlTag isEqualToString:Path_orderList]) {
            
        }
    }
    else
    {
        if (parserObject.success) {
            if ([operation.urlTag isEqualToString:Path_orderList]) {
                OrderManageListModel *listModel = (OrderManageListModel *)parserObject;
                if (listModel.orderList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.orderList];
                    [weakSelf.tableview reloadData];
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            } else if ([operation.urlTag isEqualToString:Path_stock_orderList]||
                [operation.urlTag isEqualToString:Path_dallot_transferOrderList]||
                [operation.urlTag isEqualToString:Path_delivery_sendOrderList]||
                [operation.urlTag isEqualToString:Path_refund_returnOrderList]) {
                xWStockOrderModel *listModel = [xWStockOrderModel mj_objectWithKeyValues:parserObject.datas];
                if (listModel.orderList.count) {
                    self.isShowEmptyData = NO;
                    if (weakSelf.pageNumber == 1) {
                        [weakSelf.dataList removeAllObjects];
                    }
                    [weakSelf.dataList addObjectsFromArray:listModel.orderList];
                    
                    [weakSelf.tableview reloadData];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
//
//                    //
//                        });
                    
                }
                else
                {
                    if (weakSelf.pageNumber == 1) {
//                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_data", nil)];
                        [weakSelf.dataList removeAllObjects];
                        [weakSelf.tableview reloadData];
                        self.isShowEmptyData = YES;
                    }
                    else
                    {
                        weakSelf.pageNumber -= 1;
                        [[NSToastManager manager] showtoast:NSLocalizedString(@"c_no_more_data", nil)];
                    }
                    [weakSelf.tableview hidenRefreshFooter];
                }
            } else if ([operation.urlTag isEqualToString:Path_load]) {
                
                CommonCategoryListModel *model = (CommonCategoryListModel *)parserObject;
               
                [self.selectDataArr removeAllObjects];
                for (CommonCategoryModel *itemModel in model.enums) {
                    if ([itemModel.className isEqualToString:@"TimeQuantum"]) {
                        XwScreenModel* tmModel = [XwScreenModel new];
                        tmModel.title = @"下单时间";
                        tmModel.className = itemModel.className;
                        tmModel.showFooter =YES;
                        NSMutableArray* array = [NSMutableArray array];
                        
                        for (CommonCategoryDataModel *model in itemModel.datas) {
                            KWOSSVDataModel *itemModel = [[KWOSSVDataModel alloc] init];
                            if ([model.ID isEqualToString:@"ALL"]) {
                                itemModel.isSelected = YES;
                            }
                            itemModel.title = model.des;
                            itemModel.itemId = model.ID;
                            [array addObject:itemModel];
                        }
                        tmModel.list = array;
                        [self.selectDataArr addObject:tmModel];
                    
                    } 
                }
                [self.selectDataArr addObject:[self getFiltrState]];
                
            }
            else if ([operation.urlTag isEqualToString:Path_delivery_confirmReceipt]){
                [self reconnectNetworkRefresh];
            } else if([operation.urlTag isEqualToString:Path_print]){
                if ([parserObject.code isEqualToString:@"200"]) {
                    NSString* url = parserObject.datas[@"url"];
                    [self tuneUpPrinter:url];
                } else {
                    [[NSToastManager manager] showtoast:parserObject.message];
                }
            }
        }
    }
}

/**订单列表Api*/
- (void)httpPath_orderList
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask){
        [parameters setValue:@"task" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
        [parameters setValue:@"order" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){
        [parameters setValue:@"order" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
        [parameters setValue:@"apply" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){
        [parameters setValue:@"shopSelf" forKey:@"orderType"];
    }else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        [parameters setValue:@"stocker" forKey:@"orderType"];
    }
    
    [parameters setValue:self.orderCode forKey:@"orderKey"];
    [parameters setValue:self.dataStart forKey:@"orderDateStart"];
    [parameters setValue:self.dataEnd forKey:@"orderDateEnd"];
    [parameters setValue:self.orderStatus forKey:@"orderStatus"];
    [parameters setValue:self.selectedTimeType forKey:@"timeQuantum"];
    [parameters setValue:@(self.pageNumber) forKey:@"page"];
    [parameters setValue:@(self.pageSize) forKey:@"size"];
    
    
    
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
   
    
   
    
    self.requestType = NO;
    self.requestParams = parameters;
    
    if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
        self.title = @"进货单管理";
        self.requestURL = Path_stock_orderList;
    } else if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
         self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
        self.title = @"调拨单管理";
        self.requestURL = Path_dallot_transferOrderList;
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        self.title = @"发货单管理";
             self.requestURL = Path_delivery_sendOrderList;
    } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
             self.requestURL = Path_refund_returnOrderList;
        self.title = @"退仓单管理";
    } else {
        self.title = @"订单管理";
        self.requestURL = Path_orderList;
    }
    
    
    
   
//    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
////    [parameters setValue:[NSNumber numberWithBool:NO] forKey:@"isReturn"];
//    self.requestType = NO;
//    self.requestParams = parameters;
//    self.requestURL = Path_refund_returnOrderList;
}
- (void)httpPath_delivery_confirmReceipt:(Orderlist*)model{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    [parameters setValue: model.orderID forKey:@"orderID"];
    if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder){
        [parameters setValue:@"order" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
        [parameters setValue:@"apply" forKey:@"orderType"];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf){
        [parameters setValue:@"shopSelf" forKey:@"orderType"];
    }else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
        [parameters setValue:@"stocker" forKey:@"orderType"];
    }
    self.requestType = NO;
    self.requestParams = parameters;
    self.requestURL = Path_delivery_confirmReceipt;
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
//打印
-(void)httpPath_print:(Orderlist*)model{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString* printType = @"";
    NSString* orderCode = @"";
    
    if(self.controllerType ==PurchaseOrderManageVCTypeReturn){
        printType = @"returnStocker";
        orderCode = model.orderID;
    } else if(self.controllerType ==PurchaseOrderManageVCTypeAllocteTask){
        printType = @"apply";
        orderCode = model.orderID;
    }
        
        
//    订单编号（打印调拨单 需要传调拨单号    打印退仓单需要传退仓单号）
    [parameters setValue:orderCode forKey:@"orderCode"];
//    returnStocker/退仓   apply/调拨   inventory/盘库
    [parameters setValue:printType forKey:@"printType"];
    [parameters setValue: [QZLUserConfig sharedInstance].token forKey:@"access_token"];
    self.requestType = NO;
    self.requestParams = parameters;
    
    self.requestURL = Path_print;
}

#pragma mark -- Getter&Setter

- (CommonSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:@"CommonSearchView" owner:self options:nil] lastObject];
//        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56);
        _searchView.delegate = self;
        if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
           self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
            _searchView.viewType = CommonSearchViewTypeChangeDllot;
        } else if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
                   _searchView.viewType = CommonSearchViewTypeChangeSTOCK;
        } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
                 self.controllerType == PurchaseOrderManageVCTypeDeliveryApply||
                 self.controllerType == PurchaseOrderManageVCTypeDeliveryShopSelf||
                 self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
            _searchView.viewType = CommonSearchViewTypeChangeDeliver;
        } else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
              _searchView.viewType = CommonSearchViewTypeChangeReturn;
        } else{
            _searchView.viewType = CommonSearchViewTypeOrder;
        }
        
        
    }
    return _searchView;
}



- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, SCREEN_HEIGHT-56 -45-KWNavBarAndStatusBarHeight) style:UITableViewStyleGrouped];
        _tableview.backgroundColor = AppBgBlueGrayColor;
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:@"CommonSingleGoodsDarkTCell" bundle:nil] forCellReuseIdentifier:@"CommonSingleGoodsDarkTCell"];
        [_tableview registerNib:[UINib nibWithNibName:@"OrderListTCell" bundle:nil] forCellReuseIdentifier:@"OrderListTCell"];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        self.comScrollerView = _tableview;
        self.noDataDes = @"暂无订单信息";
    }
    return _tableview;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
- (NSMutableArray *)selectDataArr
{
    if (!_selectDataArr) {
        _selectDataArr = [[NSMutableArray alloc] init];
    }
    return _selectDataArr;
}


- (OrderScreenSideslipView *)conditionSelectView
{
    if (!_conditionSelectView) {
        _conditionSelectView = [[OrderScreenSideslipView alloc] initWithMarginTop:SCREEN_NavTop_Height];
    }
    return _conditionSelectView;
}



#pragma mark -- 刷新重置等设置
- (void)configPagingData
{
    self.pageNumber = 1;
    self.pageSize = 10;
}
- (void)handlePageSize
{
    if (self.pageNumber > 1) {
        self.pageSize = self.pageSize * self.pageNumber;
        self.pageNumber = 1;
    }
}
- (void)handlePageNumber
{
    if (self.pageSize > 10) {
        self.pageNumber = self.pageSize / 10;
        self.pageSize = 10;
    }
}

- (void)dealloc
{
    NSLog(@"d订单列表页面释放");
}
-(XwScreenModel* )getFiltrState{
    XwScreenModel* tmModel = [XwScreenModel new];
    tmModel.className = @"State";
    NSArray* array;
    NSString* title;
    if(self.controllerType == PurchaseOrderManageVCTypeSTOCK){
        title = @"进货单状态";


        array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"待提交",@"itemId":@"waitSub"},
                           @{@"isSelected":@(NO),@"title":@"待审核",@"itemId":@"wait"},
                           @{@"isSelected":@(NO),@"title":@"待配货",@"itemId":@"waitAllocate"},
                           @{@"isSelected":@(NO),@"title":@"部分配货",@"itemId":@"partAllocate"},
                           @{@"isSelected":@(NO),@"title":@"全部配货",@"itemId":@"allAllocate"},
                           @{@"isSelected":@(NO),@"title":@"部分发货",@"itemId":@"partDeliver"},
                           @{@"isSelected":@(NO),@"title":@"全部发货",@"itemId":@"allDeliver"},
                           @{@"isSelected":@(NO),@"title":@"已完成",@"itemId":@"finish"},
                           @{@"isSelected":@(NO),@"title":@"已拒绝",@"itemId":@"refuse"}];
        
        
        
 
        
    } else if(self.controllerType == PurchaseOrderManageVCTypeAllocteTask||
         self.controllerType == PurchaseOrderManageVCTypeAllocteOrder){
        title = @"调拨单状态";
        array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"待门店审核",@"itemId":@"wait"},
                           @{@"isSelected":@(NO),@"title":@"门店已拒绝",@"itemId":@"refuse"},
                           @{@"isSelected":@(NO),@"title":@"待AD审核",@"itemId":@"waitAD"},
                           @{@"isSelected":@(NO),@"title":@"AD已拒绝",@"itemId":@"refuseAD"},
                           @{@"isSelected":@(NO),@"title":@"待发货",@"itemId":@"waitDeliver"},
                           @{@"isSelected":@(NO),@"title":@"部分发货",@"itemId":@"partDeliver"},
                           @{@"isSelected":@(NO),@"title":@"全部发货",@"itemId":@"allDeliver"},
                           @{@"isSelected":@(NO),@"title":@"已完成",@"itemId":@"finish"}];
    } else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryOrder||
              self.controllerType == PurchaseOrderManageVCTypeDeliveryApply){
        title = @"发货单状态";
        array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"待收货",@"itemId":@"waitGoods"},
                           @{@"isSelected":@(NO),@"title":@"已收货",@"itemId":@"finish"}];
    }
//    else if(self.controllerType == PurchaseOrderManageVCTypeDeliveryStocker){
//         title = @"发货单状态";
//         array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
//                            @{@"isSelected":@(NO),@"title":@"已发货",@"itemId":@"alrea"},
//                            @{@"isSelected":@(NO),@"title":@"已终止",@"itemId":@"stop"}];
//     }
    else if(self.controllerType == PurchaseOrderManageVCTypeReturn){
        title = @"退仓单状态";
        array = @[@{@"isSelected":@(YES),@"title":@"全部",@"itemId":@"all"},
                           @{@"isSelected":@(NO),@"title":@"待审核",@"itemId":@"wait"},
                           @{@"isSelected":@(NO),@"title":@"待发货",@"itemId":@"waitDeliver"},
                           @{@"isSelected":@(NO),@"title":@"已拒绝",@"itemId":@"refuse"},
                           @{@"isSelected":@(NO),@"title":@"待收货",@"itemId":@"waitGoods"},
                           @{@"isSelected":@(NO),@"title":@"已收货",@"itemId":@"finish"}];
    }
//    else {
//        self.title = @"订单管理";
//        NSArray* array = @[@{@"isSelected":@(NO),@"des":@"全部",@"ID":@"ALL"},
//                           @{@"isSelected":@(NO),@"des":@"待配货",@"ID":@"waitAllocate"},
//                           @{@"isSelected":@(NO),@"des":@"部分配货",@"ID":@"partAllocate"},
//                           @{@"isSelected":@(NO),@"des":@"全部配货",@"ID":@"allAllocate"},
//                           @{@"isSelected":@(NO),@"des":@"部分发货",@"ID":@"partDeliver"},
//                           @{@"isSelected":@(NO),@"des":@"全部发货",@"ID":@"allDeliver"},
//                           @{@"isSelected":@(NO),@"des":@"已终止",@"ID":@"stop"}];
//    }
    tmModel.title = title;
    tmModel.list = [KWOSSVDataModel mj_objectArrayWithKeyValuesArray:array];
    return tmModel;
}
@end
