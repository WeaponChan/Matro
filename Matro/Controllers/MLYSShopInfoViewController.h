//
//  MLYSShopInfoViewController.h
//  Matro
//
//  Created by LHKH on 2017/2/7.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import "MLBaseViewController.h"

@interface MLYSShopInfoViewController : MLBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headBgImg;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *headShopImg;
@property (weak, nonatomic) IBOutlet UILabel *haopingLab;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headLvImg;
@property(copy,nonatomic)NSString *dpid;
@end
