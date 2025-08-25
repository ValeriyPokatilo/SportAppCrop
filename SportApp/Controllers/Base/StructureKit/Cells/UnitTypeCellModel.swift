import UIKit
import StructureKit

final class UnitTypeCellModel: StructurableForTableView {

    var valueChanged: ParameterBlock<UnitType>
    var selectedSegmentIndex: Int?
    
    init(selectedSegmentIndex: Int?, valueChanged: @escaping ParameterBlock<UnitType>) {
        self.valueChanged = valueChanged
        self.selectedSegmentIndex = selectedSegmentIndex
    }

    func configure(tableViewCell cell: UnitTypeCell) {
        cell.configure(with: self)
        cell.valueChanged = valueChanged
    }
}
