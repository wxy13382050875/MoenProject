//
//  xw_StoreOrderViewModel.m
//  MoenProject
//
//  Created by wuxinyi on 2021/9/1.
//  Copyright © 2021 Kevin Jin. All rights reserved.
//

#import "xw_StoreOrderViewModel.h"

@implementation xw_StoreOrderViewModel
- (instancetype)init
{
    if(self = [super init])
    {
    }
    return self;
}
-(void)xw_initialize
{

    
}
-(RACCommand*)requestCommand{
    if (!_requestCommand) {
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
               
                
//                [PPNetworkHelper POST:[xw_HttpRequest xw_RefreshUserInfo] parameters:@{} responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//
//                    [subscriber sendNext:responseObject];
//                    [subscriber sendCompleted];
//
//                } failure:^(NSError *error) {
//                    [subscriber sendError:error];
//                    [subscriber sendCompleted];
//                }];
                return nil;
            }];
        }];
    }
    return _requestCommand;
}
@end
