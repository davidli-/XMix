//
//  GCDViewController.m
//  XMix
//
//  Created by davidli on 15/9/6.
//  Copyright (c) 2015年 X. All rights reserved.
//

#import "GCDViewController.h"
#import "BackButton.h"

@interface GCDViewController ()

@property (nonatomic) dispatch_queue_t seriaQueue; //自定义 串行队列
@property (nonatomic) dispatch_queue_t concuQueue; //自定义 并行队列

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self dispatchSerialQueue];
//    [self dispatchGroup];
//    [self dispatchAfter];
//    [self deadLock];
//    [self dispatchBarrier];
//    [self dispatchSemaphore];
    [self timerTest];
}


- (void)timerTest{
    dispatch_async(self.seriaQueue, ^{
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        
        //_timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onHandleTimer) userInfo:nil repeats:YES];
        //_timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(onHandleTimer) userInfo:nil repeats:YES];
        //[runloop addTimer:_timer forMode:NSRunLoopCommonModes];
        [self performSelector:@selector(onHandleTimer) withObject:nil afterDelay:5];
        [runloop run];
    });
    
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(onHandleTimer2) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
}

- (void)onHandleTimer{
    TraceS(@"+++++++处理计时器");
    
    [_timer invalidate];
}


- (void)onHandleTimer2{
//    [_timer fire];
}

-(dispatch_queue_t)seriaQueue{
    if (!_seriaQueue) {
        _seriaQueue = dispatch_queue_create("seriaQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _seriaQueue;
}



-(dispatch_queue_t)concuQueue{
    if (!_concuQueue) {
        _concuQueue = dispatch_queue_create("concurentQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concuQueue;
}


- (void)dispatchSerialQueue{
    dispatch_sync(self.seriaQueue, ^{
        NSString *string = [NSString stringWithFormat:@"自定义串行异步线程:%ld",(long)(arc4random() % 10 + ONE)];
        TraceS(@"%@",string);
    });
}


- (void)dispatchConcurrentQueue{
    dispatch_async(self.concuQueue, ^{
        NSString *string = [NSString stringWithFormat:@"自定义并行异步线程:%ld",(long)arc4random() % 10 +1];
        TraceS(@"%@",string);
    });
}


- (void)dispatchAfter{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        TraceS(@"+++++++显然不会阻塞 延迟加载 完成");
        [self.navigationItem setPrompt:@"这是提示文字"];
    });
    
    TraceS(@"++++会阻塞?");
    
    dispatch_time_t time2 = dispatch_time(DISPATCH_TIME_NOW, 4*NSEC_PER_SEC);
    
    dispatch_after(time2, dispatch_get_main_queue(), ^{
        [self.navigationItem setPrompt:nil];
    });
}


- (void)dispatchGroup{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NONE);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = NONE; i < 10; i++) {
            TraceS(@"++++++ %ld",(long)i);
        }
    });
    
    //dispatch_group_wait(group, DISPATCH_TIME_FOREVER);  也可以替换下面的方法  区别是 wait会阻塞当前线程  notify不会
    dispatch_group_notify(group, queue, ^{
        TraceS(@"++++++ done");
    });
    
    TraceS(@"++++++++ 分割线 ++++++++");
}


-(void)dispatchBarrier{
    
    [self dispatchConcurrentQueue];
    [self dispatchConcurrentQueue];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(concurrentQueue, ^{
        TraceS(@"阻塞线程1");
    });
    dispatch_barrier_async(concurrentQueue, ^{
        TraceS(@"阻塞线程2");
    });
    dispatch_suspend(concurrentQueue);
    
    [self dispatchConcurrentQueue];
    [self dispatchConcurrentQueue];
    
    [NSThread sleepForTimeInterval:2];
    
    dispatch_resume(concurrentQueue);
    
    dispatch_barrier_async(concurrentQueue, ^{
        TraceS(@"阻塞线程3");
    });
}


- (void)deadLock{
    //死锁的原因：向一个串行队列中 同步的向这个队列添加一个block
    
    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    //向一个串行队列 异步的添加一个队列 不会导致死锁
    dispatch_sync(queue, ^{
        
        dispatch_async(queue, ^{
            TraceS(@"死锁？");
        });
        
        TraceS(@"++++++死锁1 ?");
    });
    
    //下面这儿 就是死锁
    dispatch_sync(queue, ^{
        
        dispatch_sync(queue, ^{
            TraceS(@"死锁？");
        });
        
        TraceS(@"++++++死锁1 ?");
    });

    //这个也是死锁
    dispatch_sync(dispatch_get_main_queue(), ^{
        TraceS(@"++++++死锁2 ?");
    });
}



- (void)dispatchSemaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("x", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = NONE; i < 10000; i++) {
        
        dispatch_group_async(group, queue, ^{
            TraceS(@"++++++++%ld",(long)i);
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    dispatch_group_notify(group, queue, ^{
        TraceS(@"++++++循环结束");
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dispatchSyncToAsync{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        TraceS(@"1");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            TraceS(@"2");
        });
        
        TraceS(@"3");
    });
}

-(void)setUps{
    [self setTitle:@"多线程-GCD"];
    UIButton *back = [[BackButton alloc] initWithBackType:BACK_BTN_TYPE_IMAGE images:nil text:@"" target:self selector:@selector(onHandleBack:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
}


- (void)onHandleBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    
}


@end
