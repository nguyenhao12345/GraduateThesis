//
//  Constants.swift
//  SpaceXWiki
//
//  Created by Azi IOS on 11/13/18.
//  Copyright © 2018 Azi IOS. All rights reserved.
//

import UIKit

struct Constants {
    struct KEYUSERDEFAULTCHECKOUT{
        static let phone = "phoneBuy"
        static let name = "nameBuy"
        static let userId = "userId"
        static let backBillInfo = "backBillInfo"
        static let hideAddBill = "hideAddBill"
        static let nganluong = "nganluong"
        static let momo = "momo"
        static let noteShopcart = "noteShopcart"
        static let paymentMethod = "paymentMethod"
        static let fullname = "fullname"
        static let bankcode = "bankcode"
    }
    struct News24H{
        struct TYPE{
            static let news : Int = 1
            static let media : Int = 2
        }
        struct ATTACH{
            static let news : Int = 1
            static let product : Int = 2
            static let ctv : Int = 3
            static let link : Int = 4
        }
        
        struct TYPECONTENT{
            static let text : Int = 1
            static let media : Int = 2
            static let music: Int = 3
            static let taggedUser : Int = 4
            static let location: Int = 5
            static let feel: Int = 6
            static let time : Int = 7
            static let temp : Int = 8
            static let flag : Int = 9
        }
    }
    struct KEYPOSTNews24H{
        static let startPostingNews24h : String = "startPostingNews24h"
        
        static let startEditNews24h : String = "startEditNews24h"
        
        static let successAPINews24h : String = "successAPINews24h"
        
        static let failAPINews24h : String = "failAPINews24h"
    }
    struct KEYPOSTNEWS{
        static let checkPostingNews: String = "postingNews"
        static let checkPostingNewsToGroup: String = "postingNewsToGroup"
        static let checkPostingNewsToCommunity = "postingNewsToComunity"
        
        static let startAPIPostNews : String = "startAPIPostNews"
        static let startAPIPostNewsToGroup : String = "startAPIPostNewsToGroup"
        static let startAPIPostNewsCommunity : String = "startAPIPostNewsCommunity"
        
        static let startEditAPIPostNews : String = "startEditAPIPostNews"
        static let startEditAPIPostNewsToGroup : String = "startEditAPIPostNewsToGroup"
        static let startEditAPIPostNewsToCommunity : String = "startEditAPIPostNewsToCommunity"
        
        static let successAPIPostNews : String = "successAPIPostNews"
        static let successAPIPostNewsAds: String = "successAPIPostNewsAds"
        static let successAPIPostNewsToGroup : String = "successAPIPostNewsToGroup"
        static let successAPIPostNewsToCommunity : String = "successAPIPostNewsToCommunity"
        
        static let failAPIPostNews : String = "failAPIPostNews"
        static let failAPIPostNewsAds : String = "failAPIPostNewsAds"
        static let failAPIPostNewsToGroup : String = "failAPIPostNewsToGroup"
        static let failAPIPostNewsToCommunity : String = "failAPIPostNewsToCommunity"
    }
    
    struct KEYPOPTOVIEWCONTROLLER{
        static let popToGroupFeedViewController : String = "PopToGroupFeedViewController"
    }

    struct Margin {
        static let leadingComment: CGFloat = (UIScreen.main.bounds.size.width / 5).rounded(.up)
    }
    
    static let borderWidthImage : CGFloat = 5
    
    static let timeImageShow : Int = 9
    
    static let heightLabel: CGFloat = 18.0
    
    static let defaultText = "-1111"
    
    static let TypeLimitedPrice = 2
    
    static let numberProduct = 0
    static let numberCoupon = 2
    static let numberDiscountCode = 3
    
    static let heightContentLinkList : CGFloat =  18.5 + 17 + 20
    
    struct Register {
        static let VerifyingExpirationTime = 60
    }
    
    struct PaddingContent {
        static let leftAndRight: CGFloat = 11.0
        static let paddingCollectionView: CGFloat = 8.0
        static let paddingCenter: CGFloat = 10
        static let paddingBottom: CGFloat = 3
    }
    
    struct PermissionPost{
        static let ONLYME = 0
        static let ALL = 1
        static let ALL_EXCLUDE = 2
        static let FRIEND = 3
        static let FRIEND_EXCLUDE = 4
        static let FRIEND_LIST = 5
        static let FOLLOWER = 6
        static let FOLLOWER_EXCLUDE = 7
        static let FOLLOWER_LIST = 8
        static let CTV = 9
    }
    
