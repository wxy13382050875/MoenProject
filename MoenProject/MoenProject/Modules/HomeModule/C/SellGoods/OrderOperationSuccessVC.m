//
//  OrderOperationSuccessVC.m
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import "OrderOperationSuccessVC.h"
#import "OrderDetailVC.h"
#import "SalesCounterVC.h"
#import "ReturnOrderDetailVC.h"

#import "ReturnAllGoodsCounterVC.h"
#import "ReturnGoodsCounterVC.h"
#import "ReturnGoodsSelectVC.h"
#import "XwOrderDetailVC.h"
#import "PurchaseCounterVC.h"
#import "HomePageItemCCell.h"
#import "xw_SelectDeliveryWayVC.h"
#import "XwSubscribeTakeVC.h"
#import "XwOrderDetailVC.h"
#import "XwImproveReservationVC.h"
static CGFloat kMagin = 1.f;
@interface OrderOperationSuccessVC ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionview;

@property (weak, nonatomic) IBOutlet UIImageView *top_Img;
@property (weak, nonatomic) IBOutlet UILabel *tip_Lab;

@property (weak, nonatomic) IBOutlet UILabel *top_Lab;

@property (weak, nonatomic) IBOutlet UIImageView *bottom_Img;
@property (weak, nonatomic) IBOutlet UILabel *bottom_Lab;

@property (strong, nonatomic)NSMutableArray* dataSource;

@end

@implementation OrderOperationSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configBaseUI];
    
    [self configBaseData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
        //清除上一个视图控制器
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    if (marr.count > 1) {
//        UIViewController *vc = [marr objectAtIndex:marr.count - 2];
//        if ([vc isKindOfClass:[SalesCounterVC class]] ||
//            [vc isKindOfClass:[ReturnAllGoodsCounterVC class]] ||
//            [vc isKindOfClass:[ReturnGoodsCounterVC class]]||
//            [vc isKindOfClass:[PurchaseCounterVC class]]||
//            [vc isKindOfClass:[XwOrderDetailVC class]]) {
//            [marr removeObject:vc];
//
//            UIViewController *vc = [marr objectAtIndex:marr.count - 2];
//            if ([vc isKindOfClass:[ReturnGoodsSelectVC class]]) {
//                [marr removeObject:vc];
//            }
////            if (self.controllerType == OrderOperationSuccessVCTypePlacing) {
//                UIViewController *scanView = [marr objectAtIndex:marr.count - 2];
//                [marr removeObject:scanView];
////            }
//        }
//        self.navigationController.viewControllers = marr;
//    }
}
-(void)backBthOperate{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    BOOL isStock = NO;
//    UIViewController* stVC = nil;
//    for (UIViewController* vc in marr) {
//        if ([vc isKindOfClass:[OrderOperationSuccessVC class]]) {
////            [marr removeObject:vc];
//            isStock = YES;
//
//        }
//        if([vc isKindOfClass:[PurchaseOrderManageVC class]]){
//            stVC = vc;
//        }
//    }
//    if (isStock&&stVC !=nil ) {
//
//        [self.navigationController popToViewController:stVC animated:YES];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)configBaseUI
{
    [self setShowBackBtn:YES type:NavBackBtnImageWhiteType];
    
    [self.view addSubview:self.collectionview];
    self.collectionview.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0)) ;
//    self.top_Lab.font = FONTLanTingB(17);
//    self.bottom_Lab.font = FONTLanTingR(14);
//    self.tip_Lab.font = FONTLanTingR(14);
//
//    if (self.controllerType == OrderOperationSuccessVCTypePlacing) {
//        self.title = NSLocalizedString(@"order_complete", nil);
//        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
//        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
//        self.top_Lab.text = NSLocalizedString(@"order_complete_t", nil);
//        self.bottom_Lab.text = NSLocalizedString(@"order_detail", nil);
//    } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||
//               self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {
//        if(self.controllerType == OrderOperationSuccessVCTypeStockSave){
//            self.top_Lab.text = NSLocalizedString(@"stock_save", nil);
//            self.title = NSLocalizedString(@"submit_success", nil);
//        } else {
//            self.top_Lab.text = NSLocalizedString(@"stock_submit", nil);
//            self.title = NSLocalizedString(@"save_success", nil);
//        }
//
//        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
//        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
//
//
//        self.bottom_Lab.text = NSLocalizedString(@"stock_order_detail", nil);
//    }
//    else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSave||self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
//        self.title = NSLocalizedString(@"order_complete", nil);
//        [self.top_Img setImage:ImageNamed(@"o_placing_order_icon")];
//        [self.bottom_Img setImage:ImageNamed(@"o_placing_orderDetail_icon")];
//        self.top_Lab.text = NSLocalizedString(@"transfers_submit", nil);
//
//        self.bottom_Lab.text = NSLocalizedString(@"transfers_order_detail", nil);
//    }
//    else
//    {
//        self.title = NSLocalizedString(@"return_complete", nil);
//        [self.top_Img setImage:ImageNamed(@"o_return_order_icon")];
//        [self.bottom_Img setImage:ImageNamed(@"o_return_orderDetail_icon")];
//        self.top_Lab.text =NSLocalizedString(@"return_complete_t", nil);
//        self.bottom_Lab.text = NSLocalizedString(@"return_order_detail", nil);
//    }
//
}

