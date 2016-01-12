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
    NSDictionary *responseJson;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                NSLog(@"JSON: %@", responseJson);
                
                
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
    _timelineTableView.hidden = false;
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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:timelineTableViewCellIdentifier forIndexPath:indexPath];
    
    cell.userLabel.text = @"username";
    cell.tweetLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ante libero, porttitor in ipsum eget, efficitur egestas enim. Maecenas sed.";
    
    return cell;
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
