//
//  ThreadStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "NSThreadStudyController.h"
#import <pthread.h>

@interface NSThreadStudyController ()
@property(atomic,assign) int currentCount2;
@end

@implementation NSThreadStudyController
{
    int currentCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"线程学习";
    
//    pthread_t thread;
//
//    pthread_create(&thread, NULL, run, "abcd");
    
    
    //图片下载和转换，线程通讯相关
    /*
    UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:imgview];
    
    NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.maituichina.com/2020/6/2020651591258107378cOUf33.sqlite"]];
    
    
    
    //主要是学习下面两句代码
    if(imgData!=nil)
    {
        NSLog(@"imgData=%.2f MB",imgData.length/1024.0/1024.0);
        UIImage *img=[UIImage imageWithData:imgData];
        if(img!=nil)
        {
            //这也是线程间传值的手段
          [imgview performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
        }
        else
        {
             NSLog(@"转换失败");
        }
    }
    else
    {
        NSLog(@"下载数据失败");
    }
  */
    
    //线程创建方式
    /*
    NSThread *thread1=[[NSThread  alloc] initWithTarget:self selector:@selector(nsThreadRun:) object:@"aaaaa"] ;
       thread1.name=@"lwThread1";
    thread1.threadPriority=0.6;//优先级，0-1，越高被cup执行的几率越高
       
       [thread1 start];
    
    [NSThread detachNewThreadSelector:@selector(nsThreadRun:) toTarget:self withObject:@"detachNewThreadSelector"];//创建后直接执行，不需要start
    
    
    [self performSelectorInBackground:@selector(nsThreadRun2:) withObject:@"performSelectorInBackground"];//一样直接执行
     */
    
    
    
    
    //延时执行
    // [self performSelector:xxx withObject:xxx afterDelay:1];
    
    //线程锁相关
    
    NSThread *CThread1=[[NSThread alloc] initWithTarget:self selector:@selector(testAddCount) object:nil];
    CThread1.name=@"线程1";
    [CThread1 start];
    
    NSThread *CThread2=[[NSThread alloc] initWithTarget:self selector:@selector(testAddCount) object:nil];
      CThread2.name=@"线程2";
      [CThread2 start];
    
}
//void *run(void *param)
//{
//    NSLog(@"aaa,%@",[NSThread currentThread]);
//    return NULL;
//}
-(void)nsThreadRun:(id)param
{
    NSLog(@"nsThreadRun:%@,%@",[NSThread currentThread],param);
    
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
       NSLog(@"休息了3秒");
    
    [NSThread sleepForTimeInterval:1];
        NSLog(@"又休息了1秒");
    NSLog(@"执行结束");
}

-(void)nsThreadRun2:(id)param
{
    for (int i=0; i<100; i++) {
        NSLog(@"执行%d",i);
        if(i==50)
        {
            [NSThread exit];
        }
    }
}

-(void)testAddCount
{
    //没加锁的情况，会出现数据错误
    /*
    for (int i=0; i<100; i++) {
        
           currentCount+=1;
        NSLog(@"%@+1,当前的currentCount=%d",[NSThread currentThread].name,currentCount);
        
        [NSThread sleepForTimeInterval:0.01];
    }
   
    */
    
    //加锁了就会让线程同步执行，即一个完了下一个排队
    
    for (int i=0; i<100; i++) {
          
        //下面锁的参数需要传一个全局对象，因为count不是对象，才用self替换。也可以创建一个全局nsobject放这里。
        @synchronized (self) {
            currentCount+=1;
                  NSLog(@"%@+1,当前的currentCount=%d",[NSThread currentThread].name,currentCount);
                  
                  [NSThread sleepForTimeInterval:0.1];
        }
         
      }
     
    
    //使用nonatomic，atomic测试,结果发现即使使用atomic，下面的结果还是有问题
    /*
    for (int i=0; i<100; i++) {
           
        self.currentCount2+=1;
        NSLog(@"%@+1,当前的currentCount2=%d",[NSThread currentThread].name,self.currentCount2);
           
//           [NSThread sleepForTimeInterval:0.01];
       }
    */
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      NSLog(@"aaa,%@",[NSThread currentThread]);
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    ThreadStudyController *thread=[ThreadStudyController new];
//    [self.navigationController pushViewController:thread animated:YES];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
