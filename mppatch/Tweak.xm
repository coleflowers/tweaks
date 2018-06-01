

%hook MPFHomeChannelTableViewCellStyleA

- (void)playVideoAction:(id)arg1 {
  %orig;

}

%end

@interface MPFHomeChannelViewController
@property(retain, nonatomic) NSMutableArray *tableViewData;
@end

@interface MPFHomeBaseUIModel : NSObject
@property(retain, nonatomic) id dataModel;
@end

@interface MPFHomeChannelBaseUIModel : MPFHomeBaseUIModel
@end

@interface MPFHomeChannelBUIModel : MPFHomeChannelBaseUIModel
@end

@interface MPFHomeChannelAUIModel : MPFHomeChannelBaseUIModel
@end


@interface MTLModel : NSObject
@end

@interface MPTModel : MTLModel
@end

@interface MPTHotFeedModel : MPTModel
@property(retain, nonatomic) NSURL *img; 
@property(retain, nonatomic) NSURL *cover_b;
@property(retain, nonatomic) MPTModel *extendModel;
@end

%hook MPFHomeChannelViewController

- (void)mpdHomeTableViewCell:(id)arg1 playAtIndexPath:(id)arg2 {
%orig;
    NSLog(@"=== 009 === ");
    NSLog(@"== %@", self.tableViewData);

    NSIndexPath *mi = (NSIndexPath*)arg2;
    NSLog(@"=== %@   %@", mi, mi.description);


     NSInteger m_index = mi.row;

     MPFHomeChannelAUIModel *mdata =  (MPFHomeChannelAUIModel *)[self.tableViewData objectAtIndex:m_index];

    NSLog(@"=== data : %@   d:%@", mdata, mdata.description);
    NSLog(@"=== datac : %@", mdata.dataModel);

    MPTHotFeedModel *cdata = (MPTHotFeedModel*)mdata.dataModel;
    if(cdata){
      
        NSLog(@"=== %@", cdata.extendModel);
    }   



}


%end


%hook MPTPlayer

- (void)autoPlayWithIdentity:(id)arg1 andURL:(id)arg2 andDuration:(double)arg3 {

    if(arg2){

    NSLog(@"=== url : %@", arg2 );
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = (NSString *)arg2;
}
   %orig;


}
%end


%hook MPTPlayerB

- (void)autoPlayWithIdentity:(id)arg1 andURL:(id)arg2 andDuration:(double)arg3 {

    NSLog(@"=== 007 ===");
    NSLog(@"=== url : %@", [arg2 absoluteString]);

   %orig;


}
%end
