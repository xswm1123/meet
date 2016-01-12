//
//  X_BaseHttpRequest.m
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//
#ifdef __OBJC__
#import "X_BaseHttpRequest.h"
#import "ServerConfig.h"
#import "ShareValue.h"
//xxtea加密
#include "XXTEA.h"
#endif
@implementation X_BaseHttpRequest{
    NSString * _requestPath;
}

-(void)setRequestPath:(NSString *)path{
    _requestPath = path;
}

-(NSString *)requestPath{
    return _requestPath;
}

@end
