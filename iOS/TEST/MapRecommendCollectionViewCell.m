//
//  MapRecommendCollectionViewCell.m
//  DareLove
//
//  Created by Raobin on 2019/6/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "MapRecommendCollectionViewCell.h"

@implementation MapRecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
  [self initUI];
}

-(void)initUI
{
//  self.layer.cornerRadius = 10.0f;
//  self.layer.masksToBounds = YES;
  [self.bgImageView setContentMode:UIViewContentModeScaleAspectFill];
  self.bgImageView.clipsToBounds = YES;
//  self.labelBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 10);
//  self.labelBtn.layer.cornerRadius = 10.0f;
//  self.labelBtn.layer.masksToBounds = YES;
}

@end