- (void)configBaseData
{
//    self.bottom_Lab.userInteractionEnabled = YES;
//    self.bottom_Img.userInteractionEnabled = YES;
//    [self.bottom_Lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)]];
//    [self.bottom_Img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction)]];
    
    if (self.controllerType == OrderOperationSuccessVCTypePlacing||
        self.controllerType == OrderOperationSuccessVCTypeExchangeSubmit) {
        if(self.controllerType == OrderOperationSuccessVCTypePlacing){
            self.title = NSLocalizedString(@"order_complete", nil);
            RoleProfileModel * model = [[RoleProfileModel alloc]init];
            model.title = @"订单详情";
            model.icon =@"o_placing_orderDetail_icon";
            model.skipid= 0;
            
            [self.dataSource addObject:model];
        } else {
            self.title = NSLocalizedString(@"exchange_complete", nil);
            RoleProfileModel * model = [[RoleProfileModel alloc]init];
            model.title = @"换货单详情";
            model.icon =@"o_placing_orderDetail_icon";
            model.skipid= 0;
            
            [self.dataSource addObject:model];
        }
        
        
        if ([QZLUserConfig sharedInstance].useInventory){
            RoleProfileModel * model1 = [[RoleProfileModel alloc]init];
            model1.title = @"更新发货";
            model1.icon =@"o_placing_orderDetail_icon";
            model1.skipid= 1;
            
            [self.dataSource addObject:model1];
            
            RoleProfileModel * model2 = [[RoleProfileModel alloc]init];
            model2.title = @"标记预约自提";
            model2.icon =@"o_placing_orderDetail_icon";
            model2.skipid= 2;
            
            [self.dataSource addObject:model2];
        }
        
        if(self.controllerType == OrderOperationSuccessVCTypePlacing){
            self.title = NSLocalizedString(@"order_complete", nil);
            RoleProfileModel * model = [[RoleProfileModel alloc]init];
            model.title = @"完善预售";
            model.icon =@"o_placing_orderDetail_icon";
            model.skipid= 6;
            
            [self.dataSource addObject:model];
        }
        
      
        
    } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||
               self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {

        if(self.controllerType == OrderOperationSuccessVCTypeStockSave){
            self.title = NSLocalizedString(@"submit_success", nil);
        } else {
            self.title = NSLocalizedString(@"save_success", nil);
        }
        RoleProfileModel * model = [[RoleProfileModel alloc]init];
        model.title = @"进货单详情";
        model.icon =@"o_placing_orderDetail_icon";
        model.skipid= 3;
        
        [self.dataSource addObject:model];
    }
    else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSave||self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
        if(self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit){
            self.title = NSLocalizedString(@"submit_success", nil);
        } else {
            self.title = NSLocalizedString(@"save_success", nil);
        }
        RoleProfileModel * model = [[RoleProfileModel alloc]init];
        model.title = @"调拨单详情";
        model.icon =@"o_placing_orderDetail_icon";
        model.skipid= 4;
        
        [self.dataSource addObject:model];
        
        
    }
    else
    {
        self.title = NSLocalizedString(@"return_complete", nil);
        RoleProfileModel * model = [[RoleProfileModel alloc]init];
        model.title = @"退货单详情";
        model.icon =@"o_placing_orderDetail_icon";
        model.skipid= 5;
        
        [self.dataSource addObject:model];
        
    }
    
    [self.collectionview reloadData];
    
}

