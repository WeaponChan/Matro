//
//  AppDelegate.h
//  Matro
//
//  Created by NN on 16/3/20.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "MLPushMessageModel.h"
#import "UPPaymentControl.h"

#import "MLAnimationViewController.h"
// 窗口的高度
#define XWWindowHeight 20
// 动画的执行时间
#define XWDuration 0.5
// 窗口的停留时间
#define XWDelay 1.5
// 字体大小
#define XWFont [UIFont systemFontOfSize:12]

static NSString *appKey = @"beddefb33f6e5abc8d411c2b";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong)MLPushMessageModel *pushMessage;


@property (strong, nonatomic) UITabBarController *tabBarController;
@property BOOL isFinished;
@property BOOL isShiXiao;
@property (copy,nonatomic)NSString *appFlag;
@property (copy,nonatomic)NSString *shixiaoMsg;

- (void)autoLogin;
- (NSString*)deviceVersion;
- (void)deviceInfo;
+(AppDelegate *)sharedAppDelegate;


@end

