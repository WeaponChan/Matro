//
//  MLVipShengjiViewController.m
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipShengjiViewController.h"
#import "MLVipCommitViewController.h"
#import "MLVipZhangchengViewController.h"
#import "MLHttpManager.h"
#import "MBProgressHUD+Add.h"
//#import "MLVipCommitInfoViewController.h"

@interface MLVipShengjiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *curCard;
@property (weak, nonatomic) IBOutlet UILabel *curCardInfo;
@property (weak, nonatomic) IBOutlet UILabel *shenjiCard;
@property (weak, nonatomic) IBOutlet UIImageView *shenjiCardImg;
@property (weak, nonatomic) IBOutlet UIButton *shenjiBtn;
@property (weak, nonatomic) IBOutlet UILabel *sjcardinfoLab;

@end

@implementation MLVipShengjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡升级";
    self.shenjiBtn.layer.cornerRadius = 4.f;
    self.shenjiBtn.layer.masksToBounds = YES;
    [self curCardDetail];
    [self sjCardDetail];
}

//获取列表条转过来的会员卡的详细信息
-(void)curCardDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradJc",MATROJP_BASE_URL];
    NSDictionary *params = @{@"cardTypeId":self.selCardID};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
            NSString *cardName = dataDic[@"cardTypeName"];
            self.curCard.text = cardName;
            if ([self.selCardlb isEqualToString:@"01"]) {
                self.curCardInfo.text = @"您的会员卡已达到升级金卡的条件";
                self.shenjiCard.text = @"金卡";
            }else if ([self.selCardlb isEqualToString:@"02"]){
                self.curCardInfo.text = @"您的会员卡已达到升级铂金卡的条件";
                self.shenjiCard.text = @"铂金卡";
            }else if ([self.selCardlb isEqualToString:@"03"]){
                self.curCardInfo.text = @"您的会员卡已达到升级钻石卡的条件级";
                self.shenjiCard.text = @"钻石卡";
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
    NSDictionary *params = @{@"cardTypeId":self.selSJCardID};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject==222==%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *dataDic = responseObject[@"data"][@"cardJc"];
            NSString *cardRuleSimple = dataDic[@"cardRuleSimple"];
            self.sjcardinfoLab.text = cardRuleSimple;
            NSString *cardImg = dataDic[@"cardImg"];
            if (cardImg.length > 0 ) {
                if ([cardImg hasSuffix:@"webp"]) {
                    [self.shenjiCardImg setZLWebPImageWithURLStr:cardImg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [self.shenjiCardImg sd_setImageWithURL:[NSURL URLWithString:cardImg] placeholderImage:[UIImage imageNamed:VIPCARDIMG_DEFAULTNAME]];
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

- (IBAction)zhangchengClick:(id)sender {
    MLVipZhangchengViewController *bindCradVC = [MLVipZhangchengViewController new];
    [self.navigationController pushViewController:bindCradVC animated:YES];
}

- (IBAction)shengjiClick:(id)sender {
    MLVipCommitViewController *vc = [[MLVipCommitViewController alloc]init];
    vc.selCardId = self.selCardID;//typeid
    vc.selcardID = self.selcardID;//cardid
    vc.selCardNo = self.selCardNo;
    [self.navigationController pushViewController:vc animated:YES];
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
