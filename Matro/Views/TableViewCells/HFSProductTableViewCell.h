//
//  HFSProductTableViewCell.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLProductModel.h"

@interface HFSProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tisLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isShouqing;
@property (weak, nonatomic) IBOutlet UILabel *cuxiaoPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *ActivityView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img1W;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img2W;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img3W;

@property (nonatomic,strong)MLProductModel *product;



@end
