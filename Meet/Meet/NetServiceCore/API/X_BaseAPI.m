//
//  X_BaseAPI.m
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "X_BaseAPI.h"
#import "NSDictionary+XNSDictionaryToNSObject.h"
#import "ServerConfig.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "NSString+URLEncode.h"
#import <CommonCrypto/CommonDigest.h>

@interface X_BaseAPI (p)
+(AFHTTPRequestOperationManager *)manager;
@end

@implementation X_BaseAPI(p)

+(AFHTTPRequestOperationManager *)manager{
    static dispatch_once_t onceToken;
    static AFHTTPRequestOperationManager *_manager;
    dispatch_once(&onceToken, ^
                  {
                      _manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_SERVERLURL]];
                  });
    return _manager;
}

@end

@implementation X_BaseAPI
+(void)cancelAllHttpRequestByApiPath:(NSString *)path{
    
  }
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
                                     path:(NSString *)path
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    NSString *pathToBeMatched = [[[X_BaseAPI.manager.requestSerializer multipartFormRequestWithMethod:method URLString:path parameters:nil constructingBodyWithBlock:nil error:nil] URL] path];
#pragma clang diagnostic pop
    
    for (NSOperation *operation in [X_BaseAPI.manager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}
+(NSString*)stringCreateJsonWithObject:(id)obj
{
    return [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}
/**
 *  post请求
 *
 *  @param request
 *  @param path
 *  @param sucess
 *  @param fail
 *  @param responseClass
 */
+(void)postHttpRequest:(X_BaseHttpRequest *)request apiPath:(NSString *)path Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass
{
    if (!responseClass)
    {
        responseClass = [X_BaseHttpResponse class];
    }
    NSDictionary *tdict = request.lkDictionary;
    NSLog(@"类型:%@", @"POST");
    NSLog(@"路径:%@", path);
    NSLog(@"参数:%@", tdict);
    AFHTTPRequestOperationManager *manager = X_BaseAPI.manager;
    /**
     *  根据需求这里设置响应方式和请求的header
     */
    manager.responseSerializer=[AFJSONResponseSerializer serializer];

    AFHTTPRequestOperation* op=
    [manager POST:path parameters:tdict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *responseString = (NSDictionary *)responseObject;
         NSLog(@"responseString:%@",responseString);
         if (responseObject) {
             NSObject *object = [responseObject objectByClass:responseClass];
             X_BaseHttpResponse * response = (X_BaseHttpResponse *) object;
             if ([DEFINE_SUCCESSCODE isEqualToString:response.code]) {
                 sucess((X_BaseHttpResponse*)object);
             }else{
                 fail(NO,response.message);
                 NSLog(@"message:%@",response.message);
             }
         }else{
             fail(NO,@"服务器返回数据为空");
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", [error description]);
         fail(YES,@"网络不给力");
     }];
    [op start];
}
/**
 *  get请求
 *
 *  @param request
 *  @param path
 *  @param sucess
 *  @param fail
 *  @param responseClass 
 */
+(void)getHttpRequest:(X_BaseHttpRequest *)request apiPath:(NSString *)path Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [X_BaseHttpResponse class];
    }
    NSDictionary *tdict = request.lkDictionary;
    NSString *paramString = [X_BaseAPI stringCreateJsonWithObject:tdict ];
    NSLog(@"类型:%@", @"GET");
    NSLog(@"路径:%@", path);
    NSLog(@"参数:%@", paramString);
    path = [NSString stringWithFormat:@"%@?",path];
    request.requestPath = path;
    AFHTTPRequestOperationManager *manager = X_BaseAPI.manager;
    /**
     *  根据需求这里设置响应方式和请求的header
     */
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation* op=
    [manager GET:path parameters:tdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseString = (NSDictionary *)responseObject;
        NSLog(@"responseString:%@",responseString);
            if (responseObject) {
                NSObject *object = [responseObject objectByClass:responseClass];
                X_BaseHttpResponse * response = (X_BaseHttpResponse *) object;
                if ([DEFINE_SUCCESSCODE isEqualToString:response.code]) {
                    sucess((X_BaseHttpResponse*)object);
                }else{
                    fail(NO,response.message);
                    NSLog(@"message:%@",response.message);
                }
            }else{
                fail(NO,@"服务器返回数据为空");
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        fail(YES,@"网络不给力");
    }];
    [op start];
}
/**
 *  加密接口
 */
