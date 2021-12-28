//
//Created by ESJsonFormatForMac on 21/12/23.
//

#import <Foundation/Foundation.h>

@class Storelist,Inventorylist;
@interface XwStoreListModel : NSObject

@property (nonatomic, strong) NSArray *storeList;

@end
@interface Storelist : NSObject

@property (nonatomic, copy) NSString *storeID;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSArray *inventoryList;

@end



