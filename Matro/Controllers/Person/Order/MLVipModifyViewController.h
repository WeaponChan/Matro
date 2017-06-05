//
//  MLVipModifyViewController.h
//  Matro
//
//  Created by LHKH on 16/12/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"
@class MLVipModifyViewController;
@protocol modifyValueDelegate <NSObject>

-(void)modifyValue:(NSString*)value;

@end

@interface MLVipModifyViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *baocunBtn;
@property (copy, nonatomic) NSString * currentName;
@property (copy, nonatomic) NSString * navTitle;
@property (copy, nonatomic) NSString *xiugaitype;

@property (weak, nonatomic) IBOutlet UITextField *PassValue;

@property id<modifyValueDelegate>delegate;
@end
