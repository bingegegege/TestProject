//
//  henView.m
//  iOS
//
//  Created by Raobin on 2020/2/18.
//  Copyright © 2020 RaoBin. All rights reserved.
//

#import "henView.h"
#import "MJRefresh.h"
#import "MapRecommendCollectionViewCell.h"

@interface henView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *myCollectionView;                                     //我的列表
    UIView *rightV;
    int selectIndex;
    UIView *scoreV;
    int score;
}
@end

@implementation henView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(-(HEIGHT-WIDTH)/2, (HEIGHT-WIDTH)/2, HEIGHT, WIDTH);
        self.backgroundColor = [UIColor whiteColor];
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self loadSubViews];
    }
    return self;
}

-(void)loadSubViews
{
    selectIndex = 0;
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT/2, WIDTH)];
    [self addSubview:leftV];
    
    rightV = [[UIView alloc] initWithFrame:CGRectMake(HEIGHT/2, 0, HEIGHT/2, WIDTH)];
    [self addSubview:rightV];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"Friendsr";
    titleLab.textColor = RBColor(93, 93, 93);
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    [leftV addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftV);
        make.top.equalTo(leftV).offset(20);
    }];
    
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = @"Click on an eligible single user to learn more and see if you are compatible for a date!";
    noticeLab.numberOfLines = 0;
    noticeLab.textColor = RBColor(93, 93, 93);
    [leftV addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(20);
        make.left.equalTo(leftV).offset(15);
        make.right.equalTo(leftV.mas_right).offset(-15);
    }];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(100, 130);
    //创建collectionView 通过一个布局策略layout来创建
    
    myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(50, 140, HEIGHT/2-100, WIDTH-140) collectionViewLayout:layout];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    myCollectionView.scrollEnabled = YES;
    myCollectionView.backgroundColor = [UIColor clearColor];
    myCollectionView.showsVerticalScrollIndicator = NO;
    myCollectionView.showsHorizontalScrollIndicator = NO;
    //注册Cell
    [myCollectionView registerNib:[UINib nibWithNibName:@"MapRecommendCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"MapRecommendCollectionViewCell"];
    [leftV addSubview:myCollectionView];
    [self setupDownRefreshCarData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadDatas];
    });
}

/**
 *  添加下拉刷新和上拉加载功能
 */
- (void)setupDownRefreshCarData
{
  // 添加头部的下拉刷新
  MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
  [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
  header.lastUpdatedTimeLabel.hidden =YES;
  // 设置文字
  [header setTitle:@"努力刷新中..."forState:MJRefreshStateIdle];
  [header setTitle:@"努力刷新中..."forState:MJRefreshStatePulling];
  [header setTitle:@"努力刷新中..."forState:MJRefreshStateRefreshing];
  // 设置字体
  header.stateLabel.font = [UIFont systemFontOfSize:15];
  header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
  // 设置颜色
  header.stateLabel.textColor = [UIColor grayColor];
  header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
  myCollectionView.mj_header = header;
  
  // 添加底部的上拉加载
  MJRefreshBackNormalFooter *footer = [[MJRefreshBackNormalFooter alloc] init];
  [footer setRefreshingTarget:self refreshingAction:@selector(footerClick)];
  // 设置文字
  [footer setTitle:@"努力刷新中..."forState:MJRefreshStateIdle];
  [footer setTitle:@"努力刷新中..."forState:MJRefreshStatePulling];
  [footer setTitle:@"努力刷新中..."forState:MJRefreshStateRefreshing];
  // 设置字体
  footer.stateLabel.font = [UIFont systemFontOfSize:15];
  // 设置颜色
  footer.stateLabel.textColor = [UIColor grayColor];
  myCollectionView.mj_footer = footer;
    [self headerClick];
}

/**
 *  上拉加载
 */
- (void)footerClick
{
  NSLog(@"上拉加载");
  // 结束刷新
  [myCollectionView.mj_footer endRefreshing];
}

/**
 *  下拉刷新
 */
- (void)headerClick
{
  NSLog(@"下拉刷新");
  // 结束刷新
  [myCollectionView.mj_header endRefreshing];
  myCollectionView.mj_footer.hidden = NO;
    [myCollectionView reloadData];
    [self refreshRightView];
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.listarray.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  MapRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapRecommendCollectionViewCell" forIndexPath:indexPath];
  [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.listarray[indexPath.row] objectForKey:@"avatar"]]] placeholderImage:nil];
    [cell.labelBtn setTitle:[self.listarray[indexPath.row] objectForKey:@"username"] forState:UIControlStateNormal];
  
  return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return  CGSizeMake(100, 130);
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}

#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return 11;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
  return 11;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectIndex = (int)indexPath.row;
    [self refreshRightView];
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

-(void)refreshRightView
{
    [rightV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(40, 100, HEIGHT/2-80, HEIGHT/2-80)];
    [images setContentMode:UIViewContentModeScaleAspectFill];
    images.clipsToBounds = YES;
    [images sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.listarray[selectIndex] objectForKey:@"avatar"]]] placeholderImage:nil];
    [rightV addSubview:images];
    
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = @"chandler Muriel bing was born on april 8,1968.";
    noticeLab.textColor = RBColor(93, 93, 93);
    [rightV addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(images.mas_bottom).offset(20);
        make.left.equalTo(rightV).offset(15);
        make.right.equalTo(rightV.mas_right).offset(-15);
    }];
    
    scoreV = [[UIView alloc] initWithFrame:CGRectMake(50, 0, HEIGHT/2-100, 100)];
    [rightV addSubview:scoreV];
    
    for(int i=1;i<=5;i++)
    {
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake((i-1)*(HEIGHT/2-100)/5, 0, (HEIGHT/2-100)/5, 100)];
        [scoreV addSubview:views];
        
        UIImageView *images = [[UIImageView alloc] init];
        images.tag = i;
        images.image = [UIImage imageNamed:@"no_zan"];
        [views addSubview:images];
        [images mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(views);
            make.width.height.mas_equalTo(36);
        }];
        
        UIButton *btns = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,(HEIGHT/2-100)/5, 100)];
        btns.tag = 5+i;
        [btns addTarget:self action:@selector(scoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [views addSubview:btns];
    }
    
    score = [[self.listarray[selectIndex] objectForKey:@"uid"] intValue];
    [self refreshScore:score];
}

-(void)scoreBtnClicked:(UIButton *)sender
{
//    int score = [[self.listarray[selectIndex] objectForKey:@"uid"] intValue];
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
    [self refreshScore:score];
}

-(void)refreshScore:(int)score
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
    NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:self.listarray[selectIndex]];
    [dic setObject:[NSString stringWithFormat:@"%d",score] forKey:@"uid"];
    [self.listarray replaceObjectAtIndex:selectIndex withObject:dic];
}

-(void)reloadDatas
{
    [myCollectionView reloadData];
    [self refreshRightView];
}

@end
