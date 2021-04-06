//
//  FeedHeaderSectionController.swift
//  Piano_App
//
//  Created by Azibai on 09/10/2020.
//  Copyright © 2020 com.nguyenhieu.demo. All rights reserved.
//

import IGListKit
import Mapper

protocol FeedHeaderSectionDelegate: class {
    
}

class FeedHeaderSectionModel: AziBaseSectionModel {
    var dataModels: [SongsLocalDetail] = [
        SongsLocalDetail(image: "cham-day-noi-dau", nameSong: "Chạm đáy nỗi đau", urlSong: "Cam Am Cham Day Noi Dau", content: "Chạm Đáy Nỗi Đau sản phẩm âm nhạc mới nhất của ca sĩ Erik dành tới khán giả, lời bài hát Chạm đáy nỗi đau được chắp bút bởi nhạc sĩ Mr.Siro, với giai điệu ca từ ngọt ngào bài hát hứa hẹn sẽ trở thành bài hit của Erik và Mr.Siro, hãy cùng chơi thử bài hát này bằng Piano nhé"),
        SongsLocalDetail(image: "mot-buoc-yeu-van-dam-dau", nameSong: "Một bước yêu vạn dặm đau", urlSong: "Cam Am Mot Buoc Yeu Van Dam Dau", content: "abc"),
        SongsLocalDetail(image: "dung-hoi-em", nameSong: "Đừng hỏi em", urlSong: "Cam Am Dung Hoi Em", content: "Nhẹ nhàng, sâu lắng về một cuộc tình buồn nên dễ đi vào lòng người bởi giai điệu dễ nghe dễ nhớ, và hơn thế nữa nó còn là nhạc của một bộ phim cổ trang cực hay nên cũng dễ hiểu về mức độ hot của ca khúc này. Cảm âm Thần thoại cũng vì thế được nhiều anh em săn tìm, dù đã được chia sẻ khá lâu rồi, nhưng mức độ hot vẫn được nhiều anh em tiến hành cover những phong cách của riêng mình, hay hòa tấu với những nhạc cụ khác. Đây là ca khúc nhạc phim Trung Quốc hay, là một trong nhiều cảm âm nhạc hoa hay ca khúc nước ngoài cực hay và được nhiều người yêu thích"),
        SongsLocalDetail(image: "ThanThoai", nameSong: "Thần Thoại", urlSong: "Cam Am Than Thoai C5", content: "Nhẹ nhàng, sâu lắng về một cuộc tình buồn nên dễ đi vào lòng người bởi giai điệu dễ nghe dễ nhớ, và hơn thế nữa nó còn là nhạc của một bộ phim cổ trang cực hay nên cũng dễ hiểu về mức độ hot của ca khúc này. Cảm âm Thần thoại cũng vì thế được nhiều anh em săn tìm, dù đã được chia sẻ khá lâu rồi, nhưng mức độ hot vẫn được nhiều anh em tiến hành cover những phong cách của riêng mình, hay hòa tấu với những nhạc cụ khác. Đây là ca khúc nhạc phim Trung Quốc hay, là một trong nhiều cảm âm nhạc hoa hay ca khúc nước ngoài cực hay và được nhiều người yêu thích"),
        SongsLocalDetail(image: "tinh-don-phuong", nameSong: "Tình đơn phương", urlSong: "Cam Am Tinh Don Phuong", content: "Nhẹ nhàng, sâu lắng về một cuộc tình buồn nên dễ đi vào lòng người bởi giai điệu dễ nghe dễ nhớ, và hơn thế nữa nó còn là nhạc của một bộ phim cổ trang cực hay nên cũng dễ hiểu về mức độ hot của ca khúc này. Cảm âm Thần thoại cũng vì thế được nhiều anh em săn tìm, dù đã được chia sẻ khá lâu rồi, nhưng mức độ hot vẫn được nhiều anh em tiến hành cover những phong cách của riêng mình, hay hòa tấu với những nhạc cụ khác. Đây là ca khúc nhạc phim Trung Quốc hay, là một trong nhiều cảm âm nhạc hoa hay ca khúc nước ngoài cực hay và được nhiều người yêu thích")
    ]
    
    override init() {
        super.init()
    }
    required init(map: Mapper) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func getSectionInit() -> SectionControllerInterface? {
        return FeedHeaderSectionController()
    }
}

class FeedHeaderSectionController: SectionController<FeedHeaderSectionModel> {
    
    weak var delegate: FeedHeaderSectionDelegate?
    
    @nonobjc override func setPresenter(_ presenter: AnyObject?) {
        super.setPresenter(presenter)
        self.delegate = presenter as? FeedHeaderSectionDelegate
    }
    
    override func getCellBuilder() -> CellBuilderInterface? {
        return FeedHeaderCellBuilder()
    }
    
}

class FeedHeaderCellBuilder: CellBuilder {
    
    override func parseCellModels() {
        guard let sectionModel = sectionModel as? FeedHeaderSectionModel else { return }
        addBlankSpace(24, width: nil, color: .clear)

        let cell = FeedHeaderSlidePageCellModel()
        cell.dataModels = sectionModel.dataModels
        appendCell(cell)
        
    }
}
