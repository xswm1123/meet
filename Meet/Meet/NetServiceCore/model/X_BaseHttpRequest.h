//
//  X_BaseHttpRequest.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X_BaseHttpRequest : NSObject
-(void)setRequestPath:(NSString *)path;

-(NSString *)requestPath;

@end
