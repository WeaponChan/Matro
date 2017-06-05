//
//  MLShopBagOutdateCell.m
//  Matro
//
//  Created by Matro on 2016/12/16.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopBagOutdateCell.h"
#import "UIImageView+WebCache.h"
#import "HFSConstants.h"

@implementation MLShopBagOutdateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statuLab.layer.cornerRadius = 4.f;
    self.statuLab.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProlistModel:(MLProlistOutModel *)prolistModel{
    if (_prolistModel != prolistModel) {
        _prolistModel = prolistModel;
        if ([_prolistModel.pic hasSuffix:@"webp"]) {
            [self.goodImgView setZLWebPImageWithURLStr:_prolistModel.pic withPlaceHolderImage:PLACEHOLDER_IMAGE];
        } else {
            [self.goodImgView sd_setImageWithURL:[NSURL URLWithString:_prolistModel.pic] placeholderImage:PLACEHOLDER_IMAGE];
        }
        self.goodName.text = _prolistModel.pname;
        //        if ([_prolistModel.pro_setmeal_price isEqual:nil]) {
        //             self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.realPrice];
        //        }else{
        //            float realPrice = [_prolistModel.pro_setmeal_price floatValue];
        //             self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f",realPrice];
        //        }
        self.goodStatu.text = _prolistModel.status_name;
        self.goodPrice.text =[NSString stringWithFormat:@"￥%.2f", _prolistModel.realPrice];
        
        if (_prolistModel.setmealname.length> 0 ) {
            self.goodDesc.text = [NSString stringWithFormat:@"%@",_prolistModel.setmealname];
        }
        self.goodNum.text = [NSString stringWithFormat:@"X%ld",_prolistModel.num];
    }
}


@end
