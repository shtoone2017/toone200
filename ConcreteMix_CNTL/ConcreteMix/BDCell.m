//
//  BDCell.m
//  testTree
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 shtoone. All rights reserved.
//

#import "BDCell.h"

@interface BDCell()

@property (nonatomic) BOOL isExpanded;

@end

@implementation BDCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
