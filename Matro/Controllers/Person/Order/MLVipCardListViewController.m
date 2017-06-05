//
//  MLVipCardListViewController.m
//  Matro
//
//  Created by Matro on 2016/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipCardListViewController.h"
#import "MLVipCardListCell.h"
#import "MNNMemberViewController.h"
#import "MLVipSJDetailViewController.h"
#import "MNNQRCodeViewController.h"
#import "UIColor+HeinQi.h"
#import "MLVipCardListModel.h"
#import "MJExtension.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MLHttpManager.h"
#import "CommonHeader.h"
#import "MLVipShengjiViewController.h"
@interface MLVipCardListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *cardListArr;
    BOOL isling;
    NSString *SelCardNo;
    NSString *SelCardName;
}
//@property (strong,nonatomic)NSMutableArray *cardListArr;
@property (strong,nonatomic)MLVipCardListModel *cardList;
@end

@implementation MLVipCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会员卡";
    cardListArr = [NSMutableArray array];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [button setTitle:@"升级明细" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:RGBA(174, 142, 93, 1) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.VipCardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getShengjiCardList];
    
}
//获取crad列表
-(void)getShengjiCardList{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=cardList",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        NSLog(@"result===%@",result);
        if ([result[@"code"] isEqual:@0]) {
            [cardListArr removeAllObjects];
            NSArray *tempArr;
            tempArr = (NSArray*)result[@"data"][@"cardList"];
            [cardListArr addObjectsFromArray:tempArr];
            
            [self.VipCardTableView reloadData];
            
        }
        else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD showMessag:msg toView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showSuccess:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}
