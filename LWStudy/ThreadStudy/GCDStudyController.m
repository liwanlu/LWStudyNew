//
//  GCDStudyController.m
//  LWStudy
//
//  Created by liwanlu on 2020/9/22.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "GCDStudyController.h"

@interface GCDStudyController ()

@end

@implementation GCDStudyController
{
    UIImageView *imgview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    imgview=[[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:imgview];
    
    
    
    //首先需要了解队列的概念：队列就是把多个线程放到一个地方一起处理，这个地方就是队列。可以存在多个队列。至于队列里执行顺序，取决于队列的性质，并行，串行。并行就是多个线程一起执行，可能开多个线程。串行就是一个一个执行，只用一个线程
    
    //
    /*
     异步执行下：
     第一个参数：队列的标示，如果标示一样，就是一个队列
     DISPATCH_QUEUE_SERIAL,串行执行，即一个一个任务来，只会开一条线程
     DISPATCH_QUEUE_CONCURRENT，并行执行，即一起执行，无序，可能会开多条线程，系统决定
     同一个队列，串行的话，只开一个线程。队列不一样，即使都是串行，也会开不同的线程
     
     
     同步执行下：
     就简单了，全都是用当前队列，不新开线程，并且顺序执行
     并且，同步函数会马上执行，执行完毕才继续执行后面的代码，而异步会先执行下面的代码，回头再处理新线程
     GCD也可以以调函数的方式执行。使用方法：dispatch_async_f(queue, NSNull, xxx);执行xxx方法，xxx方法需要以c语言编写
     GCD也有dispatch_suspend(queue)方法暂停未开始的操作，dispatch_resume(queue)恢复操作
     */
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    dispatch_queue_t queue= dispatch_queue_create("aaaa", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2= dispatch_queue_create("aaaa2", DISPATCH_QUEUE_SERIAL);
    
    //
    /*
     直接创建一个并行队列的方法
     *  - DISPATCH_QUEUE_PRIORITY_HIGH:        高优先级
     *  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
     *  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
     *  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
     */
    dispatch_queue_t queue3=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    for (int i=0; i<10; i++) {
        if(i%2==0)
        {
//            NSLog(@"2的倍数，用queue2");
          
            dispatch_async(queue2, ^{
                [NSThread sleepForTimeInterval:0.1];
                          NSLog(@"睡眠 %d %@",i,[NSThread currentThread]);
                
                
            });
        }
        else if(i%3==0)
        {
            dispatch_async(queue3, ^{
                                    NSLog(@"3队列 %d %@",i,[NSThread currentThread]);
                          
                          
                      });
        }
        else
        {
            dispatch_async(queue, ^{
                          NSLog(@" %d %@",i,[NSThread currentThread]);
                 });

        }


    }
    
    //同步执行
    /*
    for (int i=0; i<10; i++) {
           if(i%2==0)
           {
               NSLog(@"2的倍数，用queue2");
               dispatch_sync(queue2, ^{
                             NSLog(@" %d %@",i,[NSThread currentThread]);
                    });
           }
           else
           {
               dispatch_sync(queue, ^{
                             NSLog(@" %d %@",i,[NSThread currentThread]);
                    });
                   
           }
         
          
       }
    */
   
    //主线程队列相关
    [self mainQueueTest];
    
  
 
   
    
}

-(void)mainQueueTest
{
    dispatch_get_main_queue();//获取主队列，主线程中执行
        /*
         注意：同步执行传主队列的话，会出错。同步队列只能用async执行，并且是在主线程中执行，原理是串行执行，mainQueueTest必须先执行完成，才会执行里面的代码，但是里面的代码又加了个任务到队列，就死循环了
         */
        dispatch_async(dispatch_get_main_queue(), ^{
                        [NSThread sleepForTimeInterval:1];
                                NSLog(@"main %d %@",0,[NSThread currentThread]);
        });
}

//栅栏
-(void)batterTest
{
    
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    
    for (int i=0; i<10; i++) {
       
            dispatch_async(queue, ^{
                [NSThread sleepForTimeInterval:0.5];
                NSLog(@"1 %d %@",i,[NSThread currentThread]);
                
            });
    }
    
    
    for (int i=0; i<10; i++) {

               dispatch_async(queue, ^{
                   [NSThread sleepForTimeInterval:0.5];
                   NSLog(@"2 %d %@",i,[NSThread currentThread]);
                    
               });
       }
    //必须等这个栅栏线程执行完成，它后面代码里的线程才会开始执行。当然，这个栅栏和上面的线程到底谁先谁后还是不确定的，系统决定。
    dispatch_barrier_sync(queue, ^{
         [NSThread sleepForTimeInterval:2.5];
        NSLog(@"--------------------------拦路虎------------");
    });
    
    for (int i=0; i<10; i++) {

                dispatch_async(queue, ^{
                     [NSThread sleepForTimeInterval:0.1];
                    NSLog(@"3 %d %@",i,[NSThread currentThread]);
                    
                });
        }
    
}

-(void)delayTest
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"延时执行，%@",[NSThread currentThread]);
    });
    
   
}

//快速迭代，即开多个线程进行循环，增加执行效率,以前的for都是一个线程执行
-(void)applyTest
{
     dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    dispatch_apply(1000, queue, ^(size_t index) {
        NSLog(@"%zu---%@",index,[NSThread currentThread]);
    });

    
//    for (int i=0; i<1000; i++) {
//
//           NSLog(@"%zu---%@",i,[NSThread currentThread]);
//    }
}

//一次性代码,这段代码只会执行一次，多次调用该方法也不再调用,当然，需要token一样，下面就会两次执行
-(void)onceTest:(int)type
{
    static dispatch_once_t onceToken;
    if(type==0)
    {
        dispatch_once(&onceToken, ^{
              NSLog(@"onceTest");
          });
    }
    else
    {
         static dispatch_once_t onceToken1;
        dispatch_once(&onceToken1, ^{
                     NSLog(@"onceTest1");
                 });
    }
  
}
//队列组，同一个组里必须所有线程都执行完成，才去做后续的操作。比如开发中上传多个图片，就不用用迭代方法一张一张上传了
-(void)groupTest
{
    __block  int Param1=0;
    
    __block  int param2=0;
    
    dispatch_group_t group=dispatch_group_create();
    
    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        Param1=10;
    });
    
    dispatch_group_async(group, queue, ^{
           param2=20;
        [NSThread sleepForTimeInterval:3];//dispatch_group_notify会等3秒后执行，因为这个线程3秒才完成
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"总数是:%d",Param1+param2);
    });
       
    
    
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self onceTest:1];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self groupTest];
    
    /*
    下载，线程传值相关
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
          
          NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1600769534145&di=fd0c3cde90d0fe478edbd32e10093b8a&imgtype=0&src=http%3A%2F%2Fimage.namedq.com%2Fuploads%2F20191103%2F19%2F1572779306-CbwlrmPnJD.jpg"]];
          //主要是学习下面两句代码
          if(imgData!=nil)
          {
              NSLog(@"imgData=%.2f MB",imgData.length/1024.0/1024.0);
              UIImage *img=[UIImage imageWithData:imgData];
              if(img!=nil)
              {
                  //这也是线程间传值的手段
//                [imgview performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
                  
                  //gcd里靠这个方法回到主线程并传值
                  dispatch_async(dispatch_get_main_queue(), ^{
                      imgview.image=img;
                  });
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
    });
     */
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
