//
//  CFHMainTableViewCell.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHMainTableViewCell.h"

NSString * const CFHMainTableViewCellIndentifier = @"CFHMainTableViewCell";
const CGSize CFHMainTableViewCellSize = {375, 144};

@implementation CFHMainTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:CFHMainTableViewCellIndentifier bundle:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
