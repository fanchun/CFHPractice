//
//  CFHMainTableViewCell.h
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const CFHMainTableViewCellIndentifier = @"CFHMainTableViewCell";
static CGSize const CFHMainTableViewCellSize = {375, 144};

NS_ASSUME_NONNULL_BEGIN

@interface CFHMainTableViewCell : UITableViewCell

+ (UINib *)nib;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *featureLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;

@end

NS_ASSUME_NONNULL_END
