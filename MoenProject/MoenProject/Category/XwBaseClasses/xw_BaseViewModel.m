//
//  xw_BaseViewModel.m
//  XW_Object
//
//  Created by Benc Mai on 2019/11/28.
//  Copyright © 2019 武新义. All rights reserved.
//

#import "xw_BaseViewModel.h"

@implementation xw_BaseViewModel
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    xw_BaseViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel xw_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)xw_initialize {}
-(void)xw_PostResponseData:(NSString*)url params:(NSDictionary* )param success:(void(^)(id dataSource))succeedBlock{
    
}
-(void)xw_GetResponseData:(NSString*)url params:(NSDictionary* )param success:(void(^)(id dataSource))succeedBlock{
    
}
@end
