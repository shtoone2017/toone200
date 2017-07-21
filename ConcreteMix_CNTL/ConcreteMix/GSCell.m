//
//  GSCell.m
//  testTree
//
//  Created by user on 15/10/21.
//  Copyright © 2015年 shtoone. All rights reserved.
//

#import "GSCell.h"

@interface GSCell()

@property (nonatomic) BOOL isExpanded;

@end

@implementation GSCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
