//
//  MLZTextTableViewCell.m
//  Matro
//
//  Created by MR.Huang on 16/6/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLZTextTableViewCell.h"

@implementation MLZTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
