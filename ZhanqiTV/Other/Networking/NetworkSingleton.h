//
//  NetworkSingleton.h
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

typedef void(^SuccessBlock)(NSDictionary *responseBody);
typedef void(^FailureBlock)(NSError *error);
@interface NetworkSingleton : NSObject

+ (NetworkSingleton *)sharedManager;

- (HttpClient *)getHttpClient;
/**
 *  网络请求 GET
 *
 *  @param appUrl                   网络接口对应的appUrl
 *  @param headerWithUserInfo       是否传token uid
 *  @param parameters               网络请求参数
 *  @param successBlock             成功回调Block
 *  @param failureBlock             失败回调Block
 */
+ (void)httpGET:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBolock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)httpGET:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *  网络请求 POST
 *
 *  @param appUrl                   网络接口对应的appUrl
 *  @param headerWithUserInfo       是否传token uid
 *  @param parameters               网络请求参数
 *  @param successBlock             成功回调Block
 *  @param failureBlock             失败回调Block
 */

+ (void)httpPOST:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)httpPOST:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
@end
