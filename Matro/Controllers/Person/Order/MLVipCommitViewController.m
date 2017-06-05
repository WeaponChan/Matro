//
//  MLVipCommitViewController.m
//  Matro
//
//  Created by LHKH on 16/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipCommitViewController.h"
#import "HFSUtility.h"
#import "HFSConstants.h"
#import "HFSServiceClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+HeinQi.h"
#import "SBJSON.h"
#import "CommonHeader.h"
#import "MBProgressHUD+Add.h"
#import "MLHttpManager.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MLShippingaddress.h"
#import "MLVipModifyViewController.h"
#import "MLVipCommitInfoViewController.h"
@interface MLVipCommitViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,modifyValueDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{

    UILabel *niChengLabel;
    UILabel *sexLabel;
    UILabel *realNameLabel;
    UILabel *IDcardLabel;
    UILabel *phoneLabel;
    UILabel *areaLabel;
    UILabel *addressLabel;
    NSUserDefaults *userDefaults;
    BOOL isHeader;
    int seltype;
    UIControl *_blackView;
    NSString *idcardNo;
    BOOL isYiSQ;
    
}
@property (weak, nonatomic) IBOutlet UIView *pickerRootView;
@property (weak, nonatomic) IBOutlet UIPickerView *addressPickerView;
@property (nonatomic,strong)NSMutableArray *addressData;
@property (strong,nonatomic)NSDictionary *inforesult;

@end
static MLShippingaddress *province,*city,*area;
@implementation MLVipCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"会员卡升级";
    self.infoTableView.scrollEnabled = NO;
//    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commitBtn.layer.cornerRadius = 4.f;
    self.commitBtn.layer.masksToBounds = YES;
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT -  160)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    NSString *string = [[NSString alloc]initWithContentsOfFile:[self getDocumentpath] encoding:NSUTF8StringEncoding error:nil];
    
    if (!string) {
        [self getAllarea];
    }
    else{
        SBJSON *sbjson = [SBJSON new];
        NSArray *ary = [sbjson objectWithString:string error:nil];
        
        NSArray *modelArt = [MLShippingaddress mj_objectArrayWithKeyValuesArray:ary];
        self.addressData = [modelArt mutableCopy];
        
        province = [self.addressData firstObject];
        if (province.sub.count>0) {
            city = [province.sub firstObject];
            if (city.sub.count>0) {
                area = [city.sub firstObject];
            }
        }
        [self.addressPickerView reloadAllComponents];
        
    }
    [self curCardUserInfo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getShengjiStatus:self.selcardID];

}

//获取当前卡的用户信息
-(void)curCardUserInfo{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradMember",MATROJP_BASE_URL];
    
    NSDictionary *params = @{@"cardId":self.selcardID};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject====%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            self.inforesult = responseObject[@"data"][@"memberInfo"];
            [self.infoTableView reloadData];
            
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];
}

