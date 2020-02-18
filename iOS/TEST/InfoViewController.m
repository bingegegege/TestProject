//
//  InfoViewController.m
//  iOS
//
//  Created by Raobin on 2020/2/18.
//  Copyright © 2020 RaoBin. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()
{
    int score;
    UIView *scoreV;
    UISwipeGestureRecognizer * recognizer;
}
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    score = [[self.dic objectForKey:@"uid"] intValue];
    self.view.backgroundColor =  [UIColor whiteColor];
    [self addNavigation];
    [self initUI];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer
{
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
        score = 0;
        [self backBtnClicked];
    }
    if(recognizer.direction ==UISwipeGestureRecognizerDirectionRight)
    {
        score = 5;
        [self backBtnClicked];
    }
}

-(void)addNavigation
{
  UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, kNavHeight)];
  navView.backgroundColor = [UIColor darkGrayColor];
  [self.view addSubview:navView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 8+kStatusBarHeight, WIDTH-200, 26)];
    titleLabel.text = [self.dic objectForKey:@"username"];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 19];
    [navView addSubview:titleLabel];
  
  UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, kStatusBarHeight+12, 22, 20)];
  backImageView.image = [UIImage imageNamed:@"back_white.png"];
  [navView addSubview:backImageView];
  
  UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, kNavHeight)];
  [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
  [navView addSubview:backBtn];
}

/**
 *  返回上一页
 */
-(void)backBtnClicked
{
    self.scoreBackBlock([NSString stringWithFormat:@"%d",score]);
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUI
{
    UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(20, kNavHeight+100, WIDTH-40, WIDTH-40)];
    [images setContentMode:UIViewContentModeScaleAspectFill];
    images.clipsToBounds = YES;
    [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_dic objectForKey:@"avatar"]]] placeholderImage:nil];
    [self.view addSubview:images];
    
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = @"chandler Muriel bing was born on april 8,1968.";
    noticeLab.textColor = RBColor(93, 93, 93);
    [self.view addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(images.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    scoreV = [[UIView alloc] initWithFrame:CGRectMake(50, kNavHeight, WIDTH-100, 100)];
    [self.view addSubview:scoreV];
    
    for(int i=1;i<=5;i++)
    {
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake((i-1)*(WIDTH-100)/5, 0, (WIDTH-100)/5, 100)];
        [scoreV addSubview:views];
        
        UIImageView *images = [[UIImageView alloc] init];
        images.tag = i;
        images.image = [UIImage imageNamed:@"no_zan"];
        [views addSubview:images];
        [images mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(views);
            make.width.height.mas_equalTo(36);
        }];
        
        UIButton *btns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,(WIDTH-100)/5, 100)];
        btns.tag = 5+i;
        [btns addTarget:self action:@selector(scoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [views addSubview:btns];
    }
    [self refreshScore];
}

-(void)scoreBtnClicked:(UIButton *)sender
{
    int index = (int)sender.tag;
    NSLog(@"%d",index-5);
    if(score == index-5)
    {
        score -= 1;
    }
    else
    {
        score = index-5;
    }
    [self refreshScore];
}

-(void)refreshScore
{
    for(int i=1;i<=5;i++)
    {
        UIImageView *images = (UIImageView *)[scoreV viewWithTag:i];
        images.image = [UIImage imageNamed:@"no_zan"];
    }
    for(int i=1;i<=score;i++)
    {
        UIImageView *images = (UIImageView *)[scoreV viewWithTag:i];
        images.image = [UIImage imageNamed:@"zan"];
    }
}
@end
