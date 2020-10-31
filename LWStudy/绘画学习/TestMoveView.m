//
//  TestMoveView.m
//  touchtest
//
//  Created by liwanlu on 2020/9/17.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "TestMoveView.h"

@implementation TestMoveView

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"TestMoveView:%@",NSStringFromCGPoint(point));
//    return  [super hitTest:point withEvent:event];
//}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"1开始触摸%@",touches);
//}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"%s",__func__);
//      NSLog(@"1移动");


    UITouch *mtouch=[touches anyObject];

    CGPoint nowP=[mtouch locationInView:self.superview];
    CGPoint preP=[mtouch previousLocationInView:self.superview];

    float moveX=nowP.x-preP.x;
    float moveY=nowP.y-preP.y;

    self.transform=CGAffineTransformTranslate(self.transform, -moveX, -moveY);

//    self.transform=CGAffineTransformMakeTranslation(moveX, moveY);
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     NSLog(@"1结束");
}
@end
