//
//  MLVipCommitInfoViewController.m
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipCommitInfoViewController.h"
#import "HFSConstants.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "MLVipZhangchengViewController.h"
@interface MLVipCommitInfoViewController ()
{
    NSDictionary  *sjcardInfoDic;
    NSString *simpleRule;
}
@end

@implementation MLVipCommitInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"会员卡升级";
    sjcardInfoDic = [NSDictionary dictionary];
    if (self.isSJ == NO) {
        [self curCardDetail];
    }else{
        [self getCurcardInfo]; 
    }
  
}

//获取列表条转过来的会员卡的详细信息
-(void)curCardDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradJc",MATROJP_BASE_URL];
    NSDictionary *params = @{@"cardTypeId":self.selcardId};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
            NSString *cardimg;
            if (dataDic[@"cardImgSimple"] && ![dataDic[@"cardImgSimple"] isEqualToString:@""]) {
                cardimg = dataDic[@"cardImgSimple"];
            }else{
                cardimg = dataDic[@"cardImg"];
            }
            NSString *cardName = dataDic[@"cardTypeName"];
            NSString *cardRule;
            if (dataDic[@"cardRuleSimple"]) {
                cardRule = dataDic[@"cardRuleSimple"];
            }else{
                cardRule = dataDic[@"cardRule"];
            }
            
            self.cardInfo.text = cardRule;
            self.cardLab.text = cardName;
            self.cardNoLab.text = self.cardNo;
            self.shuomingLab.hidden = YES;
            self.kefuBtn.hidden = YES;
            self.cardStatuLabW.constant = 200;
            self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",cardName];
            if (cardimg.length > 0 ) {
                if ([cardimg hasSuffix:@"webp"]) {
                    [self.cardImg setZLWebPImageWithURLStr:cardimg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [self.cardImg sd_setImageWithURL:[NSURL URLWithString:cardimg] placeholderImage:[UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME]];
                }
            }
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];
}

-(void)sjCardDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradJc",MATROJP_BASE_URL];
    NSDictionary *params = @{@"cardTypeId":self.selSJcardId};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
            NSString *cardimg;
            if (dataDic[@"cardImgSimple"] && ![dataDic[@"cardImgSimple"] isEqualToString:@""]) {
              cardimg = dataDic[@"cardImgSimple"];
            }else{
              cardimg = dataDic[@"cardImg"];
            }
            
            NSString *cardName = dataDic[@"cardTypeName"];
            NSString *cardRuleSimple = dataDic[@"cardRuleSimple"];
            self.cardInfo.text = cardRuleSimple;
            self.cardLab.text = cardName;
            self.cardNoLab.text = self.cardNo;
            self.shuomingLab.hidden = YES;
            self.kefuBtn.hidden = YES;
            self.cardStatuLabW.constant = 200;
            self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",cardName];
            if (cardimg.length > 0 ) {
                if ([cardimg hasSuffix:@"webp"]) {
                    [self.cardImg setZLWebPImageWithURLStr:cardimg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [self.cardImg sd_setImageWithURL:[NSURL URLWithString:cardimg] placeholderImage:[UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME]];
                }
            }
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];
}

