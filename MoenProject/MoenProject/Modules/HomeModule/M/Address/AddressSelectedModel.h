//
//  AddressSelectedModel.h
//  MoenProject
//
//  Created by Kevin Jin on 2019/1/2.
//  Copyright © 2019年 Kevin Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressSelectedModel : MoenBaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *largeRegionId;

@property (nonatomic, copy) NSString *pvceName;


@property (nonatomic, copy) NSString *pvceId;

@property (nonatomic, copy) NSString *ctName;


@property (nonatomic, copy) NSString *ctId;

@property (nonatomic, copy) NSString *disName;

@property (nonatomic, copy) NSString *stName;

@end


@class AddressSelectedModel;
@interface AddressSelectedListModel : MoenBaseModel

@property (nonatomic, strong) NSArray<AddressSelectedModel *> *provinceList;

@property (nonatomic, strong) NSArray<AddressSelectedModel *> *cityList;

@property (nonatomic, strong) NSArray<AddressSelectedModel *> *districtList;

@property (nonatomic, strong) NSArray<AddressSelectedModel *> *streetList;

@end




NS_ASSUME_NONNULL_END