//
//- (void)selectAction
//{
////    [[NSToastManager manager] showtoast:@"跳转详情"];
//    if (self.controllerType == OrderOperationSuccessVCTypeReturn) {
//
//        ReturnOrderDetailVC *returnOrderDetailVC = [[ReturnOrderDetailVC alloc] init];
//        returnOrderDetailVC.orderID = self.orderID;
//        [self.navigationController pushViewController:returnOrderDetailVC animated:YES];
//    } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {
//        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
//        orderDetailVC.orderID = self.orderID;
//        orderDetailVC.controllerType = PurchaseOrderManageVCTypeSTOCK;
//        [self.navigationController pushViewController:orderDetailVC animated:YES];
//    }else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
//        XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
//        orderDetailVC.orderID = self.orderID;
//        orderDetailVC.controllerType = PurchaseOrderManageVCTypeAllocteOrder;
//        [self.navigationController pushViewController:orderDetailVC animated:YES];
//    }
//    else
//    {
//        OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
//        orderDetailVC.orderID = self.orderID;
//        [self.navigationController pushViewController:orderDetailVC animated:YES];
//    }
//
//}

//有多少的分组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分组里有多少个item

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

   
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据identifier从缓冲池里去出cell

    HomePageItemCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageItemCCell" forIndexPath:indexPath];
    [cell showDataWithRoleProfileModel:self.dataSource[indexPath.row]];
    
    return cell;

}
#pragma mark - JJCollectionViewDelegateRoundFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout borderEdgeInsertsForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5.f, 5.f, 5, 5.f);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 210);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    //kind有两种 一种时header 一种事footer
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];

        UIImageView* imageView = [UIImageView new];
        
        [header addSubview:imageView];
        
        imageView.sd_layout.centerXEqualToView(header).topSpaceToView(header, 30).widthIs(70).heightIs(70);

        
        UILabel* titleLabel = [UILabel labelWithText:@"" WithTextColor:COLOR(@"#333333") WithNumOfLine:1 WithBackColor:[UIColor whiteColor] WithTextAlignment:NSTextAlignmentCenter WithFont:  16];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [header addSubview: titleLabel];
        titleLabel.sd_layout.topSpaceToView(imageView, 5)
        .leftSpaceToView(header, 10)
        .rightSpaceToView(header, 10)
        .heightIs(30);


        if (self.controllerType == OrderOperationSuccessVCTypePlacing) {
            [imageView setImage:ImageNamed(@"o_placing_order_icon")];
            titleLabel.text = NSLocalizedString(@"order_complete_t", nil);
        } else if (self.controllerType == OrderOperationSuccessVCTypeExchangeSubmit) {
            [imageView setImage:ImageNamed(@"o_placing_order_icon")];
            titleLabel.text = NSLocalizedString(@"exchange_complete_t", nil);
        } else if (self.controllerType == OrderOperationSuccessVCTypeStockSave||
                   self.controllerType == OrderOperationSuccessVCTypeStockSubmit) {
            if(self.controllerType == OrderOperationSuccessVCTypeStockSave){
                titleLabel.text = NSLocalizedString(@"stock_save", nil);
            } else {
                titleLabel.text = NSLocalizedString(@"stock_submit", nil);
            }

            [imageView setImage:ImageNamed(@"o_placing_order_icon")];
        }
        else if (self.controllerType == OrderOperationSuccessVCTypeTransfersSave||self.controllerType == OrderOperationSuccessVCTypeTransfersSubmit) {
            [imageView setImage:ImageNamed(@"o_placing_order_icon")];
            titleLabel.text = NSLocalizedString(@"transfers_submit", nil);
        }
        else
        {
            [imageView setImage:ImageNamed(@"o_return_order_icon")];
            titleLabel.text =NSLocalizedString(@"return_complete_t", nil);
        }

        

        UILabel* serveLab = [UILabel labelWithText:@"快速服务" WithTextColor:AppTitleBlackColor WithNumOfLine:1 WithBackColor:nil WithTextAlignment:NSTextAlignmentLeft WithFont:14];
        serveLab.font = [UIFont boldSystemFontOfSize:14];
        [header addSubview: serveLab];
        serveLab.sd_layout
        .leftSpaceToView(header, 15)
        .rightSpaceToView(header, 15)
        .bottomEqualToView(header)
        .heightIs(40);

        
        UILabel* line1 = [UILabel labelWithLine:COLOR(@"#EEEEEE")];
        [header addSubview: line1];
        line1.sd_layout
        .leftEqualToView(header)
        .rightEqualToView(header)
        .bottomSpaceToView(serveLab, 0)
        .heightIs(5);
        
        UILabel* line2 = [UILabel labelWithLine:COLOR(@"#EEEEEE")];
        [header addSubview: line2];
        line2.sd_layout
        .leftEqualToView(header)
        .rightEqualToView(header)
        .bottomEqualToView(serveLab)
        .heightIs(1);
        return header;
    } else {
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        footer.backgroundColor = COLOR(@"#EEEEEE");
        return footer;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RoleProfileModel * model = self.dataSource[indexPath.row];
    switch (model.skipid) {
        case 0://订单详情
        {
            if(self.controllerType == OrderOperationSuccessVCTypePlacing){
                OrderDetailVC *orderDetailVC = [[OrderDetailVC alloc] init];
                orderDetailVC.orderID = self.orderID;
                orderDetailVC.customerId = self.customerId;
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            } else {//换货单详情
                XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
                orderDetailVC.orderID = self.orderID;
                orderDetailVC.controllerType = PurchaseOrderManageVCTypeCustomerExchange;
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            }
            
        }
            break;
        case 1://更新发货
        {
            xw_SelectDeliveryWayVC *orderDetailVC = [[xw_SelectDeliveryWayVC alloc] init];
            orderDetailVC.orderID = self.orderID;
            orderDetailVC.customerId = self.customerId;
            if(self.controllerType == PurchaseOrderManageVCTypeCustomerExchange){
                orderDetailVC.type = @"exchange";
            } else {
                orderDetailVC.type = @"common";
            }
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
            break;
        case 2://标记预约自提
        {
            
            XwSubscribeTakeVC *orderDetailVC = [[XwSubscribeTakeVC alloc] init];
            orderDetailVC.orderID = self.orderID;
            orderDetailVC.customerId = self.customerId;
            orderDetailVC.isIdentifion = YES;
            if(self.controllerType == PurchaseOrderManageVCTypeCustomerExchange){
                orderDetailVC.type = @"exchange";
            } else {
                orderDetailVC.type = @"common";
            }
            [self.navigationController pushViewController:orderDetailVC animated:YES];
           
        }
            break;
        case 3://进货单详情
        {
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = self.orderID;
            orderDetailVC.controllerType = PurchaseOrderManageVCTypeSTOCK;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
            break;
        case 4://调拨单详情
        {
            XwOrderDetailVC *orderDetailVC = [[XwOrderDetailVC alloc] init];
            orderDetailVC.orderID = self.orderID;
            orderDetailVC.controllerType = PurchaseOrderManageVCTypeAllocteOrder;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
        }
            break;
        case 5:
        {
            ReturnOrderDetailVC *returnOrderDetailVC = [[ReturnOrderDetailVC alloc] init];
            returnOrderDetailVC.orderID = self.orderID;
            [self.navigationController pushViewController:returnOrderDetailVC animated:YES];
        }
            break;
        case 6://完善预售
        {
            XwImproveReservationVC *OrderDetailVC = [[XwImproveReservationVC alloc] init];
            OrderDetailVC.orderID = self.orderID;
            OrderDetailVC.customerId = self.customerId;
            [self.navigationController pushViewController:OrderDetailVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(UICollectionView*)collectionview{
    if (!_collectionview) {
         UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
         layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        CGFloat itemWidth = ((SCREEN_WIDTH) - 4 * kMagin) / 3;

               

        //设置单元格大小
        layout.itemSize = CGSizeMake(itemWidth, itemWidth + 15);

        //最小行间距(默认为10)
        layout.minimumLineSpacing = 1;

        //最小item间距（默认为10）
        layout.minimumInteritemSpacing = 1;

        //设置senction的内边距
        layout.sectionInset = UIEdgeInsetsMake(kMagin, kMagin, kMagin, kMagin);

        
        _collectionview = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        
        _collectionview.backgroundColor =COLOR(@"#eeeeee");
        //注册cell
        [_collectionview registerNib:[UINib nibWithNibName:@"HomePageItemCCell" bundle:nil] forCellWithReuseIdentifier:@"HomePageItemCCell"];
        //注册header
        [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
        

        _collectionview.backgroundColor =COLOR(@"#ffffff");
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
    }
    return _collectionview;
}
-(NSMutableArray*)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
@end