+(void)getHttpRequest:(X_BaseHttpRequest *)request
              apiPath:(NSString *)path
              encryptedKey:(NSString *)encryptedKey
              Success:(void (^)( X_BaseHttpResponse*))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass{
    if (!responseClass) {
        responseClass = [X_BaseHttpResponse class];
    }
    NSDictionary *tdict = request.lkDictionary;
    NSMutableString *paramString = [[NSMutableString alloc]initWithString:[X_BaseAPI stringCreateJsonWithObject:tdict]];
    NSString *dicString = [[NSMutableString alloc]initWithString:[X_BaseAPI stringCreateJsonWithObject:tdict]];
    [paramString appendString:encryptedKey];
    NSLog(@"类型:%@", @"GET");
    NSLog(@"路径:%@", path);
    NSLog(@"参数:%@", paramString);
    NSLog(@"秘钥:%@", encryptedKey);
    NSString *encryptedMSG = [[NSString alloc]init];
    const char *str = [paramString UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    encryptedMSG = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    NSLog(@"密文:%@",encryptedMSG);
    path = [NSString stringWithFormat:@"%@?data=%@&encrypt=%@",path, [dicString URLEncodedString],encryptedMSG];
    request.requestPath = path;
    NSLog(@"转义后报文:%@",path);
    AFHTTPRequestOperationManager *manager = X_BaseAPI.manager;
    /**
     *  根据需求这里设置响应方式和请求的header
     */
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation* op=
    [manager GET:path parameters:tdict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseString = (NSDictionary *)responseObject;
        NSLog(@"responseString:%@",responseString);
        if (responseObject) {
            NSObject *object = [responseObject objectByClass:responseClass];
            X_BaseHttpResponse * response = (X_BaseHttpResponse *) object;
            if ([DEFINE_SUCCESSCODE isEqualToString:response.code]) {
                sucess((X_BaseHttpResponse*)object);
            }else{
                fail(NO,response.message);
            }
        }else{
            fail(NO,@"服务器返回数据为空");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        fail(YES,@"网络不给力");
    }];
    [op start];
}
/**
 *  上传图片接口
 *
 */
+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL, NSString *))fail class:(Class)responseClass{
    AFHTTPRequestOperationManager *manager = X_BaseAPI.manager;
    /**
     *  根据需求这里设置响应方式和请求的header
     */
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    AFHTTPRequestOperation* op=[manager POST:URL_UPLOADFILES parameters:@{fileName:@"fileName"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData!=nil) {
            [formData appendPartWithFileData :fileData name:name fileName:fileName mimeType:mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseString = (NSDictionary *)responseObject;
        NSLog(@"responseString:%@",responseString);
        if (responseObject) {
            NSObject *object = [responseObject objectByClass:responseClass];
            X_BaseHttpResponse * response = (X_BaseHttpResponse *) object;
            if ([DEFINE_SUCCESSCODE isEqualToString:response.code]) {
                sucess((X_BaseHttpResponse*)object);
            }else{
                fail(NO,response.message);
            }
        }else{
            fail(NO,@"服务器返回数据为空");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        fail(YES,@"网络不给力");
    }];
    [op start];
}
/**
 *  下载文件
 */
+(void)downLoadFilesWithURL:(NSString *)path Success:(void (^)(X_BaseHttpResponse * response))sucess fail:(void (^)(BOOL, NSString * description))fail{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        X_BaseHttpResponse* XResponse=[[X_BaseHttpResponse alloc]init];
        sucess(XResponse);
    }];
    [downloadTask resume];
}
/**
 *  上传视频
 */
+(void)uploadVideo:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail{
}
@end
