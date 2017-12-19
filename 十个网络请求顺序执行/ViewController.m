//
//  ViewController.m
//  十个网络请求顺序执行
//
//  Created by yl on 2017/12/19.
//  Copyright © 2017年 yl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1.无处理
    UIButton *Btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn1.frame = CGRectMake(100, 100, 100, 40);
    Btn1.backgroundColor = [UIColor grayColor];
    [Btn1 setTitle:@"noConduct" forState:UIControlStateNormal];
    [Btn1 addTarget:self action:@selector(Btn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn1];

    //2.group
    UIButton *Btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn2.frame = CGRectMake(100, 200, 100, 40);
    Btn2.backgroundColor = [UIColor grayColor];
    [Btn2 setTitle:@"group--" forState:UIControlStateNormal];
    [Btn2 addTarget:self action:@selector(Btn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn2];
    
    //3.semaphore
    UIButton *Btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn3.frame = CGRectMake(100, 300, 100, 40);
    Btn3.backgroundColor = [UIColor grayColor];
    [Btn3 setTitle:@"semaphore" forState:UIControlStateNormal];
    [Btn3 addTarget:self action:@selector(Btn3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn3];

}

//1.noConduct
-(void)Btn1{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    for (int i=0; i<10; i++) {
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
            
        }];
        
        [task resume];
    }
    
    NSLog(@"end");
}

//2.group--
-(void)Btn2{
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_group_t dis = dispatch_group_create();
    
    for (int i=0; i<10; i++) {
        dispatch_group_enter(dis);
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
            dispatch_group_leave(dis);
        }];
        
        [task resume];
    }
    dispatch_group_notify(dis, dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}

//3.semaphore--
-(void)Btn3{
    __block int count = 0;
    NSString *str = @"http://www.jianshu.com/p/6930f335adba";
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    for (int i=0; i<10; i++) {
        
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"%d---%d",i,i);
             count++;
            if (count==10) {
                dispatch_semaphore_signal(sem);
                count = 0;
            }
            
        }];
        
        [task resume];
    }
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"end");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
