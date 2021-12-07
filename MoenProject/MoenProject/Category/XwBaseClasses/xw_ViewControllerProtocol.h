//
//  xw_ViewControllerProtocol.h
//  XW_Object
//
//  Created by Benc Mai on 2019/11/28.
//  Copyright © 2019 武新义. All rights reserved.
//

#ifndef xw_ViewControllerProtocol_h
#define xw_ViewControllerProtocol_h

@protocol xw_ViewModelProtocol;

@protocol xw_ViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id <xw_ViewModelProtocol>)viewModel;

-(void)xw_bindViewModel;
-(void)xw_setupUI;
-(void)xw_layoutNavigation;
-(void)xw_loadDataSource;


@end
#endif /* xw_ViewControllerProtocol_h */
