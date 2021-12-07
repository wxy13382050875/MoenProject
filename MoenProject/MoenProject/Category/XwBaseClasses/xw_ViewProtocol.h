//
//  xw_BaseViewProtocol.h
//  XW_Object
//
//  Created by Benc Mai on 2019/11/28.
//  Copyright © 2019 武新义. All rights reserved.
//

#ifndef xw_BaseViewProtocol_h
#define xw_BaseViewProtocol_h

@protocol xw_ViewModelProtocol;

@protocol xw_ViewProtocol <NSObject>

@optional

-(instancetype)initWithViewModel:(id <xw_ViewModelProtocol>)viewModel;

-(void)xw_bindViewModel;
-(void)xw_setupUI;
-(void)xw_updateConstraints;
@end

#endif /* xw_BaseViewProtocol_h */
