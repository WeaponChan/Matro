//
//  MLShopBagOutdateHeaderView.m
//  Matro
//
//  Created by Matro on 2016/12/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagOutdateHeaderView.h"
#import "Masonry.h"
#import "HFSConstants.h"

@implementation MLShopBagOutdateHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView{
   
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLb.font = [UIFont systemFontOfSize:15];
    self.titleLabel = titleLb;
    [self addSubview:titleLb];
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
    arrow.image = [UIImage imageNamed:@"跳转箭头"];
    
    //    self.arrow = arrow;
    [self addSubview:arrow];
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [shopBtn addTarget:self action:@selector(shopOutdateClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopBtn];
    
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectZero];
    downLine.backgroundColor = RGBA(245, 245, 245, 1);
    [self addSubview:downLine];
   
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self).offset(42);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(titleLb.mas_right);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(12);
    }];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLb);
        make.right.equalTo(arrow);
        make.top.bottom.equalTo(self);
    }];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];

    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)setShopingCart:(MLShopingCartOutModel*)shopingCart{
    if (_shopingCart != shopingCart) {
        _shopingCart = shopingCart;
       
        NSString *subTitle = nil;
        switch (_shopingCart.way) {
            case 1:
            {
                subTitle = @"【全球购】";
            }
                break;
            case 2:
            {
                subTitle = @"【跨境购】";
            }
                break;
            case 3:
            {
                subTitle = @"【闪电购】";
            }
                break;
            default:
                break;
        }
        
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",_shopingCart.company,subTitle];
        
    }
}

- (void)shopOutdateClick:(id)sender{
    if (self.shopOutdateBlock) {
        self.shopOutdateBlock();
    }
}

@end
