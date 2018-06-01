
@interface KS_feed

@property(retain, nonatomic) NSString *main_mv_url;
@property(retain, nonatomic) NSString *main_url;
@end


%hook KSOtherProfileViewController

- (void)didTapCellWithCell:(id)arg1 feed:(id)arg2 {
    KS_feed *mf = (KS_feed *)arg2;

    NSString *murl = mf.main_mv_url;
    if(murl){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = murl;  
    }

   %orig;
}
%end

%hook KSHomeCollectionViewController

- (void)didSelectCell:(id)arg1 withCollectionObject:(id)arg2 {

    KS_feed *mf = (KS_feed *)arg2;

    NSString *murl = mf.main_mv_url;
    if(murl){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = murl;  
    }
               
    %orig;

}


%end