    struct OrderStatus{
        static let New = "01"
        static let Confirming = "02"
        static let CustomerConfirming = "03"
        static let Confirmed = "04"
        static let Packing = "05"
        static let ChangeDepot = "06"
        static let Pickup = "07"
        static let Pickingup = "08"
        static let Pickedup = "09"
        static let Shipping = "10"
        static let Failed = "11"
        static let Aborted = "12"
        static let CarrierCanceled = "13"
        static let SoldOut = "14"
        static let Returning = "15"
        static let Returned = "16"
        static let Success = "98"
        static let Canceled = "99"
    }
    
    struct OrderStatus2{
        static let New = "01"
        static let Paid = "02"
        static let Used = "03"
    }
    
    struct OrderDeliver{
        static let shop = "SHO"
        static let GHN = "GHN"
        static let VTP = "VTP"
    }
    
    struct OrderPayment{
        static let shop = "info_cod"
    }
    
    struct NotificationName {
        static let DidAuthenticationChanged = Notification.Name("DidAuthenticationChanged")
        static let DidNewsTopicsChanged = Notification.Name("DidNewsTopicsChanged")
        static let DidUserProfileChanged = Notification.Name("DidUserProfileChanged")
        static let DidUpdateChatBadgeNumber = Notification.Name("DidUpdateChatBadgeNumber")
        static let DidUpdateNotificationBadgeNumber = Notification.Name("DidUpdateNotificationBadgeNumber")
        
        static let DidNightModeChanged = Notification.Name("DidNightModeChanged")
        static let kAVPlayerViewControllerDismissingNotification = Notification.Name("dismissing")
        
        static let DidChangeFriendHandler = Notification.Name("DidChangeFriendHandler")
        static let DidChangeFriendHandlerHome = Notification.Name("DidChangeFriendHandlerHome")
        static let DidChangeNewsLiked = Notification.Name("DidChangeNewsLiked")
        
    }
    
    struct Color {
        static let Pink = (0xFF2462).uiColor
    }
    
    struct Image {
        static let Default = UIImage(named: "image_default")!
        static let DefaultGifURL = Bundle.main.url(forResource: "default", withExtension: "gif")!
        static let DefaultImage = UIImage(named: "image_default")!
    }
    
    struct Time{
        static let timeEffect1 : Double = 0.325
        static let timeEffect4 : Double = 1.5
        static let timeEffect13 : Double = 2
        static let timeHidenNotiCutImage : TimeInterval = 10
        static let timeEffectMove : Double = 1.2
        static let timeOutConnected : Double = 60
    }
    struct LimitedFileSize {
        static let videoCustomLink : Int64 = 150
        static let videoIcon : Int64 = 200
        static let imageQuaility : CGFloat = 0.35
    }
    struct LimitedCharacter {
        static let titleNews : Int = 130
        static let desNews : Int = 500
        static let textInImage : Int = 60
        static let titleIcon : Int = 50
        static let desIcon : Int = 100
        static let desShort : Int = 180
        static let titleStatistical : Int = 30
        static let desStatistical : Int = 50
        static let keywords : Int = 130
        static let titleAdvertisement : Int = 30
        static let desAdvertisement : Int = 120
        static let titleRelated : Int = 100
        static let titleImage : Int = 60
        static let desImage : Int = 500
        static let desImageMe : Int = 1000
        static let desStallMenu : Int = 180
    }
    
    struct Effect{
        static let effect1 = "effect1"
        static let effect2 = "effect2"
        static let effect3 = "effect3"
        static let effect4 = "effect4"
        static let effect5 = "effect5"
        static let effect6 = "effect6"
        static let effect7 = "effect7"
        static let effect8 = "effect8"
        static let effect9 = "effect9"
        static let effect10 = "effect10"
        static let effect11 = "effect11"
        static let effect12 = "effect12"
        static let effect13 = "effect13"
    }
    
    struct EffectMove {
        static let left_to_right = "fadeInRight"
        static let right_to_left = "fadeInLeft"
        static let up_to_down = "fadeInDown"
        static let down_to_up = "fadeInUp"
    }
    
    struct Padding {
        static let widthEffectMove : CGFloat = 50
    }
    
