//
//  MLShopBQCell.h
//  Matro
//
//  Created by LHKH on 2017/2/9.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLabelCustom.h"
typedef void(^ShouyeButtonBlock)(NSInteger tag);
typedef void(^AllButtonBlock)(NSInteger tag);
typedef void(^TuijianButtonBlock)(NSInteger tag);
typedef void(^XinpinButtonBlock)(NSInteger tag);
typedef void(^xiaoliangButtonBlock)();
typedef void(^jiageButtonBlock)();
@interface MLShopBQCell : UITableViewCell

@property(copy,nonatomic)ShouyeButtonBlock shouyeClick;
@property(copy,nonatomic)AllButtonBlock allClick;
@property(copy,nonatomic)TuijianButtonBlock tuijianClick;
@property(copy,nonatomic)XinpinButtonBlock xinpinClick;
@property(copy,nonatomic)xiaoliangButtonBlock xiaoliangClick;
@property(copy,nonatomic)jiageButtonBlock jiageClick;
@property (weak, nonatomic) IBOutlet UIButton *xiaoliangBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiageBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouyeLab;
@property (weak, nonatomic) IBOutlet UIView *shoueyeView;
@property (weak, nonatomic) IBOutlet UILabel *allLab;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet ZLLabelCustom *tuijianLab;
@property (weak, nonatomic) IBOutlet UIView *tuijianView;
@property (weak, nonatomic) IBOutlet ZLLabelCustom *xinpinLab;
@property (weak, nonatomic) IBOutlet UIView *xinpinView;
@property (weak, nonatomic) IBOutlet UIView *shaixView;
@end
