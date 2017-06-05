//
//  MLVipCardListCell.h
//  Matro
//
//  Created by Matro on 2016/12/23.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ShezhimorenBlock)();
typedef void (^ShenjiBlock)();
typedef void (^ErweimaBlock)();

@interface MLVipCardListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardImg;
@property (weak, nonatomic) IBOutlet UIButton *sjBtn;
@property (weak, nonatomic) IBOutlet UIView *sjView;
@property (weak, nonatomic) IBOutlet UIButton *szBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sjViewH;
@property (weak, nonatomic) IBOutlet UILabel *sjLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNo;
@property (copy,nonatomic)ShezhimorenBlock shezhiClick;
@property (copy,nonatomic)ShenjiBlock shenjiClick;
@property (copy,nonatomic)ErweimaBlock erweimaClick;
@end
