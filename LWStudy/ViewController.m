//
//  ViewController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "ViewController.h"
#import "GCDStudyController.h"
#import "PanReturnController.h"
#import "NSOperationStudyController.h"
#import "RunLoopStudyController.h"
#import "AFNStudyController.h"
#import "DrawStudyVC.h"
#import "RunTimeStudyController.h"
#import "CoreDataTestController.h"
#import "BlockStudyController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"学习";
//    [_btnThread addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//     [_btn_return addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //hah哈哈哈哈哈
    
  const  int a=10;
    int *p=&a;
    *p=20;
    NSLog(@"%d",a);
    
    
    
   const  NSString  *str=@"aaaa";
      
    NSLog(@"%p---%p----%p",str,&str,@"aaaa");
    
    
    NSString *name=@"liwanlu";
    
     NSLog(@"方法外部：name指针地址:%p,name指针指向的对象内存地址:%p",&name,name);
    [self testString:name];
    
    
    //需要进行处理的 自然语句
       //NSString * string = @"What is the weather in San Francisco?";
       NSString *string = @"我爸就是山东东阿阿胶胶厂厂长长孙孙山了";
       //NSString *string = @"我在四川成都？";
       //NSString *string = @"社会のセグメントは、その職務を遂行します";
       //步骤1.NSLinguisticTaggerOptions 设置自然语言筛选条件
       NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerJoinNames |NSLinguisticTaggerOmitPunctuation;
       
       //步骤2.通过设置 标签处理方案和语言 获取对应的方案枚举数组
       //只设置 自然语言的类型
       //NSArray *arr = [NSLinguisticTagger availableTagSchemesForLanguage:@"zh-Hans"];
       //设置 语言的处理方式和语言类型
       NSArray *arr = [NSLinguisticTagger availableTagSchemesForUnit:NSLinguisticTaggerUnitWord|NSLinguisticTaggerUnitDocument language:@"zh-Hans"];
       
       //步骤3.创建自然语言处理标签器 设置语言处理方案 和 筛选条件
       NSLinguisticTagger * tagger = [[NSLinguisticTagger alloc]initWithTagSchemes:arr options:options];
       //步骤4.给处理器器设置处理的字符串
       tagger.string = string;
       //步骤5.根据设置的字符串，获取字符串的语言类型，BCP-47
       NSString *language = tagger.dominantLanguage;
       NSLog(@"语言类型:%@",tagger.dominantLanguage);
       //步骤6.执行筛选的处理
       [tagger enumerateTagsInRange:NSMakeRange(0, string.length) scheme:NSLinguisticTagSchemeScript  options:options usingBlock:^(NSString * _Nonnull tag, NSRange tokenRange, NSRange sentenceRange, BOOL * _Nonnull stop) {
           
           //步骤7.根据返回数据  判断 获取 想要的结果
           
           NSString *token = [string substringWithRange:tokenRange];
           NSLog(@"==>%@:%@",token,tag);
       }];
    
    
  
    
    
}
-(void)testString:(NSString *)name
{
    //方法参数name是一个指针，指向传入的参数指针所指向的对象内存地址。name是在栈中
     //通过打印地址可以看出来，传入参数的对象内存地址与方法参数的对象内存地址是一样的。但是指针地址不一样。
     NSLog(@"方法内部：name指针地址:%p,name指针指向的对象内存地址:%p",&name,name);
    
    //*person 是指针变量,在栈中, [Person new]是创建的对象,放在堆中。
    //person指针指向了[Person new]所创建的对象。
    //那么[Person new]所创建的对象的引用计数器就被+1了,此时[Person new]对象的retainCount为1
    //alloc是为Person对象分配内存,init是初始化Person对象。本质上跟[Person new]一样。
//    Person *person = [[Person alloc] init];
}

- (IBAction)btnCLick:(UIButton *)sender {
    
    if(sender.tag==1)
    {
        NSOperationStudyController *thread=[NSOperationStudyController new];
        [self.navigationController pushViewController:thread animated:YES];
    }
    else if (sender.tag==2)
    {
        PanReturnController *thread=[PanReturnController new];
        [self.navigationController pushViewController:thread animated:YES];
    }
    else if(sender.tag==3)
    {
        
        RunLoopStudyController *thread=[RunLoopStudyController new];
        [self.navigationController pushViewController:thread animated:YES];
    }
    else if(sender.tag==4)
    {
        
        AFNStudyController *thread=[AFNStudyController new];
        [self.navigationController pushViewController:thread animated:YES];
    }
    else if(sender.tag==5)
    {
        
        DrawStudyVC *draw=[DrawStudyVC new];
        [self.navigationController pushViewController:draw animated:YES];
    }
    else if(sender.tag==6)
      {
          
          RunTimeStudyController *runtime=[RunTimeStudyController new];
          [self.navigationController pushViewController:runtime animated:YES];
      }
    else if(sender.tag==7)
         {
             
             CoreDataTestController *runtime=[CoreDataTestController new];
             [self.navigationController pushViewController:runtime animated:YES];
         }
    else if (sender.tag==8)
    {
        BlockStudyController *block=[BlockStudyController new];
        [self.navigationController pushViewController:block animated:YES];
    }
}
@end
