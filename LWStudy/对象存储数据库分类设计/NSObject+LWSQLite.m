//
//  NSObject+LWSQLite.m
//  LWStudy
//
//  Created by liwanlu on 2020/10/13.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSObject+LWSQLite.h"
#import <objc/runtime.h>

@implementation NSObject (LWSQLite)

/**
 创建表或修改表结构
 */
+(void)createOrUpdateTable
{
    //检查是否存在表
}
+(void)lw_getAllProperty
{
    unsigned int count;// 用于记录列表内的数量，进行循环输出
      //取出来的属性是当前类的，不包括父类的
     objc_property_t *propertyList=class_copyPropertyList([self class], &count);
     for (int i=0; i<count; i++) {
        const char *propertyName=property_getName(propertyList[i]);
         NSLog(@"propertyName:%@",[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]);
     }
     
     free(propertyList);
}
@end
