//
//  UIButton+Lhkh.m
//  Matro
//
//  Created by LHKH on 2017/2/9.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import "UIButton+Lhkh.h"

@implementation UIButton (Lhkh)
//左右调换
- (void)ChangeImageAndTitle {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width+10, 0, -titleSize.width-10);
    self.titleEdgeInsets = UIEdgeInsetsMake(0 , -imageSize.width , 0 ,imageSize.width);
}
@end
