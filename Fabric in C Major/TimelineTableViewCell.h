//
//  TimelineTableViewCell.h
//  Fabric in C Major
//
//  Created by Stephen Wong on 1/11/16.
//  Copyright © 2016 Wingchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
