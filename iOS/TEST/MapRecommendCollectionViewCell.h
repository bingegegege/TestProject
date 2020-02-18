//
//  MapRecommendCollectionViewCell.h
//  DareLove
//
//  Created by Raobin on 2019/6/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapRecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLab;
@property (weak, nonatomic) IBOutlet UIButton *labelBtn;

@end

NS_ASSUME_NONNULL_END
