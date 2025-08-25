import Foundation
import StructureKit

final class LabelCellModel: StructurableForTableView,
                            StructurableIdentifable,
                            StructurableSelectable,
                            StructurableContentIdentifable {

    let id: AnyHashable
    let text: String
    let color: UIColor
    let background: UIColor
    let size: CGFloat
    let weight: UIFont.Weight
    let alignment: NSTextAlignment
    let didSelect: DidSelect?

    init(
        id: AnyHashable,
        text: String,
        color: UIColor = .baseLevelOne,
        background: UIColor = .baseLevelZero25,
        size: CGFloat = 14,
        weight: UIFont.Weight = .regular,
        alignment: NSTextAlignment = .left,
        didSelect: DidSelect? = nil
    ) {
        self.id = id
        self.text = text
        self.color = color
        self.background = background
        self.size = size
        self.weight = weight
        self.alignment = alignment
        self.didSelect = didSelect
    }

    func configure(tableViewCell cell: LabelCell) {
        cell.configure(with: self)
    }

    func identifyHash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func contentHash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(size)
        hasher.combine(weight)
        hasher.combine(color)
        hasher.combine(background)
    }
}
