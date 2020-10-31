//
//  RunTimeStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "RunTimeStudyController.h"
#import "Student.h"
#import "NSObject+TestCategory.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "NSObject+LWSQLite.h"
#import "TestModel.h"

@interface RunTimeStudyController ()

@end

@implementation RunTimeStudyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Person *person=[Person new];
    person.pName=@"卢大哥";
    person.pAge=30;
    [person eat:@"饭" andWhere:@"在家里"];
    [person go:@"学校"];
    
//    person.schoolName=@"希望小学";
//
//    [person beginStudy:@"金瓶梅"];
    
    
   
    
    [person showRunTimeInfo];
    
    
    //交换两个方法的实现
  Method pM= class_getInstanceMethod([person class], @selector(go:));
    Method VCM = class_getInstanceMethod([self class], @selector(vcGo:));
    
    method_exchangeImplementations(pM, VCM);
    
    [person go:@"机场"];
    [self vcGo:@"超市"];
    
    //runtime执行方法以及回去返回值的方法
   int result=objc_msgSend(person, @selector(eat:andWhere:),@"粪",@"在家");
//    NSLog(@"msgSendResult=%d",[result intValue]);
    
    
    
//    NSInvocation调用方法和获取返回值的方法
    NSMethodSignature *signature = [[person class] instanceMethodSignatureForSelector:@selector(eat:andWhere:)];
    NSInvocation *invocate=[NSInvocation invocationWithMethodSignature:signature];
    [invocate setSelector:@selector(eat:andWhere:)];
    [invocate setTarget:person];
    
    NSString *param1=@"雪盖";
     NSString *param2=@"太阳下";
    
    [invocate setArgument:&param1 atIndex:2];//因为第一个，第二个参数被系统默认的，id self，SEL _cmd,占用了
    [invocate setArgument:&param2 atIndex:3];

    [invocate invoke];

    int returnResult;
    [invocate getReturnValue:&returnResult];
//
//
    
    
    //获取ivar
    Ivar nameIvar=class_getClassVariable(person, "_pName");
    NSInteger nameValue=object_getIvar(person, nameIvar);//用这个方法访问int类型就会报错，不知道原理
    NSLog(@"%d",nameValue);
    //调用没有实现的方法
    
    //这个方法load中动态添加了，可以直接调用
    [person performSelector:@selector(testNoFoundMethod:) withObject:@"paramvalue"];
  
    //这个方法在resolveInstanceMethod中捕捉了，动态添加后调用成功
    [person performSelector:@selector(testNoFoundMethod2:) withObject:@"paramvalue"];

    //分类添加属性的方法
      NSObject *obj=[NSObject new];
      obj.testName=@"ccc";
    
    
    
    NSObject *obj2=[NSObject new];
         obj2.testName=@"ddd";
      
      NSLog(@"obj1.name=%@---obj2.name=%@",obj.testName,obj2.testName);
      
      
    NSLog(@"----------\n-\n-\n-\n---------");
    
    [TestModel lw_getAllProperty];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)vcGo:(NSString *)where
{
    NSLog(@"vcGo：%@",where);
}
@end
