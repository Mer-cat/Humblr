//
//  PhotosViewController.m
//  Humblr
//
//  Created by Mercy Bickell on 6/25/20.
//  Copyright © 2020 mercycat. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
}

- (void) fetchPosts {
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

                // Unpack the posts from the API response and store them in the posts property
                NSDictionary *responseDictionary = dataDictionary[@"response"];
                self.posts = responseDictionary[@"posts"];
                
                // Reload the table view
                [self.tableView reloadData];
            }
        }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    NSDictionary *post = self.posts[indexPath.row];
    NSArray *photos = post[@"photos"];
    
    // Post may not contain any photos.
    if (photos) {
        
        // Extract first photo
        NSDictionary *photo = photos[0];
        NSDictionary *originalSize = photo[@"original_size"];
        NSString *urlString = originalSize[@"url"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        // Assign photo to cell
        [cell.photoView setImageWithURL:url];
    }
    
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
