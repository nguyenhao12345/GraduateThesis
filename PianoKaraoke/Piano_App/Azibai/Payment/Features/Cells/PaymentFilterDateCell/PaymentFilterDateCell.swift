//
//  PaymentFilterDateCell.swift
//  Piano_App
//
//  Created by Azibai on 04/05/2021.
//  Copyright © 2021 com.nguyenhieu.demo. All rights reserved.
//

import UIKit

protocol PaymentFilterDateCellDelegate: class {

}

class PaymentFilterDateCellModel: AziBaseCellModel {
    var filter: PaymentFilterHistory
    
    init(filter: PaymentFilterHistory) {
        self.filter = filter
        super.init()
    }

    override func getCellHeight(maxWidth: CGFloat) -> CGFloat {
        return 100
    }
    
    override func getCellName() -> String {
        return PaymentFilterDateCell.className
    }
}

class PaymentFilterDateCell: CellModelView<PaymentFilterDateCellModel> {
    
    weak var delegate: PaymentFilterDateCellDelegate?
    @IBOutlet weak var labelFirstDate: UILabel!
    @IBOutlet weak var labelLastDate: UILabel!
    
    override func setCustomDelegate(_ section: Any) {
        self.delegate = section as? PaymentFilterDateCellDelegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindCellModel(_ cellModel: PaymentFilterDateCellModel) {
        super.bindCellModel(cellModel)
        switch cellModel.filter.time {
        case .SevenDay, .ThirtyDay:
            _fromDate = nil
            _toDate = nil
        default:
            _fromDate = Date(dateString: cellModel.filter.time.getDates().0)
            _toDate = Date(dateString: cellModel.filter.time.getDates().1)
        }

    }
    var _minimumDate: String = "01/01/1990"
    let _datePicker = DatePickerDialog(textColor: (0x454545).uiColor, buttonColor: .black, font: UIFont(name: "KoHo", size: 16)!, locale: Locale.current, showCancelButton: true)
    
    private var _fromDate: Date? {
        didSet {
            if _fromDate == nil {
                labelFirstDate.text = "Chọn ngày"
            }
            else {
                labelFirstDate.text = _fromDate?.toString(withFormat: "dd/MM/yyyy")
            }
        }
    }
    private var _toDate: Date? {
        didSet {
            if _toDate == nil {
                labelLastDate.text = "Chọn ngày"
            }
            else {
                labelLastDate.text = _toDate?.toString(withFormat: "dd/MM/yyyy")
            }
        }
    }
    private func fromDateTouchableViewTapped() {
        let date = _fromDate ?? Date()
        _datePicker.show("Từ".localized,
                         doneButtonTitle: "Xong".localized,
                         cancelButtonTitle: "Xóa".localized,
                         defaultDate: date,
                         minimumDate: Date(dateString: _minimumDate, format: "dd/MM/yyyy"),
                         maximumDate: Date(),
                         datePickerMode: .date)
        { [weak self] (selected) in
            guard let self = self else { return }
            self._fromDate = selected
            self.cellModel?.filter.time = .Some(startDate: self._fromDate?.toString(withFormat: "dd/MM/yyyy") ?? "Chọn ngày", endDate: self._toDate?.toString(withFormat: "dd/MM/yyyy") ?? "Chọn ngày")
        }
    }
    private func toDateTouchableViewTapped() {
        let min = _fromDate ?? Date(dateString: _minimumDate, format: "dd/MM/yyyy")
        let date = _toDate ?? Date()
        _datePicker.show("Đến".localized,
                         doneButtonTitle: "Xong".localized,
                         cancelButtonTitle: "Xóa".localized,
                         defaultDate: date,
                         minimumDate: min,
                         maximumDate: Date(),
                         datePickerMode: .date)
        { [weak self] (selected) in
            guard let self = self else { return }
            self._toDate = selected
            self.cellModel?.filter.time = .Some(startDate: self._fromDate?.toString(withFormat: "dd/MM/yyyy") ?? "Chọn ngày", endDate: self._toDate?.toString(withFormat: "dd/MM/yyyy") ?? "Chọn ngày")
        }
    }
    
    @IBAction func clickChangeFirstDate(_ sender: Any) {
        fromDateTouchableViewTapped()
    }
    @IBAction func clickChangeLastDate(_ sender: Any) {
        toDateTouchableViewTapped()
    }

}
