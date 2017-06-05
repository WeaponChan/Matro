//
//  MLShopCarOutListModel.m
//  Matro
//
//  Created by Matro on 2016/12/17.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import "MLShopCarOutListModel.h"

@class MLShopingCartOutModel;
@class MLProlistOutModel;

@implementation MLShopCarOutListModel



+ (NSDictionary *)objectClassInArray{
    return @{@"cart":[MLShopingCartOutModel class]};
}

@end


@implementation MLShopingCartOutModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}


+ (NSDictionary *)objectClassInArray{
    return @{@"prolist":[MLProlistOutModel class]};
}


- (void)setSelect_All:(BOOL)select_All{
    if (_select_All != select_All) {
        _select_All = select_All;
    }
}


- (void)setProlist:(NSArray *)prolist{
    if (_prolist != prolist) {
        _prolist = prolist;
        _isMore = (_prolist.count>2);
    }
    
}



@end

@implementation MLProlistOutModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}




- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] ==NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] ==NSOrderedDescending)
        return NO;
    
    return YES;
}

- (float)realPrice{
    NSDate *now = [NSDate new];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[self.promition_start_time floatValue]];
    NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:[self.promition_end_time floatValue]];
    if ([self date:now isBetweenDate:startTime andDate:endTime]) { //在促销期间
        return self.promotion_price;
    }else{
        return self.pro_price;
    }
}




@end
