//
//  KTMViewController.m
//  ImageCachingExample
//
//  Created by Kishore Thejasvi on 24/10/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#import "KTMViewController.h"

@interface KTMViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation KTMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    return cell;
}

@end
