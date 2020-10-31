//
//  ViewController.m
//  touchtest
//
//  Created by liwanlu on 2020/9/17.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "DrawStudyVC.h"
#import "TestMoveView.h"



@interface DrawStudyVC ()

@end

@implementation DrawStudyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"aaa");
    
//    TestMoveView *moveView=[[TestMoveView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
//    moveView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:moveView];
    
    extern int lwprogress;
    lwprogress=1;
    
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];

    [self.view addGestureRecognizer:pinchGesture];
    
    pinchGesture.delegate=self;
    
    
    UIRotationGestureRecognizer *roatGesture=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRoat:)];
    
     [self.view addGestureRecognizer:roatGesture];
    
    
    
    //画一个带边框的图片
    
    UIImage *img=[UIImage imageNamed:@"oshima"];
    
    
    
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(img.size.width-20, img.size.height-20), NO, 0);
    
    //画一个边框椭圆
    UIBezierPath *boderPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, img.size.width-20, img.size.height-20)];
    [[UIColor redColor] setFill];
    boderPath.lineWidth=10;
    [boderPath addClip];//最主要是这里，把path设置为裁剪，区域外的都裁剪掉了
    [boderPath fill];
    
    
    
    [img drawInRect:CGRectMake(-10, -10, img.size.width, img.size.width)];
    
    UIImage *newImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageview.image=newImg;
    
   
    
    //截屏
    
    
    
      
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_imageview.frame.size.width,_imageview.frame.size.height), YES, 0);
      
      //画一个边框椭圆
      
    [_imageview.layer renderInContext:UIGraphicsGetCurrentContext()];//把一个layer渲染到画布。屏幕截屏直接用self。view。layer就行
      
    CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(30, 30, 50, 50));//擦除该区域
    
      UIImage *newImg2=UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      self.imageview2.image=newImg2;
      
    NSData *imgData=UIImageJPEGRepresentation(newImg2, 1);
    
    [imgData writeToFile:@"/Users/liwanlu/Downloads/test.jpg" atomically:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize
{
    return YES;;
}

-(void)onPinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"捏合%f",gesture.scale);
    
    self.view.transform=CGAffineTransformScale(self.view.transform, gesture.scale, gesture.scale);
    gesture.scale=1;
}

-(void)onRoat:(UIRotationGestureRecognizer *)gesture
{
    NSLog(@"旋转：%f",gesture.rotation);
    
    self.view.transform=CGAffineTransformRotate(self.view.transform, gesture.rotation);
    gesture.rotation=0;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"ViewController:%@",NSStringFromCGPoint(point));
////    return  [super hitTest:point withEvent:event];
//}

@end
