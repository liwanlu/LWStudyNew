//
//  RunLoopStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/23.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "RunLoopStudyController.h"

@interface RunLoopStudyController ()

@end

@implementation RunLoopStudyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
     1:runloop概念：app的主runloop其实就是一个死循环，保证程序不退出的。它有5种运行模式。每个新线程也有一个runloop，一比一
     2:NSTimer其实是加载runloop上面运行的。加入时需要指定运行模式，当runloop的运行模式一样，timer才会执行。默认是default模式，当滚动界面时，timer被暂停了，是因为滚动时runloop模式变成了UITrackingRunLoopMode.NSRunLoopCommonModes时占位模式，设置成这个模式，不管runloop什么模式，timer都能执行
     3:GCD的定时器
     */
    
    
    
    /*
     NSUrlConnection相关注意点：如果在子线程中使用urlconnection使用代理方式初始化，初始化后直接执行的方式。代理方法不会被执行。因为对象是局部变量，被回收了。但是，先不执行，调用star方法开始，代理方法却正常执行。为什么？
     因为urlconnection也是放在runloop里面运行的，属于source，子线程的runloop默认没开启，所以被回收后整个线程都结束了。但是调用star方法能正常，因为star方法底层会去开启runloop。
     */
    
    NSTimer *timer=[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
      
      [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)run
{
    NSLog(@"----%@",[NSRunLoop currentRunLoop].currentMode);
}

@end
