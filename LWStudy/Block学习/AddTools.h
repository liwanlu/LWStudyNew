//
//  AddTools.h
//  LWStudy
//
//  Created by liwanlu on 2020/10/30.
//  Copyright © 2020 liwanlu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddTools : NSObject
@property(nonatomic,assign) int32_t result;
-(AddTools *(^)(int))add;
@end

NS_ASSUME_NONNULL_END
