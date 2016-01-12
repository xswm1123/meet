//
//  X_BaseHttpResponse.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X_BaseHttpResponse : NSObject
/**
 *  服务端返回的基本参数，成功标志，参数说明，返回说明等；
 */
@property(nonatomic,strong) NSString* code;
@property(nonatomic,strong) NSString * message;
@property(nonatomic,strong) NSDictionary *  data;
@end
