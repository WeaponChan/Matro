//
//  MLSecondTableViewCell.m
//  Matro
//
//  Created by Matro on 16/8/2.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLSecondTableViewCell.h"

@implementation MLSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)actLeft:(id)sender {
    if (self.leftClickblock) {
        self.leftClickblock();
    }
}
- (IBAction)actRight:(id)sender {
    if (self.rightClickblock) {
        self.rightClickblock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end