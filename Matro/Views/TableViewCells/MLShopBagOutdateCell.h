//
//  MLShopBagOutdateCell.h
//  Matro
//
//  Created by Matro on 2016/12/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "MLShopCarOutListModel.h"

#define kShopBagOutadateViewCell   @"ShopBagOutadateViewCell"
@interface MLShopBagOutdateCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodDesc;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodNum;
@property (weak, nonatomic) IBOutlet UILabel *goodStatu;
@property (weak, nonatomic) IBOutlet UIView *Line;
@property (nonatomic,strong)MLProlistOutModel *prolistModel;
@property (weak, nonatomic) IBOutlet UILabel *statuLab;
@end
