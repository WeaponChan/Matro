//
//  MLOrderYouHuiTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/7/8.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLOrderYouHuiTableViewCell.h"
#import "Masonry.h"
#import "HFSConstants.h"
#import "MLYouHuiEditTableViewCell.h"
#import "MLCommitOrderListModel.h"

@interface MLOrderYouHuiTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

{
    NSInteger num;
}

@end


@implementation MLOrderYouHuiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14];
    self.titleLabel = label;
    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    subLabel.font = [UIFont systemFontOfSize:14];
    subLabel.textColor = RGBA(153, 153, 153, 1);
    [headView addSubview:subLabel];
    self.subLabel = subLabel;
    
    UILabel *slabel = [[UILabel alloc]initWithFrame:CGRectZero];
    slabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel = slabel;
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"xiayiye_arrow"];
    [headView addSubview:arrow];
    [headView addSubview:label];
    [headView addSubview:slabel];
    [self addSubview:headView];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = RGBA(245, 245, 245, 1);
    [headView addSubview:line];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.bounces = NO;
    [tableView registerNib:[UINib nibWithNibName:@"MLYouHuiEditTableViewCell" bundle:nil] forCellReuseIdentifier:kYouHuiEditTableViewCell];
    self.tableView = tableView;
    [self addSubview:tableView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.left.right.top.equalTo(self);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(16);
        make.centerY.equalTo(headView);
    }];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(8);
        make.centerY.equalTo(headView);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headView).offset(-16);
        make.centerY.equalTo(headView);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(8);
    }];
    [slabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(arrow.mas_left).offset(-8);
        make.centerY.equalTo(headView);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(16);
        make.right.equalTo(headView).offset(-16);
        make.bottom.equalTo(headView);
        make.height.mas_equalTo(1);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(headView.mas_bottom);
    }];
 
}


#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cart.yhqdata.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLYouHuiEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYouHuiEditTableViewCell forIndexPath:indexPath];
    __weak typeof(self) weakself = self;
    
    if (weakself.isBack == YES) {
        cell.isSubback = YES;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.row == 0) {
        [userDefaults setObject:cell.priceLabel.text forKey:@"0"];
        if (weakself.isBack == YES) {
            NSString *str0 = [userDefaults objectForKey:@"0"];
            if (str0.length > 0) {
                self.youHuiQuanZ.useSum = [str0 substringFromIndex:1].floatValue;
            }
        }
    }else if (indexPath.row == 1){
        [userDefaults setObject:cell.priceLabel.text forKey:@"1"];
        if (weakself.isBack == YES) {
            NSString *str1 = [userDefaults objectForKey:@"1"];
            if (str1.length > 0) {
                self.youHuiQuanZ.useSum = [str1 substringFromIndex:1].floatValue;
            }
        }
    }else if (indexPath.row == 2){
        [userDefaults setObject:cell.priceLabel.text forKey:@"2"];
        if (weakself.isBack == YES) {
            NSString *str2 = [userDefaults objectForKey:@"1"];
            if (str2.length > 0) {
                self.youHuiQuanZ.useSum = [str2 substringFromIndex:1].floatValue;
            }
        }
    }else if (indexPath.row == 3){
        [userDefaults setObject:cell.priceLabel.text forKey:@"3"];
        if (weakself.isBack == YES) {
            NSString *str3 = [userDefaults objectForKey:@"1"];
            if (str3.length > 0) {
                self.youHuiQuanZ.useSum = [str3 substringFromIndex:1].floatValue;
            }
        }
    }else if (indexPath.row == 4){
        [userDefaults setObject:cell.priceLabel.text forKey:@"4"];
        if (weakself.isBack == YES) {
            NSString *str4 = [userDefaults objectForKey:@"1"];
            if (str4.length > 0) {
                self.youHuiQuanZ.useSum = [str4 substringFromIndex:1].floatValue;
            }
            
        }
    }else if (indexPath.row == 5){
        [userDefaults setObject:cell.priceLabel.text forKey:@"5"];
        if (weakself.isBack == YES) {
            NSString *str5 = [userDefaults objectForKey:@"1"];
            if (str5.length > 0) {
                self.youHuiQuanZ.useSum = [str5 substringFromIndex:1].floatValue;
            }
        }
    }
    MLYouHuiQuanModel *model = [self.cart.yhqdata objectAtIndex:indexPath.row];
    cell.youHuiQuan = model;
    cell.cartModel = self.cart;
    cell.changeBlock = ^(){
        if (weakself.useClick) {
            if (indexPath.row == 0) {
                [userDefaults setObject:cell.priceLabel.text forKey:@"0"];
                
            }else if (indexPath.row == 1){
                [userDefaults setObject:cell.priceLabel.text forKey:@"1"];
                
            }else if (indexPath.row == 2){
                [userDefaults setObject:cell.priceLabel.text forKey:@"2"];
                
            }else if (indexPath.row == 3){
                [userDefaults setObject:cell.priceLabel.text forKey:@"3"];
                
            }else if (indexPath.row == 4){
                [userDefaults setObject:cell.priceLabel.text forKey:@"4"];
               
            }else if (indexPath.row == 5){
                [userDefaults setObject:cell.priceLabel.text forKey:@"5"];
                
            }
            weakself.useClick();
        }
    };
    cell.youhuiWarning = ^(NSString *msg){
        if (weakself.warningBlock) {
            self.warningBlock(msg);
        }
    };
    
    return cell;
}


- (void)setCart:(MLOrderCartModel *)cart{
    if (_cart != cart) {
        _cart = cart;
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88.f;
}



@end