-(void)getShengjiStatus:(NSString*)ID{
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=getCradStatus",MATROJP_BASE_URL];
    NSLog(@"self.selcardID====%@",self.selcardID);
    NSDictionary *params = @{@"cardId":ID};
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject---->%@",responseObject);
        if ([responseObject[@"code"] isEqual:@0]) {
            if ([responseObject[@"data"][@"cardInfo"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *cardInfoDic = responseObject[@"data"][@"cardInfo"];
                NSString *applyFlag = cardInfoDic[@"applyFlag"];
                if ([applyFlag isEqualToString:@"1"]) {
                    isYiSQ = YES;
                }else{
                    isYiSQ = NO;
                }
            }
        }else{
            //            NSString *msg = responseObject[@"msg"];
            //            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0){
        cell.textLabel.text = @"  真实姓名";
        realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        NSString *name = @"";
        if (self.inforesult && ![self.inforesult[@"name"] isKindOfClass:[NSNull class]]) {
            name = self.inforesult[@"name"];
            if (name.length > 0) {
                realNameLabel.text = name;
//                realNameLabel.textAlignment = NSTextAlignmentRight;
//                realNameLabel.font = [UIFont systemFontOfSize:15.0];
//                realNameLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
            }else{
                realNameLabel.text = @"";
            }
            
        }else{
            realNameLabel.text = @"";
        }
        realNameLabel.textAlignment = NSTextAlignmentRight;
        realNameLabel.font = [UIFont systemFontOfSize:15.0];
        realNameLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        [cell.contentView addSubview:realNameLabel];
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"  性别";
        sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        if (self.inforesult && ![self.inforesult[@"sex"] isKindOfClass:[NSNull class]]) {
            NSString *sexLX = self.inforesult[@"sex"];
           
                if ([sexLX isEqual:@0]) {
                    sexLabel.text = @"男";
                }else if([sexLX isEqual:@1]){
                    sexLabel.text = @"女";
                }
//                sexLabel.textAlignment = NSTextAlignmentRight;
//                sexLabel.font = [UIFont systemFontOfSize:15.0];
//                sexLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
            
        }else{
            sexLabel.text = @"";
        }
        sexLabel.textAlignment = NSTextAlignmentRight;
        sexLabel.font = [UIFont systemFontOfSize:15.0];
        sexLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        [cell.contentView addSubview:sexLabel];
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"  身份证";
        IDcardLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        NSString *sfzstr ;
       
        if (self.inforesult[@"idcard"] && ![self.inforesult[@"idcard"] isKindOfClass:[NSNull class]]) {
            
            sfzstr = self.inforesult[@"idcard"];
            idcardNo = self.inforesult[@"idcard"];
        }
        else{
            sfzstr = @"";
        }
        if (sfzstr && ![sfzstr isEqualToString:@""]) {
            NSMutableString *Mutablestr = [NSMutableString stringWithString:sfzstr];
            [Mutablestr replaceCharactersInRange:NSMakeRange(6, 8)withString:@"********"];
            NSString *newsfzstr = [Mutablestr copy];
            IDcardLabel.text = newsfzstr;
        }else{
            IDcardLabel.text = @"";
        }
        
        IDcardLabel.textAlignment = NSTextAlignmentRight;
        IDcardLabel.font = [UIFont systemFontOfSize:15.0];
        IDcardLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        
        [cell.contentView addSubview:IDcardLabel];
        
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"  手机";
        phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH-250, 10, 200, 20)];
        if (self.inforesult[@"phone"] && ![self.inforesult[@"phone"] isKindOfClass:[NSNull class]]) {
            phoneLabel.text = self.inforesult[@"phone"];
            phoneLabel.textAlignment = NSTextAlignmentRight;
            phoneLabel.font = [UIFont systemFontOfSize:15];
            phoneLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        }else{
            phoneLabel.text = @"";
        }
//        phoneLabel.textAlignment = NSTextAlignmentRight;
//        phoneLabel.font = [UIFont systemFontOfSize:15];
//        phoneLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        UIView * kongView = [[UIView alloc]init];
        cell.accessoryView = kongView;
        [cell.contentView addSubview:phoneLabel];
        
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"  所在地区";
        areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        if (self.inforesult[@"address"] && ![self.inforesult[@"address"] isKindOfClass:[NSNull class]] && ![self.inforesult[@"address"] isEqual:@[]]) {
        
            NSDictionary *address = self.inforesult[@"address"];
            if (address) {
                if (address[@"province"] || address[@"city"] ||address[@"county"]) {
                    NSString *province = address[@"province"];
                    NSString *city = address[@"city"];
                    NSString *county = address[@"county"];
                    NSString *userAddr = [NSString stringWithFormat:@"%@ %@ %@",province,city,county];
                    
                    areaLabel.text = userAddr;
                }else{
                    
                    areaLabel.text = @"";
                }
                
                
            }else{
                
                areaLabel.text = @"";
                
            }
//            areaLabel.textAlignment = NSTextAlignmentRight;
//            areaLabel.font = [UIFont systemFontOfSize:15.0];
//            areaLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        }else{
            areaLabel.text = @"";
        }
        
        areaLabel.textAlignment = NSTextAlignmentRight;
        areaLabel.font = [UIFont systemFontOfSize:15.0];
        areaLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        [cell.contentView addSubview:areaLabel];
        
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"  通讯地址";
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 250, 10, 200, 20)];
        
