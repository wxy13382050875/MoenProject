//
//  WelcomeModel.h
//  QZLoan
//
//  Created by Kevin Jin on 2018/11/12.
//

#import <Foundation/Foundation.h>

@interface WelcomeModel : MoenBaseModel

/**版本号*/
@property (nonatomic, copy) NSString *versionNo;

/**版本路径*/
@property (nonatomic, copy) NSString *versionUrl;

/**文件名称*/
@property (nonatomic, copy) NSString *versionFname;

/**终端类型 IOS Android*/
@property (nonatomic, copy) NSString *versionTerminal;

/**版本更新时间*/
@property (nonatomic, copy) NSString *versionTime;

/**版本状态1正常 2异常*/
@property (nonatomic, assign) NSInteger versionStatus;

/***/
@property (nonatomic, assign) NSInteger versionUpdate;

/**1强制更新2不强制更新*/
@property (nonatomic, assign) NSInteger versionToUpdate;


/////////////////////////////
/**最新版本号*/
//@property (nonatomic, copy) NSString *newVersion;

/**是否需要更新（是否需要强制更新）*/
@property (nonatomic, assign) NSInteger forceUpdate;

/**版本发布时间*/
@property (nonatomic, copy) NSString *releaseTime;

/**版本获取地址*/
@property (nonatomic, copy) NSString *apkUrl;

/**IOS、Android*/
@property (nonatomic, copy) NSString *terminalType;


@end
