//
//  ZFMaskView.m
//  ScanBarCode
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZFMaskView.h"

static CGFloat ZFScanRatio = 0.54f;

@interface ZFMaskView()

@property (nonatomic, strong) UIImageView * scanLineImg;
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UIImageView * scanbgImgView;

@property (nonatomic, strong) UIButton * beginBtn;
@property (nonatomic, strong) UIBezierPath * bezier;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
/** 第一次旋转 */
@property (nonatomic, assign) CGFloat isFirstTransition;

@end

@implementation ZFMaskView

- (void)commonInit{
    _isFirstTransition = YES;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [self addUI];
    }
    return self;
}

/**
 *  添加UI
 */
- (void)addUI{
    self.clipsToBounds = YES;
    //遮罩层
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.5;
    self.maskView.layer.mask = [self maskLayer];
    [self addSubview:self.maskView];
    
    self.beginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.beginBtn setTitleColor:AppTitleWhiteColor forState:UIControlStateNormal];
    self.beginBtn.titleLabel.font = FONTLanTingR(15);
    [self.beginBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
    [self.beginBtn addTarget:self action:@selector(startToScanAction) forControlEvents:UIControlEventTouchDown];
    [self.beginBtn setBackgroundColor:UIColorFromRGB(0x4E4E4E)];
    [self addSubview:self.beginBtn];
    
    
    
    //边框
    UIImage * scanbgImg = [UIImage imageNamed:@"s_scan_bg_icon"];
    //左上
    self.scanbgImgView = [[UIImageView alloc] init];
    self.scanbgImgView.image = scanbgImg;
    [self addSubview:self.scanbgImgView];
    
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"s_scan_line_icon"];
    self.scanLineImg = [[UIImageView alloc] init];
    self.scanLineImg.image = scanLine;
    [self.scanLineImg setHidden:YES];
    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.scanLineImg];
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
    
    self.scanbgImgView.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.frame.size.width * ZFScanRatio);
    //扫描线
    self.scanLineImg.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, scanLine.size.height);
    
}

/**
 *  动画
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    
    //第一次旋转
    if (_isFirstTransition) {
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y - self.frame.size.height * ZFScanRatio * 0.5 + self.scanLineImg.image.size.height * 0.5))];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y + self.frame.size.height * ZFScanRatio * 0.5 - self.scanLineImg.image.size.height * 0.5))];
            
        //竖屏
        }else{
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y - self.frame.size.width * ZFScanRatio * 0.5 + self.scanLineImg.image.size.height * 0.5))];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + self.frame.size.width * ZFScanRatio * 0.5 - self.scanLineImg.image.size.height * 0.5)];
        }
        
        _isFirstTransition = NO;
        
        //非第一次旋转
    }else{
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.scanLineImg.frame.origin.y + self.frame.size.width * ZFScanRatio - self.scanLineImg.frame.size.height * 0.5)];
            
            
            //竖屏
        }else{
            
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.scanLineImg.frame.origin.y + self.frame.size.height * ZFScanRatio - self.scanLineImg.frame.size.height * 0.5)];
        }
    }
    
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    self.bezier = nil;
    self.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //第一次旋转
    if (_isFirstTransition) {
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, self.frame.size.height * ZFScanRatio)] bezierPathByReversingPath]];
            
            //竖屏
        }else{
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.frame.size.width * ZFScanRatio)] bezierPathByReversingPath]];
        }
    
    //非第一次旋转
    }else{
        //横屏
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
            
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.width * ZFScanRatio)) * 0.5, self.frame.size.width * ZFScanRatio, self.frame.size.width * ZFScanRatio)] bezierPathByReversingPath]];
            
            //竖屏
        }else{
            [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.height * ZFScanRatio)) * 0.5, (self.frame.size.height - (self.frame.size.height * ZFScanRatio)) * 0.5, self.frame.size.height * ZFScanRatio, self.frame.size.height * ZFScanRatio)] bezierPathByReversingPath]];
        }
    }
    
    return self.bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [self maskPath].CGPath;
    
    return self.shapeLayer;
}

#pragma mark - public method

- (void)startToScanAction
{
    [self.beginBtn setHidden:YES];
    [self.scanLineImg setHidden:NO];
    if ([self.delegate respondsToSelector:@selector(ZFMaskViewStartScan)]) {
        [self.delegate ZFMaskViewStartScan];
    }
}

- (void)stopToScanAction
{
    [self.beginBtn setHidden:NO];
    [self.scanLineImg setHidden:YES];
}


/**
 *  移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

@end
