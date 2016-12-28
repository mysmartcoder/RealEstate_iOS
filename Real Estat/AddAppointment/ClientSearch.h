//
//  ClientSearch.h
//  Real Estat
//
//  Created by NLS32-MAC on 29/04/16.
//  Copyright © 2016 . All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CLIENTSELECT
-(void)selectClientForWithClientName:(NSString *)name WithId:(NSString *)idClient;
@end
@interface ClientSearch : UIViewController
{
    NSMutableArray *searchedDataArray;
    NSArray *arrAllData;
}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)id<CLIENTSELECT> delegate;
@end
