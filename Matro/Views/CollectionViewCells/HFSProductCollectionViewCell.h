//
//  HFSProductCollectionViewCell.h
//  FashionShop
//
//  Created by 王闻昊 on 15/9/29.
//  Copyright © 2015年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kProductCollectionViewCell  @"productCollectionViewCell"
@interface HFSProductCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *productImgview;
@property (weak, nonatomic) IBOutlet UILabel *productnameLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *isShouqing;
@property (weak, nonatomic) IBOutlet UILabel *cuxiaoPrice;
@property (weak, nonatomic) IBOutlet UIView *ActivitycollectView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *img3W;

@end
