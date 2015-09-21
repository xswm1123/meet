//
//  NSDictionary+XNSDictionaryToNSObject.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/26.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  字典扩展，转换成实例对象
 */
@interface NSDictionary (XNSDictionaryToNSObject)
-(id)objectByClass:(Class)clazz;
@end
/**
 *  NSObject扩展，对象转成字典
 */
@interface NSObject (XNSDictionaryToNSObject)

-(NSDictionary *)lkDictionary;

@end
