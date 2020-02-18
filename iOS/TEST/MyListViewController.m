//
//  MyListViewController.m
//  iOS
//
//  Created by Raobin on 2020/2/18.
//  Copyright © 2020 RaoBin. All rights reserved.
//

#import "MyListViewController.h"
#import "NetworkManager.h"
#import "MJRefresh.h"
#import "MapRecommendCollectionViewCell.h"
#import "NetworkingManager.h"
#import "InfoViewController.h"
#import "henView.h"
//达人列表
#define API_GET_STARLIST                  @"userV2/recommendList"
@interface MyListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    int orientation;
    UICollectionView *myCollectionView;                                     //我的列表
    NSMutableArray *listarray;                                    //记录正常列表数据
    int page;
    UIView *shuView;
    BOOL first;
}
@property (nonatomic, strong) henView *henViews;
@end

@implementation MyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    orientation = 1;
    [self loadListInfo];
    self.view.backgroundColor = [UIColor whiteColor];
    shuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:shuView];
    
    _henViews = [[henView alloc] init];
    [self.view addSubview:self.henViews];
    [self initUI];
    // 监听手机屏幕方向旋转
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
//    [self userLogin];
}

//-(void)userLogin
//{
//  NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//  parameter[@"phone"] = @"18170249797";
//  parameter[@"region"] = @"0086";
//  parameter[@"veriCode"] = @"000000";
//  [[NetworkManager shareNetworkManager] GETUrl:API_CODE_LOGIN parameters:parameter success:^(id responseObject) {
//    if([[responseObject objectForKey:@"code"] integerValue] == 0)
//    {
//        SAVEDEFAULTS([[responseObject objectForKey:@"data"] objectForKey:@"token"], @"TOKEN")
//    }
//
//  } failure:^(NSError *error, ParamtersJudgeCode judgeCode) {
//  }];
//}

// 手机屏幕方向旋转
- (void)deviceOrientationDidChange
{
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
    {
        if(orientation == 1) return;
        NSLog(@"1-正常");
        orientation = 1;
        [self initUI];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
    {
        if(orientation == 2) return;
        NSLog(@"2-左");
        orientation = 2;
        [self initUI];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
    {
        if(orientation == 3) return;
        NSLog(@"3-右");
        orientation = 3;
        [self initUI];
    }
}

-(void)loadListInfo
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page"] = @(page);
    parameter[@"num"] = @"20";
    parameter[@"type"] = @"2";
    [[NetworkingManager shareNetworkingManager] GETUrl:API_GET_STARLIST parameters:parameter success:^(id responseObject) {
      [self.view hideToastActivity];
      if([[responseObject objectForKey:@"code"] integerValue] == 0)
      {
        listarray = [NSMutableArray array];
        NSArray *arrays = GETDEFAULTS(@"LIST")
        if(arrays.count>0)
        {
            listarray = [NSMutableArray arrayWithArray:arrays];
        }
        else
        {
          listarray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"res"]];
              for(int i=0;i<listarray.count;i++)
              {
                  NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:listarray[i]];
                  [dic setObject:@"0" forKey:@"uid"];
                  [listarray replaceObjectAtIndex:i withObject:dic];
              }
          SAVEDEFAULTS(listarray, @"LIST")
        }
        [myCollectionView reloadData];
      _henViews.listarray = listarray;
      }
      else
      {
        [self.view makeToast:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] duration:2 position:CENTER];
      }
    } failure:^(NSError *error, ParamtersJudgeCode judgeCode) {
      [self.view hideToastActivity];
        [self.view makeToast:@"网络未连接" duration:2 position:CENTER];
        NSArray *arrays = GETDEFAULTS(@"LIST")
        listarray = [NSMutableArray array];
        listarray = [NSMutableArray arrayWithArray:arrays];
        _henViews.listarray = listarray;
        [myCollectionView reloadData];
    }];
}

