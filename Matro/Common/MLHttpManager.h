//
//  MLHttpManager.h
//  Matro
//
//  Created by MR.Huang on 16/6/22.
//  Copyright © 2016年 HeinQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface MLHttpManager : NSObject

+ (NSString *)md5:(NSString *)str;

+ (void)get:(NSString *)url params:(id)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(id)params  m:(NSString *)m  s:(NSString *)s sconstructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(id)params m:(NSString *)m s:(NSString *)s success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;



@end
