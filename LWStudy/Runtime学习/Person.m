//
//  Person.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

int test3Int;

@implementation Person
{
    int test1int;
    NSString *test2Str;
}
+(void)load
{
    //类加载时会回调这个方法
    
    //动态添加了一个方法
    class_addMethod(self, @selector(testNoFoundMethod:), (IMP)foundMethod, "v@:@");
}
-(int)eat:(NSString *)footName andWhere:(NSString *)where
{
    NSLog(@"%@吃%@%@",_pName,footName,where);
    
    return 100;
}
-(void)go:(NSString *)where
{
     NSLog(@"%@去%@",_pName,where);
}
-(void)showRunTimeInfo
{
    
    
    /*
     property和ivar的区别：property=ivar+getter+setter
     所以propertyName输出为xxx，而ivar输出为_xxx;因为ivar仅仅是代表_xxx这个变量
     property只会列出用@property修饰的属性。而ivar会列出所有变量，包括顶部那两个test1，test2,但全局变量test3，两个都不包含。
     */
    
     unsigned int count;// 用于记录列表内的数量，进行循环输出
     //取出来的属性是当前类的，不包括父类的
    objc_property_t *propertyList=class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
       const char *propertyName=property_getName(propertyList[i]);
        NSLog(@"propertyName:%@",[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]);
    }
    
    free(propertyList);
    
    
    //获取方法,依然只能获取该类下面的， 不包括父类。但是多了个cxx_destruct方法，不知道作用
    
    Method *methodList=class_copyMethodList([self class], &count);
    
    for (int i=0; i<count; i++) {
        
         NSLog(@"methodName:%@",NSStringFromSelector(method_getName(methodList[i])));
        
    }
    
    //注意：ivar列表是不可变的，在类生成后无法修改。所以这个方法只能是新建类时使用，所以添加失败
    if(class_addIvar([self class], "personHeight", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *)))
    {
        NSLog(@"添加成功");
    }
    else
    {
         NSLog(@"添加失败");
    }
    
    
    // 获取成员变量列表,也是该类下面的，不包含父类
     Ivar *ivarList = class_copyIvarList([self class], &count);
     for ( int i=0; i < count; i++) {
         Ivar myIvar = ivarList[i];
         const char *ivarName = ivar_getName(myIvar);
         const char *ivarType = ivar_getTypeEncoding(myIvar);
         
//         id WLJ = object_getIvar(self, myIvar);
         
       id value= [self valueForKey:[NSString stringWithUTF8String:ivarName]];
         
         NSLog(@"Ivar --> %@----%@", [NSString stringWithUTF8String:ivarName], [NSString stringWithUTF8String:ivarType]);
     }
    free(ivarList);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if(sel==@selector(testNoFoundMethod2:))
    {
        NSLog(@"没有实现的方法：%@",NSStringFromSelector(sel));
          
          class_addMethod(self, sel, (IMP)foundMethod, "v@:@");//v表示返回值void，@表示id对象，：表示selctor，所以这里就是无返回值的三个参数方法，参数为：id，selctor，id
          
          return YES;
    }
  
    return [super resolveInstanceMethod:sel];
}

void foundMethod(id self,SEL _cmd,id param1)
{
    NSLog(@"动态实现了方法---param=:%@",param1);
}

/*
 重写下面的方法，可以获取调用不存在的方法时回调
// 调用不存在的类方法时触发，默认返回NO，可以加上自己的处理后返回YES
+ (BOOL)resolveClassMethod:(SEL)sel;

// 调用不存在的实例方法时触发，默认返回NO，可以加上自己的处理后返回YES
+ (BOOL)resolveInstanceMethod:(SEL)sel;

// 将调用的不存在的方法重定向到一个其他声明了这个方法的类里去，返回那个类的target
- (id)forwardingTargetForSelector:(SEL)aSelector;

// 将调用的不存在的方法打包成 NSInvocation 给你，自己处理后调用 invokeWithTarget: 方法让某个类来触发
- (void)forwardInvocation:(NSInvocation *)anInvocation;
*/
-(void)dealloc
{
    NSLog(@"Person[%@] dealloc了",self.pName);
}
@end
