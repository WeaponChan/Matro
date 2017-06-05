//
//  MLPushMessageModel.h
//  Matro
//
//  Created by MR.Huang on 16/6/29.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PushMessageType){
    PushMessageSystem,
    PushMessageActive
};

typedef NS_ENUM(NSInteger,PushMessageGOType){
    PushMessageGOCenter = 1,//进入消息中心
    PushMessageGOUrl,
    PushMessageGOReturns,
    PushMessageGOProductDetail,
    PushMessageGODingdanDetail = 5,
    PushMessageGOVipList = 8,
    PushMessageGOVipDetail = 9
};


@interface MLPushMessageModel : NSObject

@property (nonatomic,copy)NSString *link;
@property (nonatomic,assign)PushMessageType type;
@property (nonatomic,assign)PushMessageGOType go;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *pro_id;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,strong)NSDictionary *card_info;


@end
