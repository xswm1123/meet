//
//  X_BaseHttpRequest.m
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "X_BaseHttpRequest.h"

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
