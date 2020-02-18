//
//  InfoViewController.h
//  iOS
//
//  Created by Raobin on 2020/2/18.
//  Copyright © 2020 RaoBin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^callBackBlock) (NSString *score);
@interface InfoViewController : UIViewController
@property (nonatomic,strong) NSDictionary *dic;
@property (nonatomic,copy) callBackBlock scoreBackBlock;
@end

NS_ASSUME_NONNULL_END
