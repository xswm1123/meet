//
//  X_BaseAPI.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "X_BaseHttpRequest.h"
#import "X_BaseHttpResponse.h"
#import "MBProgressHUD.h"
#import "SystemHttpResponse.h"

@interface X_BaseAPI : NSObject
/**
 *  取消所有的网络数据请求
 *cancel all http request
 *
 *  @param path 
 */
+(void)cancelAllHttpRequestByApiPath:(NSString *)path;
/**
 *  POST请求方式
 *
 *  @param request       baseRequest
 *  @param path          baseURL
 *  @param sucess        sucess callBack
 *  @param fail          fail callBack
 *  @param responseClass
 */
+(void)postHttpRequest:(X_BaseHttpRequest *)request apiPath:(NSString *)path Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass;
/**
 *  GET请求方式
 *
 *  @param request       baseRequest
 *  @param path          baseURL
 *  @param sucess        sucess callBack
 *  @param fail          fail callBack
 *  @param responseClass 
 */
+(void)getHttpRequest:(X_BaseHttpRequest *)request apiPath:(NSString *)path Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *))fail class:(Class)responseClass;
/**
 *  GET请求，返回ID类型的对象
 *
 *  @param request
 *  @param path
 *  @param sucess
 *  @param fail
 *  @param getHttpRequest
 */
+(void)getHttpRequest:(X_BaseHttpRequest *)request apiPath:(NSString *)path Success:(void (^)(id data))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail;
/**
 *  MD5加密接口
 *
 *  @param request
 *  @param path
 *  @param encryptedKey   秘钥
 *  @param sucess
 *  @param fail
 *  @param responseClass
 */
+(void)getHttpRequest:(X_BaseHttpRequest *)request
              apiPath:(NSString *)path
         encryptedKey:(NSString *)encryptedKey
              Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass;
/**
 *  上传文件接口
 *
 *  @param fileData      数据
 *  @param name          名称
 *  @param fileName      文件名称
 *  @param mimeType      文件类型
 */
+(void)uploadFile:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail class:(Class)responseClass;
/**
 *  下载文件
 *
 *  @param path          文件下载路径
 *  @param sucess
 *  @param fail
 *  @param responseClass 
 */
+(void)downLoadFilesWithURL:(NSString*)path Success:(void (^)(X_BaseHttpResponse * response,NSURL *filePath))sucess fail:(void (^)(BOOL NotReachable,NSString *description))fail;
/**
 *  上传视频
 *
 */
+(void)uploadVideo:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType Success:(void (^)(X_BaseHttpResponse *))sucess fail:(void (^)(BOOL NotReachable,NSString *descript))fail;
@end