//        addressLabel.text = [userDefaults objectForKey:@"txAddr"];
        if (self.inforesult[@"address"] && ![self.inforesult[@"address"] isKindOfClass:[NSNull class]] && ![self.inforesult[@"address"] isEqual:@[]]) {
            NSDictionary *address = self.inforesult[@"address"];
            if (address) {
                
                NSString *txAddr = address[@"address"];
                
                addressLabel.text = txAddr;
                
            }else{
                addressLabel.text = @"";
            }
//            addressLabel.textAlignment = NSTextAlignmentRight;
//            addressLabel.font = [UIFont systemFontOfSize:15.0];
//            addressLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        }else{
            addressLabel.text = @"";
        }
        addressLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.font = [UIFont systemFontOfSize:15.0];
        addressLabel.textColor = [HFSUtility hexStringToColor:Main_grayBackgroundColor];
        [cell.contentView addSubview:addressLabel];
        
    }
    if (indexPath.row != 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
   if (indexPath.row == 0){
        self.hidesBottomBarWhenPushed = YES;
        MLVipModifyViewController *modifyNameVC = [MLVipModifyViewController new];
        modifyNameVC.navTitle = @"修改真实姓名";
        modifyNameVC.xiugaitype = @"2";
        seltype = 1;
        modifyNameVC.delegate = self;
        modifyNameVC.currentName = realNameLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
   }else if (indexPath.row == 1){
       [self someButtonClicked];
   }else if (indexPath.row == 2){
        self.hidesBottomBarWhenPushed = YES;
        MLVipModifyViewController *modifyNameVC = [MLVipModifyViewController new];
        modifyNameVC.navTitle = @"修改身份证";
        modifyNameVC.xiugaitype = @"3";
        seltype = 2;
        modifyNameVC.delegate = self;
//        NSString *sfzstr = self.inforesult[@"idcard"];
//        modifyNameVC.currentName = sfzstr;
        modifyNameVC.currentName = IDcardLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }else if(indexPath.row == 4){
        NSLog(@"点击了地址");
        _blackView.hidden = _pickerRootView.hidden = NO;
        
    }else if(indexPath.row == 5){
        self.hidesBottomBarWhenPushed = YES;
        MLVipModifyViewController *modifyNameVC = [MLVipModifyViewController new];
        modifyNameVC.navTitle = @"修改通讯地址";
        modifyNameVC.xiugaitype = @"5";
        seltype = 5;
        modifyNameVC.delegate = self;
        modifyNameVC.currentName = addressLabel.text;
        [self.navigationController pushViewController:modifyNameVC animated:YES];
    }
    
}

#pragma mark 修改 代理
-(void)modifyValue:(NSString *)value{
    NSLog(@"value---->%@",value);
    if (seltype == 1) {
        realNameLabel.text = value;
    }
    if (seltype == 2) {
        NSString *sfzstr = value;
        idcardNo = value;
        NSMutableString *Mutablestr = [NSMutableString stringWithString:sfzstr];
        [Mutablestr replaceCharactersInRange:NSMakeRange(6, 8)withString:@"********"];
        NSString *newsfzstr = [Mutablestr copy];
        IDcardLabel.text = newsfzstr;
    }
    if (seltype == 5) {
        addressLabel.text = value;
    }
}
#pragma end mark
#pragma mark 性别
- (void)someButtonClicked {
    UIActionSheet * sheet;
    sheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"点击了第几个按钮result = %d", (int)buttonIndex);
    if(buttonIndex == 0){
        sexLabel.text = @"男";
    }
    else if (buttonIndex == 1){
        sexLabel.text = @"女";
        }
}

//获取行政区
- (void)getAllarea
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_orderadder&do=dis",MATROJP_BASE_URL];
    [MLHttpManager get:urlStr params:nil m:@"member" s:@"admin_orderadder" success:^(id responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        
        if ([[result objectForKey:@"code"] isEqual:@0]) {
            
            NSDictionary *data = result[@"data"];
            NSArray *district_info = [MLShippingaddress mj_objectArrayWithKeyValuesArray:data[@"district_info"]];
            NSArray *tmp = [MLShippingaddress mj_keyValuesArrayWithObjectArray:district_info];
            NSLog(@"%@",tmp);
            
            SBJSON *sbjson = [SBJSON new];
            NSError *error;
            NSString *jsonstr = [sbjson stringWithObject:tmp error:&error];
            if (jsonstr) {
                [jsonstr writeToFile:[self getDocumentpath] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            }
            
            [self.addressData addObjectsFromArray:district_info];
            province = [self.addressData firstObject];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                if (city.sub.count>0) {
                    area  = [city.sub firstObject];
                }
            }
            [self.addressPickerView reloadAllComponents];
        }else{
            NSString *msg = result[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessag:NETWORK_ERROR_MESSAGE toView:self.view];
    }];
    
}

- (NSString*)getDocumentpath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Area.json"]];
    return filePath;
}

