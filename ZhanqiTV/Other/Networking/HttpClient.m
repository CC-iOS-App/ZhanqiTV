//
//  HttpClient.m
//  ZhanqiTV
//
//  Created by lechinepay on 16/7/9.
//  Copyright © 2016年 Yu.Z.Y. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient
@synthesize sessionDataTask;

- (AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    //header 设置
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json",@"text/json", nil];
    return manager;
}

/*************************
 *                       *
 *      拼接请求地址       *
 *                       *
 *************************/
- (NSString *)stringHttpUrl:(NSString *)appUrl
{
    NSString *spellString = @"";
    
    if (appUrl.length > 0) {
        return [NSString stringWithFormat:@"%@%@",PREFIX_URL,appUrl];
    }
    return spellString;
}


- (void)httpGET:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBolock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [self httpMethod:appUrl parametersUrl:nil isPostMethod:NO headerWithUserInfo:headerWithUserInfo parameters:nil successBlock:successBlock failureBlock:failureBlock];
}
- (void)httpGET:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [self httpMethod:appUrl parametersUrl:url isPostMethod:NO headerWithUserInfo:headerWithUserInfo parameters:nil successBlock:successBlock failureBlock:failureBlock];
}
- (void)httpPOST:(NSString *)appUrl headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [self httpMethod:appUrl parametersUrl:nil isPostMethod:YES headerWithUserInfo:headerWithUserInfo parameters:nil successBlock:successBlock failureBlock:failureBlock];
}
- (void)httpPOST:(NSString *)appUrl parametersUrl:(NSString *)url headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameter successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    [self httpMethod:appUrl parametersUrl:url isPostMethod:YES headerWithUserInfo:headerWithUserInfo parameters:nil successBlock:successBlock failureBlock:failureBlock];
}

- (void)httpMethod:(NSString *)appurl parametersUrl:(NSString *)url isPostMethod:(BOOL)isPostMethod headerWithUserInfo:(BOOL)headerWithUserInfo parameters:(NSDictionary *)parameters successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHtppRequest];

    NSString *strUrl = [self stringHttpUrl:appurl];
    if (url) {
        strUrl = [NSString stringWithFormat:@"%@%@",strUrl,url];
    }
    
    if (isPostMethod) {//YES
        sessionDataTask = [manager POST:strUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"返回的不是所需的字典格式");
                return;
            }
            NSDictionary *dict = (NSDictionary *)responseObject;
            successBlock(dict);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([error code] == NSURLErrorCancelled) {
                NSLog(@"取消网络");
            }
            else
            {
                NSLog(@"请求网络失败");
            }
        }];
    }
    else
    {
        sessionDataTask = [manager GET:strUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"返回的不是所需的字典格式");
                return;
            }
            NSDictionary *dict = (NSDictionary *)responseObject;
            successBlock(dict);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([error code] == NSURLErrorCancelled) {
                NSLog(@"取消网络");
            }
            else
            {
                NSLog(@"请求网络失败");
            }
        }];
    }
}
@end