    struct EffectPostSlider {
        static let turn = "turn"
        static let shift = "shift"
        static let louvers = "louvers"
        static let cube_over = "cube_over"
        static let tv = "tv"
        static let lines = "lines"
        static let bubbles = "bubbles"
        static let dribbles = "dribbles"
        static let glass_parallax = "glass_parallax"
        static let parallax = "parallax"
        static let brick = "brick"
        static let collage = "collage"
        static let seven = "seven"
        static let kenburns = "kenburns"
        static let cube = "cube"
        static let blur = "blur"
        static let book = "book"
        static let rotate = "rotate"
        static let domino = "domino"
        static let slices = "slices"
        static let blast = "blast"
        static let blinds = "blinds"
        static let basic = "basic"
        static let basic_linear = "basic_linear"
        static let fade = "fade"
        static let fly = "fly"
        static let flip = "flip"
        static let page = "page"
        static let stack = "stack"
        static let stack_vertical = "stack_vertical"
    }
    
    struct TypeSharePostType {
        static let TYPESHARE_AZI_HOME = 1//Trang chủ azi
        static let TYPESHARE_AZI_FILTERSHOP = 2//Trang cộng đồng
        static let TYPESHARE_AZI_FILTERUSER = 3//Trang cá nhân
        static let TYPESHARE_AZI_CATNEWS = 4//Trang danh mục tin
        static let TYPESHARE_AZI_QUICKVIEW = 5//Trang xem nhanh liên kết và sp trong tin
        static let TYPESHARE_AZI_PRO = 6//Trang sản phẩm
        static let TYPESHARE_AZI_CATPRODUCT = 7//Trang danh mục sản phẩm
        static let TYPESHARE_AZI_COUPON = 8//Trang phiếu mua hàng
        static let TYPESHARE_AZI_CATCOUPON = 9//Trang danh mục pmh
        static let TYPESHARE_AZI_GALLERYPRO = 10
        static let TYPESHARE_AZI_GALLERYCOU = 11
        static let TYPESHARE_AZI_CART = 12//Trang giỏ hàng
        static let TYPESHARE_AZI_SEARCHNEWS = 13//Trang tìm tin tức
        static let TYPESHARE_AZI_SEARCHPRODUCT = 14//Trang tìm sản phẩm
        static let TYPESHARE_AZI_SEARCHCOUPON = 15//Trang tìm pmhang
        
        static let TYPESHARE_SHOP_HOME = 16//Trang chủ gian hàng
        static let TYPESHARE_SHOP_PAGESHOP = 17//Trang cửa hàng của gian hàng
        static let TYPESHARE_SHOP_ALLPRODUCT = 18//Trang tất cả sản phẩm của gian hàng
        static let TYPESHARE_SHOP_ALLCOUPON = 19//Trang tất cả pmh của gian hàng
        static let TYPESHARE_SHOP_LIBLINK = 20//Trang thư viện liên kết của gian hàng
        static let TYPESHARE_SHOP_LIBLINKTAB = 21//Trang chi tiết tvien liên kết theo tung tab gian hàng
        static let TYPESHARE_SHOP_LIBIMAGE = 22//Trang thư viện ảnh của gian hàng
        static let TYPESHARE_SHOP_LIBVIDEO = 23//Trang thư viện video của gian hàng
        static let TYPESHARE_SHOP_LIBPRODUCT = 24//Trang thư viện sản phẩm của gian hàng
        static let TYPESHARE_SHOP_LIBCOUPON = 25//Tvien pmh của gh
        static let TYPESHARE_SHOP_COLLECTNEWS = 26//Trang bộ sưu tập tin của gh
        static let TYPESHARE_SHOP_COLLECTPRODUCT = 27//Bst sp của gh
        static let TYPESHARE_SHOP_COLLECTCOUPON = 28//Bst pmh của gh
        static let TYPESHARE_SHOP_COLLECTLINK = 29//Bst link
        static let TYPESHARE_SHOP_RECRUITMENT = 30//Trang tuyển dụng
        static let TYPESHARE_SHOP_WARRANTY = 31//Trang chính sách
        static let TYPESHARE_SHOP_INTRODUCT = 32//Trang giới thiệu
        static let TYPESHARE_SHOP_CONTACT = 33//Trang liên hệ
        static let TYPESHARE_SHOP_SEARCHNEWS = 34//Trang tìm tin của gian hàng
        static let TYPESHARE_SHOP_SEARCHPRODUCT = 35//Tìm sp của gh
        static let TYPESHARE_SHOP_SEARCHCOUPON = 36//Tìm pmh của gh
        
