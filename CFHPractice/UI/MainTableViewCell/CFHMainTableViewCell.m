//
//  CFHMainTableViewCell.m
//  CFHPractice
//
//  Created by Arthur Tseng on 2018/12/15.
//  Copyright © 2018 Arthur Tseng. All rights reserved.
//

#import "CFHMainTableViewCell.h"

@implementation CFHMainTableViewCell

+ (UINib *)nib {
    return [UINib nibWithNibName:@"CFHMainTableViewCell" bundle:nil];
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
