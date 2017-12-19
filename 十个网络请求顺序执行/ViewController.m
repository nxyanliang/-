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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