-(void)getCurcardInfo{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradStatus",MATROJP_BASE_URL];
    NSDictionary *params = @{@"cardId":self.selcardID};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject=111=%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *cardInfoDic = responseObject[@"data"][@"cardInfo"];
            NSString *upgradeFlag = cardInfoDic[@"upgradeFlag"];
            NSString *checkFlag = cardInfoDic[@"checkFlag"];
            NSString *applyFlag = cardInfoDic[@"applyFlag"];
            NSString *completeFlag = cardInfoDic[@"completeFlag"];
            if (cardInfoDic[@"cardTypeName"]) {
                NSString *cardTypeName = cardInfoDic[@"cardTypeName"];
                self.cardLab.text = cardTypeName;
            }else{
                self.cardLab.text = self.cardName;
            }
            
            if (self.isSJSH == NO) {
                self.cardNoLab.text = self.cardNo;
                
                if ([upgradeFlag isEqualToString:@"01"]) {
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级金卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                    }
                }else if ([upgradeFlag isEqualToString:@"02"]){
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级铂金卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                    }
                }else if ([upgradeFlag isEqualToString:@"03"]){
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级钻石卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                    }
                }
                
                //拉取升级前卡的类型
                NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradJc",MATROJP_BASE_URL];
                NSDictionary *params = @{@"cardTypeId":self.selcardId};
                [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
                    NSLog(@"responseObject=2222=%@",responseObject);
                    if ([responseObject[@"code"] isEqual:@0]) {
                        if ([responseObject[@"data"][@"cardJc"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
                            NSString *cardimg;
                            
                            if (dataDic[@"cardImgSimple"] && ![dataDic[@"cardImgSimple"] isEqualToString:@""]) {
                                cardimg = dataDic[@"cardImgSimple"];
                            }else{
                                cardimg = dataDic[@"cardImg"];
                            }
                            NSString *cardName = dataDic[@"cardTypeName"];
                            self.cardLab.text = cardName;
                            self.shuomingLab.hidden = YES;
                            self.kefuBtn.hidden = YES;
                            self.cardStatuLabW.constant = 200;
                            
                            if (cardimg.length > 0 ) {
                                if ([cardimg hasSuffix:@"webp"]) {
                                    [self.cardImg setZLWebPImageWithURLStr:cardimg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                                } else {
                                    [self.cardImg sd_setImageWithURL:[NSURL URLWithString:cardimg] placeholderImage:[UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME]];
                                }
                            }
                        }else{
                            
                        }
                        
                    }else{
                        NSString *msg = responseObject[@"msg"];
                        [MBProgressHUD show:msg view:self.view];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
                }];
                
            }else{
                self.cardNoLab.text = self.cardNo;
                //拉取升级前卡的类型
                NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradJc",MATROJP_BASE_URL];
                NSDictionary *params = @{@"cardTypeId":self.selcardId};
                [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
                    NSLog(@"responseObject=2222=%@",responseObject);
                    if ([responseObject[@"code"] isEqual:@0]) {
                        if ([responseObject[@"data"][@"cardJc"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
                            NSString *cardimg;
                            
                            if (dataDic[@"cardImgSimple"] && ![dataDic[@"cardImgSimple"] isEqualToString:@""]) {
                                cardimg = dataDic[@"cardImgSimple"];
                            }else{
                                cardimg = dataDic[@"cardImg"];
                            }
                            if (dataDic[@"cardRuleSimple"]) {
                               NSString *cardRuleSimple = dataDic[@"cardRuleSimple"];
                                simpleRule = cardRuleSimple;
                            }else {
                                NSString *cardRule = dataDic[@"cardRule"];
                                simpleRule = cardRule;
                                
                            }
                            if ([upgradeFlag isEqualToString:@"00"]) {
                                NSString *str = dataDic[@"cardTypeName"];
                                self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",str];
                                self.shuomingLab.hidden = YES;
                                self.kefuBtn.hidden = YES;
                                self.cardInfo.text = simpleRule;
                            }
                            if ([checkFlag isEqualToString:@"2"]) {
                                self.cardInfo.text = simpleRule;
                            }
//                            self.cardLab.text = cardName;
//                            self.shuomingLab.hidden = YES;
//                            self.kefuBtn.hidden = YES;
//                            self.cardStatuLabW.constant = 200;
                            
                            if (cardimg.length > 0 ) {
                                if ([cardimg hasSuffix:@"webp"]) {
                                    [self.cardImg setZLWebPImageWithURLStr:cardimg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                                } else {
                                    [self.cardImg sd_setImageWithURL:[NSURL URLWithString:cardimg] placeholderImage:[UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME]];
                                }
                            }
                        }else{
                            
                        }
                        
                    }else{
                        NSString *msg = responseObject[@"msg"];
                        [MBProgressHUD show:msg view:self.view];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
                }];
                
                if ([upgradeFlag isEqualToString:@"01"]) {
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级金卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                        
                    }else if ([checkFlag isEqualToString:@"1"]){
                        if ([completeFlag isEqualToString:@"0"
                             ]) {
                            self.cardStatu.text = @"升级金卡处理中...";
                            self.VIPZCBtn.hidden = YES;
                            self.shuomingLab.hidden = YES;
                            self.kefuBtn.hidden = YES;
                            self.cardStatuLabW.constant = 200;
                            self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                        }else if ([completeFlag isEqualToString:@"1"]){
                            [self sjCardDetail];
                        }
                        
                    }else if ([checkFlag isEqualToString:@"2"]){
                        self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",self.cardName];
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = NO;
                        self.kefuBtn.hidden = NO;
//                        self.cardInfo.text = simpleRule;
                    }
                }else if ([upgradeFlag isEqualToString:@"02"]){
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级铂金卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                    }else if ([checkFlag isEqualToString:@"1"]){
                        if ([completeFlag isEqualToString:@"0"
                            ]) {
                            self.cardStatu.text = @"升级铂金卡处理中...";
                            self.VIPZCBtn.hidden = YES;
                            self.shuomingLab.hidden = YES;
                            self.kefuBtn.hidden = YES;
                            self.cardStatuLabW.constant = 200;
                            self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                        }else if([completeFlag isEqualToString:@"1"]){
                            [self sjCardDetail];
                        }
                        
                    }else if ([checkFlag isEqualToString:@"2"]){
                        self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",self.cardName];
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = NO;
                        self.kefuBtn.hidden = NO;
//                        self.cardInfo.text = simpleRule;
                    }
                }else if ([upgradeFlag isEqualToString:@"03"]){
                    if ([checkFlag isEqualToString:@"0"]) {
                        self.cardStatu.text = @"升级钻石卡处理中...";
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = YES;
                        self.kefuBtn.hidden = YES;
                        self.cardStatuLabW.constant = 200;
                        self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                    }else if ([checkFlag isEqualToString:@"1"]){
                        if ([completeFlag isEqualToString:@"0"
                             ]) {
                            self.cardStatu.text = @"升级钻石卡处理中...";
                            self.VIPZCBtn.hidden = YES;
                            self.shuomingLab.hidden = YES;
                            self.kefuBtn.hidden = YES;
                            self.cardStatuLabW.constant = 200;
                            self.cardInfo.text = @"(我们将会在24小时内完成整个会员卡升级操作，请耐心等候)";
                        }else if([completeFlag isEqualToString:@"1"]){
                            [self sjCardDetail];
                        }
                    }else if ([checkFlag isEqualToString:@"2"]){
                        self.cardStatu.text = [NSString stringWithFormat:@"%@使用中",self.cardName];
                        self.VIPZCBtn.hidden = YES;
                        self.shuomingLab.hidden = NO;
                        self.kefuBtn.hidden = NO;
//                        self.cardInfo.text = simpleRule;
                    }
                }
            
            }
            
            
            
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];

}
- (IBAction)VIPZCClick:(id)sender {
    MLVipZhangchengViewController *VC = [MLVipZhangchengViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)kefuClick:(id)sender {
    NSString *phoneNum = @"400-885-0668";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
