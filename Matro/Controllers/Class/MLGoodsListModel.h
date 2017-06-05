//
//  MLGoodsListModel.h
//  Matro
//
//  Created by LHKH on 2017/2/13.
//  Copyright © 2017年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLGoodsListModel : NSObject
//id = "12635",
//countryImg = <null>,
//money = <null>,
//activity_pics = 	(
//                     "http://img-test.matrostyle.com/uploadfile/new_activity/app_1.png",
//                     "http://img-test.matrostyle.com/uploadfile/new_activity/app_3.png",
//                     ),
//promotion_price = 0,
//brand_name = "资生堂",
//userid = "20505",
//way = "3",
//company = "lj店铺名称",
//from_module = "product",
//pic = "http://bbctest.matrojp.com/uploadfile/product/SPXSM/o_1a6klpjs01etupa9kd46c81ih7.jpg",
//price = "33.60",
//countryName = <null>,
//deliveryDay = "0",
//pname = "水之密语凝润滋养洗发露200ml"

@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,copy)NSString *company;
@property (nonatomic,copy)NSString *pname;
@property (nonatomic,copy)NSString *brand_name;
@property (nonatomic,copy)NSString *pic;
@property (nonatomic,assign)float price;
@property (nonatomic,assign)float promotion_price;
@property (nonatomic,copy)NSString *way;
@property (nonatomic,strong)NSArray *activity_pics;

@end
