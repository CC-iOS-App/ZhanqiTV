//
//  NetworkSingleton.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/6/18.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "NetworkSingleton.h"

@implementation NetworkSingleton


+ (NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}


- (HttpClient *)getHttpClient
{
    HttpClient *_httpClient = [[HttpClient alloc]init];
    
    return _httpClient;
}


+ (void)httpGET:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBolock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [[NetworkSingleton sharedManager].getHttpClient httpGET:appUrl headerWithUserInfo:headerWithUserInfo parameters:parameters successBolock:successBlock failureBlock:failureBlock];
}

+ (void)httpGET:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [[NetworkSingleton sharedManager].getHttpClient httpGET:appUrl parametersUrl:url headerWithUserInfo:headerWithUserInfo parameters:parameter successBlock:successBlock failureBlock:failureBlock];
}


+ (void)httpPOST:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [[NetworkSingleton sharedManager].getHttpClient httpPOST:appUrl headerWithUserInfo:headerWithUserInfo parameters:parameters successBlock:successBlock failureBlock:failureBlock];
}

+ (void)httpPOST:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [[NetworkSingleton sharedManager].getHttpClient httpPOST:appUrl parametersUrl:url headerWithUserInfo:headerWithUserInfo parameters:parameter successBlock:successBlock failureBlock:failureBlock];
}
@end
