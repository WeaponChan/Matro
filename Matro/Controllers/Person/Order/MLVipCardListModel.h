//
//  MLVipCardListModel.h
//  Matro
//
//  Created by Matro on 2016/12/26.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLVipCardListModel : NSObject
@property(nonatomic,copy)NSString *cardID;
@property(nonatomic,copy)NSString *cardNo;
@property(nonatomic,copy)NSString *cardTypeName;
@property(nonatomic,copy)NSString *isDefault;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,assign)NSInteger cardTypeId;
@property(nonatomic,assign)NSInteger upstatus;
@end