-(void)buttonAction{
    MLVipSJDetailViewController *vc = [[MLVipSJDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cardListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MLVipCardListCell";
    MLVipCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cardListArr.count > 0) {
        NSDictionary *cardDic = cardListArr[indexPath.row];
        NSString *isdefault = cardDic[@"isDefault"];
        if ([isdefault isEqualToString:@"1"]) {
            cell.szBtn.selected = YES;
        }else{
            cell.szBtn.selected = NO;
        }
        NSString *cardimg = cardDic[@"cardImgSimple"];
        if (cardDic[@"cardImgSimple"] && ![cardDic[@"cardImgSimple"] isKindOfClass:[NSNull class]]) {
            if (cardimg.length > 0 ) {
                if ([cardimg hasSuffix:@"webp"]) {
                    [cell.cardImg setZLWebPImageWithURLStr:cardimg withPlaceHolderImage:PLACEHOLDER_IMAGE];
                } else {
                    [cell.cardImg sd_setImageWithURL:[NSURL URLWithString:cardimg] placeholderImage:[UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME]];
                }
            }
        }else{
            cell.cardImg.image = [UIImage imageNamed:VIPCARDLISTIMG_DEFAULTNAME];
        
        }
        
        NSString *cardBH = cardDic[@"cardNo"];
        cell.cardNo.text = cardBH;
        NSString *status = cardDic[@"upstatus"];
        NSString *upzcrad = cardDic[@"upzcrad"];
        NSInteger upstatus = status.integerValue;
        if (upstatus == 1) {
            cell.sjView.hidden = NO;
            cell.sjViewH.constant = 30;
            if ([upzcrad isEqualToString:@"01"]) {
                cell.sjLab.text = @"此卡可升级为金卡，点击升级";
            }else if ([upzcrad isEqualToString:@"02"]){
                cell.sjLab.text = @"此卡可升级为铂金卡，点击升级";
            }else if ([upzcrad isEqualToString:@"03"]){
                cell.sjLab.text = @"此卡可升级为钻石卡，点击升级";
            }
            
        }else{
            cell.sjView.hidden = YES;
            cell.sjViewH.constant = 0;
        }
        cell.shenjiClick = ^(){
            NSLog(@"点击了升级");
            NSString *cardTypeId = cardDic[@"cardTypeId"];
            NSString *cardNo = cardDic[@"cardNo"];
            NSString *cardTypeName = cardDic[@"cardTypeName"];
            NSString *upzcrad = cardDic[@"upzcrad"];
            NSString *cardID = cardDic[@"cardID"];
            NSString *upgradeCardTypeId = cardDic[@"upgradeCardTypeId"];
            NSLog(@"cardID---->%@",cardID);
            MLVipShengjiViewController *VC = [MLVipShengjiViewController new];
            VC.selCardNo = cardNo;
            VC.selCardID = cardTypeId;
            VC.selCardName = cardTypeName;
            VC.selCardlb = upzcrad;
            VC.selcardID = cardID;
            VC.selSJCardID = upgradeCardTypeId;
            [self.navigationController pushViewController:VC animated:YES];
        };
        cell.shezhiClick = ^(){
            NSLog(@"点击了设置默认");
            if ([isdefault isEqualToString:@"1"]) {
                [MBProgressHUD show:@"此卡已是默认卡" view:self.view];
                return ;
            }else{
                cell.szBtn.selected = !cell.szBtn.selected;
                NSString *cardNo = cardDic[@"cardNo"];
                NSString *cardTypeName = cardDic[@"cardTypeName"];
                SelCardNo = cardNo;
                SelCardName = cardTypeName;
                [self setMoRenCard :cardNo];
            }  
        };
        cell.erweimaClick = ^(){
            NSLog(@"点击了二维码");
            MNNQRCodeViewController *qrCodeVC = [MNNQRCodeViewController new];
            NSString *cardNo = cardDic[@"cardNo"];
            qrCodeVC.cardNo = cardNo;
            [self.navigationController pushViewController:qrCodeVC animated:YES];
        };
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cardListArr.count >0) {
        NSDictionary *cardDic = cardListArr[indexPath.row];
        NSString *status = cardDic[@"upstatus"];
        NSInteger upstatus = status.integerValue;
        if (upstatus == 1) {
            return 160;
        }else{
            return 130;
        }
    }else{
        return 130;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cardListArr.count >0) {
        NSDictionary *cardDic = cardListArr[indexPath.row];
        NSString *cardTypeId = cardDic[@"cardTypeId"];
        NSString *cardNo = cardDic[@"cardNo"];
        NSString *cardID = cardDic[@"cardID"];
        NSString *isdefault = cardDic[@"isDefault"];
        NSString *cardTypeName = cardDic[@"cardTypeName"];
        NSString *upgradeCardTypeId = cardDic[@"upgradeCardTypeId"];
        NSString *upzcrad = cardDic[@"upzcrad"];
        NSString *status = cardDic[@"upstatus"];
        NSInteger upstatus = status.integerValue;
        MNNMemberViewController *vc  = [[MNNMemberViewController alloc]init];
        vc.selCardNo = cardNo;
        vc.selCardName = cardTypeName;
        vc.selCardID = [NSString stringWithFormat:@"%@",cardTypeId];//typeid
        vc.selcardID = cardID;
        vc.selcardLb = upzcrad;
        vc.selSJCardID = upgradeCardTypeId;
        vc.isShouye = NO;
        if (upstatus == 1) {
            vc.isShengji = YES;
        }else{
            vc.isShengji = NO;
        }
        if ([isdefault isEqualToString:@"1"]) {
            vc.isMoren = YES;
        }else{
            vc.isMoren = NO;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
    

}

#pragma mark 设置默认卡
- (void)setMoRenCard:(NSString*)sender{
    if (sender.length > 0) {
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * phone = [userDefaults objectForKey:kUSERDEFAULT_USERPHONE];
        NSString * accessToken = [userDefaults objectForKey:kUSERDEFAULT_ACCCESSTOKEN];
        
        if (accessToken == nil) {
            [_hud show:YES];
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = @"AccessToken已过期";
            [_hud hide:YES afterDelay:2.0f];
            return;
        }
        else{
            NSDictionary * signDic = [HFSUtility SIGNDic:@{@"appSecret":APP_Secrect_ZHOU,@"phone":phone,@"cardNo":sender}];
            NSDictionary * dic2 = @{@"appId":APP_ID_ZHOU,
                                    @"phone":phone,
                                    @"cardNo":sender,
                                    @"sign":signDic[@"sign"],
                                    @"accessToken":accessToken
                                    };
            
            NSData *data2 = [HFSUtility RSADicToData:dic2];
            NSString *ret2 = base64_encode_data(data2);
            
            [self yuanShengMoRenKaWithRet2:ret2];
           
        }
    }
}
#pragma mark 设置默认卡

- (void) yuanShengMoRenKaWithRet2:(NSString *)ret2{
    //GCD异步实现
    //dispatch_queue_t q1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_sync(q1, ^{
    NSString *urlStr = [NSString stringWithFormat:@"%@",BindCard_URLString];
    NSURL * URL = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    NSData *data3 = [ret2 dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data3];
    [request setURL:URL]; //设置请求的地址
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSLog(@"原生错误error:%@",error);
                                      
                                      //请求没有错误
                                      if (!error) {
                                          if (data && data.length > 0) {
                                              //JSON解析
                                              // NSString *result  =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                              NSDictionary * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              //NSLog(@"error原生数据登录：++： %@",yuanDic);
                                              NSLog(@"设置默认卡%@",result);
                                              if([@"1" isEqualToString:[NSString stringWithFormat:@"%@",result[@"succ"]]]){
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = @"默认卡设置成功！";
                                                      [_hud hide:YES afterDelay:1.0f];
                                                  });
                                                  NSString * cardTypeStr = [NSString stringWithFormat:@"%@",SelCardName];
                                                  NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                                  [userDefault setObject:cardTypeStr forKey:KUSERDEFAULT_CARDTYPE_CURRENT];
                                                  [userDefault setObject:SelCardNo forKey:kUSERDEFAULT_USERCARDNO];
                                                  NSLog(@"设置的默认卡号为：%@",SelCardNo);
                                                  [userDefault synchronize];
                                                  [self getShengjiCardList];
                                                  [self.VipCardTableView reloadData];
                                                  
                                              }else{
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [_hud show:YES];
                                                      _hud.mode = MBProgressHUDModeText;
                                                      _hud.labelText = result[@"errMsg"];
                                                      [_hud hide:YES afterDelay:2];
                                                  });
                                              }
                                              
                                          }
                                      }
                                      else{
                                          //请求有错误
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [_hud show:YES];
                                              _hud.mode = MBProgressHUDModeText;
                                              _hud.labelText = REQUEST_ERROR_ZL;
                                              _hud.labelFont = [UIFont systemFontOfSize:13];
                                              [_hud hide:YES afterDelay:1];
                                          });
                                          
                                      }
                                      
                                  }];
    
    [task resume];
    //});
}

- (IBAction)actTel:(id)sender {
    NSString *phoneNum = @"400-885-0668";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