        static let TYPESHARE_PROFILE_HOME = 37//Trang dòng thời gian profile
        static let TYPESHARE_PROFILE_FRIENDS = 38//Trang bạn bè profile
        static let TYPESHARE_PROFILE_ABOUT = 39//Giới thiệu về profile
        static let TYPESHARE_PROFILE_LIBIMG = 40//Tvien ảnh profile
        static let TYPESHARE_PROFILE_LIBVIDEO = 41//Tvien video profile
        static let TYPESHARE_PROFILE_LIBLINK = 42//Tvien liên kết profile
        static let TYPESHARE_PROFILE_LIBLINKTAB = 43//Trang chi tiết tvien liên kết theo tung tab profile
        static let TYPESHARE_PROFILE_SHOP = 44//Trang gian hàng profile
        static let TYPESHARE_PROFILE_ALLPRODUCT = 45//Trang tất cả sp profile
        static let TYPESHARE_PROFILE_ALLCOUPON = 46//Trang tất cả pmh profile
        static let TYPESHARE_PROFILE_SEARCHNEWS = 47//Trang tìm kiếm tin tức profile
        static let TYPESHARE_PROFILE_SEARCHPRODUCT = 48//Trang tìm kiếm sp profile
        static let TYPESHARE_PROFILE_SEARCHCOUPON = 49//Trang tìm kiếm pmh profile
        
        static let TYPESHARE_DETAIL_PRODUCT = 50//Trang chi tiết sp
        static let TYPESHARE_DETAIL_COUPON = 51//Trang chi tiết pmh
        static let TYPESHARE_DETAIL_SHOPNEWS = 52//Trang chi tiết tin tức gian hang
        static let TYPESHARE_DETAIL_PRFNEWS = 53//Trang chi tiết tin tức cá nhân
        static let TYPESHARE_DETAIL_SHOPCOLLNEWS = 54//Trang chi tiết bst tin gian hàng
        static let TYPESHARE_DETAIL_SHOPCOLLPRODUCT = 55//Trang chi tiết bst sp gian hàng
        static let TYPESHARE_DETAIL_SHOPCOLLCOUPON = 56//Trang chi tiết bst pmh gian hàng
        static let TYPESHARE_DETAIL_SHOPCOLLLINK = 57//Trang chi tiết bst liên kết gian hàng
        static let TYPESHARE_DETAIL_SHOPLIBIMG = 58//Trang chi tiết tvien ảnh gian hàng
        static let TYPESHARE_DETAIL_SHOPLIBVIDEO = 59//Trang chi tiết tvien video gian hàng
        static let TYPESHARE_DETAIL_SHOPLIBLINK = 60//Trang chi tiết tvien liên kết gian hàng
        static let TYPESHARE_DETAIL_PRFLIBIMG = 61//Trang chi tiết tvien ảnh profile
        static let TYPESHARE_DETAIL_PRFLIBVIDEO = 62//Trang chi tiết tvien video profile
        static let TYPESHARE_DETAIL_PRFLIBLINK = 63//Trang chi tiết tvien liên kết profile
        static let TYPESHARE_DETAIL_SHOPLINK_CONTENT = 64// Trang chi tiết liên kết tin của gian hàng
        static let TYPESHARE_DETAIL_SHOPLINK_IMG = 65// Trang chi tiết liên kết ảnh của gian hàng
        static let TYPESHARE_DETAIL_PRFLINK_CONTENT = 66// Trang chi tiết liên kết tin của cá nhân
        static let TYPESHARE_DETAIL_PRFLINK_IMG = 67// Trang chi tiết liên kết ảnh của cá nhân
        
        static let TYPESHARE_AZI_LINK = 68
        static let TYPESHARE_AZI_TABLINK = 69
        static let TYPESHARE_AZI_DETAIL_LINK = 70
        
