//
//  MLVipModifyViewController.m
//  Matro
//
//  Created by LHKH on 16/12/27.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipModifyViewController.h"
#import "MLVipCommitViewController.h"
#import "MBProgressHUD+Add.h"
@interface MLVipModifyViewController ()<UITextFieldDelegate>

@end

@implementation MLVipModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navTitle;
    self.PassValue.delegate = self;
    [self createView];
    self.baocunBtn.layer.cornerRadius = 4.f;
    self.baocunBtn.layer.masksToBounds = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:gesture];
    
}

- (void)createView {
    
    if ([self.xiugaitype isEqualToString:@"1"]) {
        self.PassValue.placeholder = @"请输入新的昵称";
    }else if ([self.xiugaitype isEqualToString:@"2"]){
        self.PassValue.placeholder = @"请输入您的真实姓名";
    }else if ([self.xiugaitype isEqualToString:@"3"]){
        self.PassValue.placeholder = @"请输入您的身份证号";
    }else if ([self.xiugaitype isEqualToString:@"5"]){
        self.PassValue.placeholder = @"请输入您的通讯地址";
    }
    self.PassValue.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.PassValue.text = self.currentName;
    
    
    [self.PassValue becomeFirstResponder];
    
}
- (void)tap {
    [self.PassValue resignFirstResponder];
}
- (IBAction)baocunClick:(id)sender {
    if ([self.xiugaitype isEqualToString:@"1"]) {
        
    }else if ([self.xiugaitype isEqualToString:@"2"]){
       
    }else if ([self.xiugaitype isEqualToString:@"3"]){
        
        if (self.PassValue.text == nil || self.PassValue.text.length < 18 || self.PassValue.text.length >18 || [self isPureint:self.PassValue.text] == NO ) {
            [MBProgressHUD show:@"请输入正确的身份证号码" view:self.view];
            return;
        }
    }else if ([self.xiugaitype isEqualToString:@"5"]){
        
    }
    if ([self.delegate respondsToSelector:@selector(modifyValue:)]) {
        [self.delegate modifyValue:self.PassValue.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)isPureint:(NSString *)string{
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [self validateNumber:string];
}
-(BOOL)validateNumber:(NSString*)num{
    BOOL res = YES;
    NSCharacterSet *temset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < num.length) {
        NSString *string = [num substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:temset];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
