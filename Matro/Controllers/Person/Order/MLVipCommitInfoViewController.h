//
//  MLVipCommitInfoViewController.h
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLVipCommitInfoViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UILabel *cardLab;
@property (weak, nonatomic) IBOutlet UILabel *cardStatu;
@property (weak, nonatomic) IBOutlet UILabel *cardInfo;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLab;
@property (weak, nonatomic) IBOutlet UIButton *kefuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardStatuLabW;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLab;
@property (weak, nonatomic) IBOutlet UIButton *VIPZCBtn;
@property (copy,nonatomic)NSString *selcardID;//cardid
@property (copy,nonatomic)NSString *selcardId;//typeid
@property (copy,nonatomic)NSString *selSJcardId;//typeid
@property (copy,nonatomic)NSString *cardNo;
@property (copy,nonatomic)NSString *cardName;
@property BOOL isSJ;
@property BOOL isSJSH;
@end