#pragma mark- UIPickerViewDataSource and UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    
    switch (component) {
        case 0:
            return self.addressData.count;
            break;
        case 1:
            return province.sub.count;
            break;
        default:
        {
            return city.sub.count;;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
        {
            MLShippingaddress *add = [self.addressData objectAtIndex:row];
            return add.name;
        }
            break;
        case 1:
        {
            MLShippingaddress *tt = [province.sub objectAtIndex:row];
            return tt.name;
        }
            
            break;
        default:
        {
            MLShippingaddress *tt = [city.sub objectAtIndex:row];
            return tt.name;
        }
            break;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumFontSize = 8.;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            province = [self.addressData objectAtIndex:row];
            [self.addressPickerView reloadComponent:1];
            if (province.sub.count>0) {
                city = [province.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:1 animated:YES];
                if (city.sub.count>0) {
                    [self.addressPickerView reloadComponent:2];
                    area = [city.sub firstObject];
                    [_addressPickerView selectRow:0 inComponent:2 animated:YES];
                }
            }
            [_addressPickerView reloadComponent:2];
            break;
        case 1:
            city = [province.sub objectAtIndex:row];
            [self.addressPickerView reloadComponent:2];
            if (city.sub.count>0) {
                area = [city.sub firstObject];
                [_addressPickerView selectRow:0 inComponent:2 animated:YES];
            }
            
            break;
        case 2:
            area = [city.sub objectAtIndex:row];
            break;
        default:
            
            break;
    }
}

- (NSMutableArray *)addressData{
    if (!_addressData) {
        _addressData = [NSMutableArray array];
    }
    return _addressData;
}
- (IBAction)cancelButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
}
- (IBAction)addressSureButtonAction:(id)sender {
    _blackView.hidden = _pickerRootView.hidden = YES;
    NSString *newaddress = [NSString stringWithFormat:@"%@ %@ %@",province?province.name:@"",city?city.name:@"",area?area.name:@""];
    if (newaddress.length >0) {
        areaLabel.text = newaddress;
    }
    
}
- (IBAction)commitClick:(id)sender {
    if (isYiSQ == YES) {
        [MBProgressHUD show:@"此卡已提交升级请求" view:self.view];
        return;
    }
    if (realNameLabel.text == nil || [realNameLabel.text isEqualToString:@""]) {
        [MBProgressHUD show:@"真实姓名不能为空" view:self.view];
        return;
    }
    if (IDcardLabel.text == nil || [IDcardLabel.text isEqualToString:@""]) {
        [MBProgressHUD show:@"身份证号码不能为空" view:self.view];
        return;
    }
    if ([self judgeIdentityStringValid:idcardNo] == NO) {
        [MBProgressHUD show:@"身份证号码格式不对" view:self.view];
        return;
    }
    if (addressLabel.text == nil || [addressLabel.text isEqualToString:@""]) {
        [MBProgressHUD show:@"通讯地址不能为空" view:self.view];
        return;
    }
    if (areaLabel.text == nil || [areaLabel.text isEqualToString:@""]) {
        [MBProgressHUD show:@"所在地区不能为空" view:self.view];
        return;
    }
    if (sexLabel.text == nil || [sexLabel.text isEqualToString:@""]) {
        [MBProgressHUD show:@"性别不能为空" view:self.view];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@/api.php?m=member&s=admin_cardup&action=setCradMember",MATROJP_BASE_URL];
    NSString *sex = @"";
    if ([sexLabel.text isEqualToString:@"男"]) {
        sex = @"0";
    }else{
        sex = @"1";
    }
    
    NSDictionary *params = @{@"cardId":self.selcardID,@"name":realNameLabel.text,@"sex":sex,@"idcard":idcardNo,@"phone":phoneLabel.text,@"address":addressLabel.text,@"area_str":areaLabel.text};
    NSLog(@"params----->%@",params);
    [MLHttpManager post:url params:params m:@"member" s:@"admin_cardup" success:^(id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        
        if ([responseObject[@"code"] isEqual:@0]) {
            NSDictionary *data = responseObject[@"data"];
            NSString *flag = data[@"flag"];
            if ([flag isEqual:@1]) {
                MLVipCommitInfoViewController *vc = [[MLVipCommitInfoViewController alloc]init];
                vc.isSJ = YES;
                vc.isSJSH = NO;
                vc.selcardID = self.selcardID;//cardid
                vc.selcardId = self.selCardId;//typeid
                vc.cardNo = self.selCardNo;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD show:@"提交失败" view:self.view];
            }
        }else{
            NSString *msg = responseObject[@"msg"];
            [MBProgressHUD show:msg view:self.view];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD show:[NSString stringWithFormat:@"%@",error] view:self.view];
    }];
    
}

- (NSDictionary *)inforesult{
    if (!_inforesult) {
        _inforesult = [NSDictionary dictionary];
    }
    return _inforesult;
}

#pragma mark 判断身份证号是否合法
- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    NSLog(@"identityString===%@",identityString);
//    identityString = @"340826199203293410";
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
