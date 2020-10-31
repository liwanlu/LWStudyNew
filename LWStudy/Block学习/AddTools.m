//
//  AddTools.m
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import "AddTools.h"

@implementation AddTools
-(AddTools * _Nonnull (^)(int))add
{
    return ^AddTools *(int num){
        _result+=num;
        return self;
    };
}
@end
