//
//  MLShopBQCell.m
//  Matro
//
//  Created by LHKH on 2017/2/9.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import "MLShopBQCell.h"
#import "UIColor+HeinQi.h"
#import "UIButton+Lhkh.h"
#import "HFSUtility.h"
#import "CommonHeader.h"
@implementation MLShopBQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.jiageBtn ChangeImageAndTitle];
    ZLLabelCustom *label = [ZLLabelCustom new];
    label.spView  = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x, label.frame.origin.y+21, label.frame.size.width, 1)];
    label.spView.backgroundColor = [HFSUtility hexStringToColor:Main_home_jinse_backgroundColor];
    
}

- (IBAction)shouyeClick:(UIButton*)sender {
    if (self.shouyeClick) {
        self.shouyeClick(sender.tag);
    }
}
- (IBAction)allClick:(UIButton*)sender {
    if (self.allClick) {
        self.allClick(sender.tag);
    }
}
- (IBAction)tuijianClick:(UIButton*)sender {
    if (self.tuijianClick) {
        self.tuijianClick(sender.tag);
    }
}
- (IBAction)xinpinClick:(UIButton*)sender {
    if (self.xinpinClick) {
        self.xinpinClick(sender.tag);
    }
}
- (IBAction)xiaoliangClick:(id)sender {
    if (self.xiaoliangClick) {
        self.xiaoliangClick();
    }
}
- (IBAction)jiageClick:(id)sender {
    if (self.jiageClick) {
        self.jiageClick();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
