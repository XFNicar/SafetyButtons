//
//  SafetyButton.m
//  SafetyButtons
//
//  Created by YanYi on 2018/3/1.
//  Copyright © 2018年 YanYi. All rights reserved.
//

#import "SafetyButton.h"

@interface SafetyButton ()

@property (nonatomic, strong) dispatch_source_t  timer;
@property (nonatomic, copy  ) NSNumber           *safatyTime;
@property (nonatomic, copy  ) NSNumber           *safatyDuration;
@property (nonatomic, copy  ) NSNumber           *effectivityTime;
@property (nonatomic, copy  ) NSNumber           *effectivityDuration;

@end

@implementation SafetyButton

/*
 以下方案为区域禁止法
 */

- (SafetyButton *)setSafetyDuration:(NSNumber *)duration
                       action:(ActionBlock )action {
    self.safatyDuration = duration;
    self.block = action;
    [self addTarget:self action:@selector(safetyAction) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)safetyAction {
    if (self.safatyTime.integerValue > 0) {
        NSLog(@"点击无效");
        return;
    } else { // 如果可以满足响应，则响应事件，然后设置条件，两秒内限制下次出发
        if (self.block) {
            self.block();
            self.safatyTime = self.safatyDuration;
            NSLog(@"点击有效");
            [self safatyTimeConfig];
        }
    }
}

- (void)safatyTimeConfig {
    
    __block int count =  [self.safatyTime intValue];
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        count--;
        self.safatyTime = @(count);
        if (count <= 0) {
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    });
    // 启动定时器
    dispatch_resume(self.timer);
}


/*
 以下方案为连击结算法
 */


- (SafetyButton *)setEffectivityDuration:(NSNumber *)duration action:(ActionBlock )action {
    
    self.effectivityDuration = duration;
    self.effectivityTime = @0;
    self.block = action;
    [self addTarget:self action:@selector(doubleClickingAction) forControlEvents:UIControlEventTouchUpInside];
    return  self;
}

- (void)doubleClickingAction {
    
    if (self.block && (self.timer == nil)) { // 尚未开始计时
        self.effectivityTime = self.effectivityDuration;
        NSLog(@"点击有效");
        [self effectivityTimeConfig];
    } else {
        self.effectivityTime = @0;
        NSLog(@"点击无效");
    }
}

- (void)effectivityTimeConfig {
    __block float count    = [self.effectivityTime floatValue];
    __block float duration = [self.effectivityDuration floatValue];
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer             = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start  = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval      = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        count = self.effectivityTime.floatValue + 1;
        NSLog(@"调用多少次");
        self.effectivityTime = @(count);
        if (count >= duration) {
            self.block();
            self.effectivityTime = @0;
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    });
    // 启动定时器
    dispatch_resume(self.timer);
}


@end
