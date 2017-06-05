//
//  FourButtonsView.h
//  Matro
//
//  Created by lang on 16/8/3.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FourButtonBlock)(NSInteger tag);


@interface FourButtonsView : UIView

@property (copy, nonatomic) FourButtonBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab3;
@property (weak, nonatomic) IBOutlet UILabel *titleLab4;





- (void)fourButtonBlockAction:(FourButtonBlock )block;

@end
