//
//  AddressInfoModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2018/12/20.
//  Copyright © 2018年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoModel : MoenBaseModel

/**收货人名称*/
@property (nonatomic, copy) NSString *shipPerson;

/**收货人电话*/
@property (nonatomic, copy) NSString *shipMobile;

/**详细地址*/
@property (nonatomic, copy) NSString *shipAddress;

/**详细地址ID*/
@property (nonatomic, copy) NSString *addressId;



/**省*/
@property (nonatomic, copy) NSString *shipProvince;
/**省ID*/
@property (nonatomic, copy) NSString *shipProvinceID;


/**市*/
@property (nonatomic, copy) NSString *shipCity;
/**市ID*/
@property (nonatomic, copy) NSString *shipCityID;


/**区*/
@property (nonatomic, copy) NSString *shipDistrict;
/**区ID*/
@property (nonatomic, copy) NSString *shipDistrictID;


/**街道*/
@property (nonatomic, copy) NSString *shipStreet;
/**街道ID*/
@property (nonatomic, copy) NSString *shipStreetID;

@end


@class AddressInfoModel;
@interface AddressListModel : MoenBaseModel

/**数据信息*/
@property (nonatomic, strong) NSArray<AddressInfoModel *> *addressList;

@end



NS_ASSUME_NONNULL_END
