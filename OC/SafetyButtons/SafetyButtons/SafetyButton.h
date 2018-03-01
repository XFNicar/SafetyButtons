//
//  SafetyButton.h
//  SafetyButtons
//
//  Created by YanYi on 2018/3/1.
//  Copyright © 2018年 YanYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(void);

@interface SafetyButton : UIButton

@property (nonatomic, copy  ) ActionBlock  block;

/*
 区域禁止法
 
 duration 有效响应之后禁止时间长度
 action   响应事件代码
 
 */

- (SafetyButton *)setSafetyDuration:(NSNumber *)duration action:(ActionBlock )action;

/*
 区域禁止法
 
 duration 有效连击间隔时间长度
 action   响应事件代码
 
 */

- (SafetyButton *)setEffectivityDuration:(NSNumber *)duration action:(ActionBlock )action;


@end
