@interface WBPageInfoMediaContentView : UIView
@end

@interface WBModelObject : NSObject
@end

@interface WBVideoURLItem : WBModelObject
@property(copy, nonatomic) NSURL *itemURL;
@end

@interface WBVideoItem : WBModelObject
@property(copy, nonatomic) WBVideoURLItem *urlItem;
@end

@interface WBVideoModel : WBVideoItem
@end

@interface WBUniversalTimelinePageInfo : WBModelObject
@property(retain, nonatomic) WBVideoModel *videoItem;

@end

@interface WBTimelinePageInfo : WBUniversalTimelinePageInfo
@end


@interface WBPageInfoVideoContentView : WBPageInfoMediaContentView
{
    WBTimelinePageInfo *_pageInfo;
}
@property(retain, nonatomic) WBTimelinePageInfo *pageInfo;
@end