        static let TYPESHARE_DETAIL_SHOPIMG = 71 //Trang chi tiet từng ảnh cua shop.
        static let TYPESHARE_DETAIL_SHOPVIDEO = 72 //Trang chi tiết từng video của shop
        static let TYPESHARE_DETAIL_PRFIMG = 73 //Trang chi tiết từng ảnh của profile
        static let TYPESHARE_DETAIL_PRFVIDEO = 74 //Trang chi tiết từng video của profile
        static let TYPESHARE_PROFILE_COLLECTNEWS = 75//Trang bộ sưu tập tin cá nhân
        static let TYPESHARE_PROFILE_COLLECTPRODUCT = 76//Bst sp cá nhân
        static let TYPESHARE_PROFILE_COLLECTCOUPON = 77//Bst pmh cá nhân
        static let TYPESHARE_PROFILE_COLLECTLINK = 78//Bst link cá nhân
        static let TYPESHARE_HOME_NEWS = 79//share news trên feed home của app
        static let TYPESHARE_SHOP_NEWS = 80//share news trên feed của shop
        static let TYPESHARE_PROFILE_NEWS = 81//share news trên feed của user
        static let TYPESHARE_DETAIL_HOMENEWS = 82// trang chi tiết tin tức khi user từ home page đi vào
        static let TYPESHARE_DETAIL_DISCOUNT_CODE = 83 //
    }
    
    public static func getHiddenDesCellAttriString(tabDesString: String = "Bài viết") -> NSMutableAttributedString {
        var attributedString: NSMutableAttributedString
        
        attributedString = Helper.getAttributesStringWithFontAndColor(string: tabDesString + " bị ẩn\n", font: UIFont.kohoSemiBold16, color: .black)
        attributedString.append(Helper.getAttributesStringWithFontAndColor(string: "Bạn sẽ không nhìn thấy " + tabDesString.lowercased() + " này trên bảng tin", font: UIFont.kohoMedium16, color: .gray))
        return attributedString
    }
}

class Const {
    static let plahoderComment: String = "Viết bình luận..."
//    static let domain : String = "http://\(domain_name)" //up Store product
    
//    static let domain_name : String = "azibai.xyz" //staggin image
//    static let domain_name : String = "azibai.com" //up Store product
    static let widthScreen : Int = Int(UIScreen.main.bounds.size.width)
        //huy set width & heigtht screen
    static let widthScreens : CGFloat = UIScreen.main.bounds.size.width
    static let heightScreen : CGFloat = UIScreen.main.bounds.size.height
    
//    static let urlImageAvatar_ChatGroupDefault = "\(domain)/app/azibai-api/public/images"
//    static let urlImageAvatar_ChatGroup = "\(domain)/media/chat_media"
//    static let urlImageAvatar = "\(domain)/media/images/avatar"
//    //static let urlImageNews = "\(domain)/media/\(width)/images/tintuc"
//    static let urlImageNews = "\(domain)/media/images/tintuc"
//    static let urlImageShopLogo = "\(domain)/media/shop/logos/"
//    static let urlImageShopBanner = "\(domain)/media/shop/banners/"
//    static let urlImageProducts = "\(domain)/media/images/product/"

    //static let urlImageAvatar_ChatGroupDefault = "\(linkImage)/app/azibai-api/public/images"
//    static let urlImageAvatar_ChatGroup = APIHelper.ImageURL.absoluteString + "chat_media"
//    static let urlImageAvatar = APIHelper.ImageURL.absoluteString + "images/avatar"
//    //static let urlImageNews = "\(width)/images/tintuc"
//    static let urlImageNews = APIHelper.ImageURL.absoluteString + "images/content"
//    static let urlImageShopLogo = APIHelper.ImageURL.absoluteString + "shop/logos/"
//    static let urlImageShopBanner = APIHelper.ImageURL.absoluteString + "shop/banners/"
//    static let urlImageProducts = APIHelper.ImageURL.absoluteString + "images/product/"
//    static let urlImageBackgroudChat = APIHelper.ImageURL.absoluteString + "background"
    
    static let pickerDataSetTimer = ["Tắt".localized, "5 giây".localized, "10 giây".localized, "30 giây".localized, "1 phút".localized, "5 phút".localized, "10 phút".localized, "30 phút".localized, "1 giờ".localized, "6 giờ".localized, "12 giờ".localized, "1 ngày".localized]
    
    static let pickerDataRepeatConversation = ["1 phút".localized,"5 phút".localized, "10 phút".localized, "30 phút".localized, "1 giờ".localized, "6 giờ".localized, "12 giờ".localized]
    
    static let meProfilePath = "meProfile.json"
    
    static let kIsOnline_ReachabilityNetwork = "kIsOnline_ReachabilityNetwork"
}
