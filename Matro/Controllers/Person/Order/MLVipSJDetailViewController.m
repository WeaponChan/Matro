//
//  MLVipSJDetailViewController.m
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipSJDetailViewController.h"
#import "MLVipSJdetailTableViewCell.h"
#import "MLHttpManager.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import "UIImage+HeinQi.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface MLVipSJDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sjArray;
}
@end

@implementation MLVipSJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"升级明细";
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    sjArray = [NSMutableArray array];
    [self getSJDetail];
}

-(void)getSJDetail{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=allCradUpLog",MATROJP_BASE_URL];
    [MLHttpManager get:url params:nil m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            NSArray *arr = responseObject[@"data"][@"cardInfo"];
            if ([responseObject[@"data"][@"cardInfo"] isKindOfClass:[NSString class]]) {
                
            }else{
                if (arr.count>0) {
                    [sjArray removeAllObjects];
                    [sjArray addObjectsFromArray:arr];
                    [self.detailTableView reloadData];
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sjArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MLVipSJdetailTableViewCell";
    MLVipSJdetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (sjArray.count > 0) {
        NSDictionary *dic = sjArray[indexPath.row];
        NSLog(@"dic===%@",dic);
        cell.cardNo.text = dic[@"cardNo"];
        cell.cardTime.text = dic[@"completeTime"];
        NSString *upgradeFlag = dic[@"upgradeFlag"];
        if ([upgradeFlag isEqualToString:@"01"]) {
            cell.cardStatus.text = @"升级至金卡";
        }else if ([upgradeFlag isEqualToString:@"02"]){
            cell.cardStatus.text = @"升级至铂金卡";
        }else if ([upgradeFlag isEqualToString:@"03"]){
            cell.cardStatus.text = @"升级至钻石卡";
        }
        cell.cardName.text = dic[@"cardTypeName"];
        /*
        NSString *cardTypeId = dic[@"cardTypeId"];
        if ([cardTypeId isEqual:@101]) {
            cell.cardName.text = @"会员卡(旧)";
        }else if ([cardTypeId isEqual:@102]){
            cell.cardName.text = @"金卡";
        }else if ([cardTypeId isEqual:@103]){
            cell.cardName.text = @"铂金卡";
        }else if ([cardTypeId isEqual:@104]){
            cell.cardName.text = @"钻石卡";
        }else if ([cardTypeId isEqual:@105]){
            cell.cardName.text = @"准VIP卡";
        }else if ([cardTypeId isEqual:@108]){
            cell.cardName.text = @"B2C会员";
        }
         */
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
