//
//  TimelineViewController.m
//  Fabric in C Major
//
//  Created by Stephen Wong on 1/11/16.
//  Copyright © 2016 Wingchi. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineTableViewCell.h"
#import <TwitterKit/TwitterKit.h>

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end

@implementation TimelineViewController

    NSString *timelineTableViewCellIdentifier = @"timelineCell";
    NSArray *responseJson;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timelineTableView.hidden=true;
    
    UINib *timelineCellNib = [UINib nibWithNibName: @"TimelineTableViewCell" bundle:nil];
    
    [self.timelineTableView registerNib:timelineCellNib forCellReuseIdentifier:timelineTableViewCellIdentifier];
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    
    self.timelineTableView.rowHeight = UITableViewAutomaticDimension;
    self.timelineTableView.estimatedRowHeight = 160.0;
    
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userID];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:nil error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                responseJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                [self.timelineTableView reloadData];
//                NSLog(@"JSON: %@", responseJson);
                
                
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [self showVisibleCells];
}

/*
#pragma mark - Delegate Methods
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [responseJson count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:timelineTableViewCellIdentifier forIndexPath:indexPath];
    if (responseJson == nil)
        return cell;
    else
        return [self populateCell:indexPath];
}

- (TimelineTableViewCell *)populateCell:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *tableCell = [self.timelineTableView
                                   dequeueReusableCellWithIdentifier:timelineTableViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *tweet = responseJson[indexPath.row];
    NSDictionary *user = tweet[@"user"];
    tableCell.userLabel.text = user[@"screen_name"];
    tableCell.tweetLabel.text = tweet[@"text"];
//    NSString *profileUrl = [(NSString *)[user objectForKey:@"profile_image_url"] stringByAddingPercentEncodingWithAllowedCharacters:NSASCIIStringEncoding];
    NSLog(@"%@", user[@"profile_image_url"]);
    if (user[@"profile_image_url"] != nil && tableCell.userImage.image == nil) {
//        NSData *userImageData = [[NSData alloc] initWithContentsOfURL: [user objectForKey:@"profile_image_url"]];
//        tableCell.userImage.image = [UIImage imageWithData: userImageData];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *profileImageUrlString = user[@"profile_image_url_https"];
            NSURL *profileImageUrl = [NSURL URLWithString:profileImageUrlString];
            NSData *userImageData = [[NSData alloc] initWithContentsOfURL:profileImageUrl];
            if (userImageData == nil) {
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                tableCell.userImage.backgroundColor = [UIColor orangeColor];
                UIImage *image = [UIImage imageWithData: userImageData];
                tableCell.userImage.image = image;
            });
        });
    }
    return tableCell;
}

/*
#pragma mark - Animation
*/

- (void)showVisibleCells
{
    NSArray *cells = _timelineTableView.visibleCells;
    for (TimelineTableViewCell * cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, _timelineTableView.bounds.size.height);
    }
    self.timelineTableView.hidden = false;
    for (int index = 0; index < _timelineTableView.visibleCells.count; ++index) {
        double delay = pow((NSTimeInterval)index, 1.5) * 0.05;
        UITableViewCell *cell = _timelineTableView.visibleCells[index];
        
        [UIView animateWithDuration:0.5
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
