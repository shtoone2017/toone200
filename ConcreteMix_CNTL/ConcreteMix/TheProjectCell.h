//
//  TheProjectCell.h
//  The Projects
//
//  Created by Ahmed Karim on 1/11/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Node.h"

@interface TheProjectCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *cellLabel;
@property (retain, nonatomic) IBOutlet UIButton *cellButton;
@property (retain, strong) Node *treeNode;

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;

@end
