//
//  ClientSearch.m
//  Real Estat
//
//  Created by NLS32-MAC on 29/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import "ClientSearch.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "Static.h"
@interface ClientSearch ()

@end

@implementation ClientSearch
@synthesize dataArray;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Client Select";
    // Do any additional setup after loading the view from its nib.
    arrAllData=self.dataArray;
    searchedDataArray=[[NSMutableArray alloc]init];
    for(int i=0;i<self.dataArray.count;i++){
        NSMutableDictionary *dict=[self.dataArray objectAtIndex:i];
        [searchedDataArray addObject:[dict valueForKey:@"label"]];
    }
    self.dataArray=searchedDataArray;
    [self.mSearchBar setPositionAdjustment:UIOffsetMake(255, 0) forSearchBarIcon:UISearchBarIconSearch];
    [self.mSearchBar setSearchTextPositionAdjustment:UIOffsetMake(0, 0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchedDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID=@"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==Nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text=[searchedDataArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:FONT_REGULAR size:15.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    for(int i=0;i<arrAllData.count;i++){
        NSMutableDictionary *dict=[arrAllData objectAtIndex:i];
        if([[dict valueForKey:@"label"] isEqualToString:[searchedDataArray objectAtIndex:indexPath.row]]){
            [self.delegate selectClientForWithClientName:[dict valueForKey:@"label"] WithId:[dict valueForKey:@"value"]];
            [self.navigationController popViewControllerAnimated:true];
            break;
        }
    }
    

    

}
#pragma mark - Search Functionality

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.mSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.mSearchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat: @"SELF CONTAINS[cd] %@", searchText];
        searchedDataArray= [self.dataArray filteredArrayUsingPredicate:predicate];
        [_mTableView reloadData];
    }
    else
        {
        searchedDataArray=dataArray;
        [_mTableView reloadData];
        }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.mSearchBar resignFirstResponder];
    searchedDataArray=dataArray;
    [self.mTableView reloadData];
}

@end
