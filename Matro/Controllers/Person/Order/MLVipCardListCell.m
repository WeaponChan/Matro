//
//  MLVipCardListCell.m
//  Matro
//
//  Created by Matro on 2016/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLVipCardListCell.h"
#import "UIColor+HeinQi.h"
@implementation MLVipCardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sjBtn.layer.borderWidth = 1.f;
    self.sjBtn.layer.borderColor = [UIColor colorWithHexString:@"996633" ].CGColor;
    self.sjBtn.layer.cornerRadius = 4.f;
    self.sjBtn.layer.masksToBounds = YES;
//    self.cardImg.layer.cornerRadius = 4.f;
//    self.cardImg.layer.masksToBounds = YES;
}

- (IBAction)shezhimorenact:(id)sender {
    if (self.shezhiClick) {
        self.shezhiClick();
    }
}

- (IBAction)shenjiact:(id)sender {
    if (self.shenjiClick) {
        self.shenjiClick();
    }
}
- (IBAction)erweimaact:(id)sender {
    if (self.erweimaClick) {
        self.erweimaClick();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
