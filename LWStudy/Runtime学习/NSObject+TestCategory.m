//
//  NSObject+TestCategory.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/29.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSObject+TestCategory.h"
#import <objc/runtime.h>

@implementation NSObject (TestCategory)

static char *testNameKey="testNamekey";

-(void)setTestName:(NSString *)testName
{
    //添加关联属性
    /*
        objc_AssociationPolicy参数使用的策略：
        OBJC_ASSOCIATION_ASSIGN;            //assign策略
        OBJC_ASSOCIATION_COPY_NONATOMIC;    //copy策略
        OBJC_ASSOCIATION_RETAIN_NONATOMIC;  // retain策略

        OBJC_ASSOCIATION_RETAIN;
        OBJC_ASSOCIATION_COPY;
        */
       /*
        关联方法：
        objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);

        参数：
        * id object 给哪个对象的属性赋值
        const void *key 属性对应的key
        id value  设置属性值为value
        objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
        */
    objc_setAssociatedObject(self, testNameKey, testName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)testName
{
    return objc_getAssociatedObject(self, testNameKey);
}
@end
