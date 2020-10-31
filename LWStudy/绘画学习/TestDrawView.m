//
//  TestDrawView.m
//  touchtest
//
//  Created by liwanlu on 2020/9/18.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "TestDrawView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TestDrawView


-(void)drawRect:(CGRect)rect
{
    NSLog(@"%s",__func__);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    UIBezierPath *path =[UIBezierPath bezierPath];
    

    
    if(lwprogress<50)
    {
    //画直线
    [path moveToPoint:CGPointMake(20, 20)];
    [path addLineToPoint:CGPointMake(20, 100)];
     [path addLineToPoint:CGPointMake(120, 100)];
    [path addLineToPoint:CGPointMake(20, 20)];
    
//
//
//    [path moveToPoint:CGPointMake(200, 200)];
//      [path addLineToPoint:CGPointMake(300, 300)];
//       [path addLineToPoint:CGPointMake(400, 200)];
//      [path addLineToPoint:CGPointMake(200, 200)];
    
//        [path setLineJoinStyle:kCGLineJoinBevel];//设置连接点的样式
        [path closePath];
    
     CGContextSetLineWidth(context, 10);
    
    [[UIColor redColor] setStroke];;
    
    CGContextAddPath(context, path.CGPath);
   
    
    CGContextStrokePath(context);
    
    
    
    //画曲线
    UIBezierPath *quxianPath=[UIBezierPath bezierPath];
       [quxianPath moveToPoint:CGPointMake(20, 150)];
       [quxianPath addQuadCurveToPoint:CGPointMake(220, 150) controlPoint:CGPointMake(120, 100)];
    
     [quxianPath addQuadCurveToPoint:CGPointMake(20, 180) controlPoint:CGPointMake(150, 180)];
    [quxianPath closePath];
    [quxianPath stroke];
    
    
    
    
    //画矩形
    UIBezierPath *rectPath=[UIBezierPath bezierPathWithRect:CGRectMake(20, 220, 100, 100)];
       CGContextAddPath(context, rectPath.CGPath);
    [[UIColor blueColor] set];
    CGContextFillPath(context);
    
    
    //画圆角矩形
    UIBezierPath *rectPath2=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(130, 220, 50, 50) cornerRadius:5];
//       CGContextAddPath(context, rectPath.CGPath);
//    [[UIColor yellowColor] setStroke];
//    CGContextFillPath(context);
    [rectPath2 fill];
    
    //画椭圆（宽高一样就是正圆）
    
    
    UIBezierPath *oviPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 340, 100, 90)];
//    CGContextSetLineWidth(context, 5);
    [oviPath setLineWidth:5];
    [oviPath stroke];
    
    //画弧度，参数为中间点，半径长。开始角度（弧度对应的圆最右边角度为0），结束角度。是否顺时针画。
    //450
    UIBezierPath *arcPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 500) radius:50 startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    [arcPath stroke];
    
    //画扇形（弧度两边到中点的直线就成了扇形），其实只加一条直线，用fill填充，也能自动闭合成扇形
    
    UIBezierPath *arcPath2=[UIBezierPath bezierPathWithArcCenter:CGPointMake(70, 500) radius:50 startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [oviPath setLineWidth:5];
    [arcPath2 addLineToPoint:CGPointMake(70, 500)];
//    [arcPath2 closePath];//关闭也能自动闭合
       [arcPath2 fill];//fill也能自动闭合
    
    
    //画文字
    
    NSString *str=@"卢大哥卢大哥卢大哥卢大哥卢大哥";
    NSMutableDictionary *dicAttr=[[NSMutableDictionary alloc] init];
    [dicAttr setValue:[UIFont systemFontOfSize:30] forKey:NSFontAttributeName];
    
    [str drawAtPoint:CGPointMake(200, 200) withAttributes:dicAttr];//drawPoint直接原大小绘制，不换行
    
     str=@"小卢哥小卢哥小卢哥小卢哥小卢哥小卢哥";
    [str drawInRect:CGRectMake(150, 300, 200, 400) withAttributes:dicAttr];//drawInRect自适应绘制，换行
    
    //图片绘制也类似，drawPoint原大小绘制，drawInRect会自适应到rect里面。
      }
    //重绘
//    if(progress>=100)
//    {
//        progress-=10;
//    }
//    else
//    {
          lwprogress+=1;
//    }
  
//    if(progress>100)
//    {
//        progress=1;
//    }
    float endAngle=lwprogress/100.0*(M_PI*2);//进度✖️360度得出需要绘制的角度
    
        UIBezierPath *autoPath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(170, 500) radius:50 startAngle:0 endAngle:endAngle clockwise:YES];
        [autoPath addLineToPoint:CGPointMake(170, 500)];
           [autoPath fill];//fill也能自动闭合
  
    
    
    float startAngle=lwprogress/100.0*(M_PI*2);//进度✖️360度得出需要绘制的角度
      
          UIBezierPath *autoPath2=[UIBezierPath bezierPathWithArcCenter:CGPointMake(300, 500) radius:50 startAngle:startAngle endAngle:(startAngle+M_PI_4) clockwise:YES];
          [autoPath2 addLineToPoint:CGPointMake(300, 500)];
             [autoPath2 fill];//fill也能自动闭合
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"开始触摸touches.count=%d,touchs=%@",touches.count,touches);
  
    
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%s",__func__);
      NSLog(@"移动");

    [self setNeedsDisplay];//这句话会让view 重新绘制，清除之前的东西并且回调drawRect方法；
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     NSLog(@"结束");
}

@end
