//
//  MLShopBagOutdateHeaderView.h
//  Matro
//
//  Created by Matro on 2016/12/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLShopCarOutListModel.h"
typedef void(^ShopHeadOutClick)();

@interface MLShopBagOutdateHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong)UILabel *titleLabel;
@property (copy,nonatomic) ShopHeadOutClick shopOutdateBlock;
@property (nonatomic,strong)MLShopingCartOutModel *shopingCart;
@end