-(void)initUI
{
    if(orientation != 2 && orientation != 3)
    {
        self.henViews.hidden = YES;
        shuView.hidden = NO;
        
        if(!first)
        {
            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.text = @"Friendsr";
            titleLab.textColor = RBColor(93, 93, 93);
            titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
            [shuView addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(self.view).offset(50);
            }];
            
            UILabel *noticeLab = [[UILabel alloc] init];
            noticeLab.text = @"Click on an eligible single user to learn more and see if you are compatible for a date!";
            noticeLab.numberOfLines = 0;
            noticeLab.textColor = RBColor(93, 93, 93);
            [shuView addSubview:noticeLab];
            [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLab.mas_bottom).offset(20);
                make.left.equalTo(self.view).offset(15);
                make.right.equalTo(self.view.mas_right).offset(-15);
            }];
            
            //创建一个layout布局类
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            //设置布局方向为垂直流布局
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            //设置每个item的大小为100*100
            layout.itemSize = CGSizeMake((WIDTH-140)/2, 150);
            //创建collectionView 通过一个布局策略layout来创建
            
            myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(50, 170, WIDTH-100, HEIGHT-170) collectionViewLayout:layout];
            myCollectionView.delegate = self;
            myCollectionView.dataSource = self;
            myCollectionView.scrollEnabled = YES;
            myCollectionView.backgroundColor = [UIColor clearColor];
            myCollectionView.showsVerticalScrollIndicator = NO;
            myCollectionView.showsHorizontalScrollIndicator = NO;
            //注册Cell
            [myCollectionView registerNib:[UINib nibWithNibName:@"MapRecommendCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"MapRecommendCollectionViewCell"];
            [shuView addSubview:myCollectionView];
            [self setupDownRefreshCarData];
            first = YES;
        }
        
    }
    else
    {
        _henViews.hidden = NO;
        shuView.hidden = YES;
        if(orientation == 2)
        {
            _henViews.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else
        {
            _henViews.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    }
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
}

/**
 *  上拉加载
 */
- (void)footerClick
{
  NSLog(@"上拉加载");
  page++;
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"page"] = @(page);
    parameter[@"num"] = @"20";
    parameter[@"type"] = @"2";
    [[NetworkingManager shareNetworkingManager] GETUrl:API_GET_STARLIST parameters:parameter success:^(id responseObject) {
      [self.view hideToastActivity];
      if([[responseObject objectForKey:@"code"] integerValue] == 0)
      {
          NSMutableArray *resArray = [NSMutableArray array];
          resArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"res"]];
//         = [[responseObject objectForKey:@"data"] objectForKey:@"res"];
        if(resArray.count == 0)
        {
          myCollectionView.mj_footer.hidden = YES;
        }
          for(int i=0;i<resArray.count;i++)
          {
              NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:resArray[i]];
              [dic setObject:@"0" forKey:@"uid"];
              [resArray replaceObjectAtIndex:i withObject:dic];
          }
        [listarray addObjectsFromArray:resArray];
        [myCollectionView reloadData];
        REMOVEDEFAULTS(@"LIST")
          SAVEDEFAULTS(resArray, @"LIST")
          _henViews.listarray = listarray;
      }
      else
      {
        [self.view makeToast:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]] duration:2 position:CENTER];
      }
    } failure:^(NSError *error, ParamtersJudgeCode judgeCode) {
      [self.view hideToastActivity];
        [self.view makeToast:@"网络未连接" duration:2 position:CENTER];
        NSArray *arrays = GETDEFAULTS(@"LIST")
        listarray = [NSMutableArray array];
        listarray = [NSMutableArray arrayWithArray:arrays];
        [myCollectionView reloadData];
        _henViews.listarray = listarray;
    }];
  
  // 结束刷新
  [myCollectionView.mj_footer endRefreshing];
}

/**
 *  下拉刷新
 */
- (void)headerClick
{
  NSLog(@"下拉刷新");
    page = 1;
  [self loadListInfo];
  // 结束刷新
  [myCollectionView.mj_header endRefreshing];
  myCollectionView.mj_footer.hidden = NO;
  
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return listarray.count;
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  MapRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MapRecommendCollectionViewCell" forIndexPath:indexPath];
  [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[listarray[indexPath.row] objectForKey:@"avatar"]]] placeholderImage:nil];
    [cell.labelBtn setTitle:[listarray[indexPath.row] objectForKey:@"username"] forState:UIControlStateNormal];
  
  return cell;
}

#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return  CGSizeMake((WIDTH-120)/2, 150);
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
    if(orientation == 1)
    {
        InfoViewController *nextVC = [[InfoViewController alloc] init];
        nextVC.dic = listarray[indexPath.row];
        __weak MyListViewController *weakSelf = self;
        nextVC.scoreBackBlock = ^(NSString *score) {
            NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithDictionary:listarray[indexPath.row]];
            [dic setObject:score forKey:@"uid"];
            [listarray replaceObjectAtIndex:indexPath.row withObject:dic];
            weakSelf.henViews.listarray = listarray;
            SAVEDEFAULTS(listarray, @"LIST")
            [weakSelf.henViews reloadDatas];
        };
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

@end
