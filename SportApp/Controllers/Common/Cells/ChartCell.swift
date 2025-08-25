import Foundation
import SnapKit
import DGCharts

final class ChartCell: UITableViewCell, ChartViewDelegate {

    private var chartView = LineChartView()
    private var descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: ChartCellModel) {
        if model.values.count > 1 {
            initialize(sets: model.values, title: model.unitString)
        } else {
            chartView.noDataText = "emptyChartStr".localized()
        }

        let nonNilValues = model.values.compactMap { $0 }
        if let min = nonNilValues.min(), let max = nonNilValues.max() {
            let unit = model.unitString
            descriptionLabel.text = "\("fromStr".localized()) \(min) \("toStr".localized()) \(max) \(unit)"
        }
    }

    private func configureAppearance() {
        backgroundColor = .baseLevelZero25
        descriptionLabel.font = .systemFont(ofSize: 12)
        selectionStyle = .none
    }

    private func addViews() {
        contentView.addSubview(chartView)
        contentView.addSubview(descriptionLabel)
    }

    private func configureLayout() {
        chartView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(200)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    private func initialize(sets: [Double] = [], title: String) {
        chartView.delegate = self

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        let maxValue = sets.compactMap { $0 }.max() ?? 0.0
        leftAxis.axisMaximum = maxValue * 1.2
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true

        chartView.leftAxis.enabled = true
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false

        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)

        chartView.marker = marker
        chartView.setScaleEnabled(false)
        chartView.doubleTapToZoomEnabled = false

        chartView.legend.form = .line

        setDataCount(title: title, sets: sets)

        chartView.animate(xAxisDuration: 0.5)
    }

    func setDataCount(title: String, sets: [Double?] = []) {
        let values = (0..<sets.count).map { (index) -> ChartDataEntry in
            let val = sets[index]
            return ChartDataEntry(x: Double(index), y: val ?? .nan, icon: .dotImg)
        }

        let lineSet = LineChartDataSet(entries: values, label: title)
        lineSet.drawIconsEnabled = false
        setup(lineSet)

        let gradient = CGGradient(
            colorsSpace: nil,
            colors: [UIColor.baseLevelZero25.cgColor, UIColor.systemGreen.cgColor] as CFArray,
            locations: nil
        )

        guard let gradient else {
            return
        }

        lineSet.fillAlpha = 1
        lineSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        lineSet.drawFilledEnabled = true

        let data = LineChartData(dataSet: lineSet)

        chartView.data = data
    }

    private func setup(_ dataSet: LineChartDataSet) {
        dataSet.lineDashLengths = [5, 2.5]
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.setColor(.black)
        dataSet.setCircleColor(.black)
        dataSet.gradientPositions = nil
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.valueFont = .systemFont(ofSize: 9)
        dataSet.formLineDashLengths = [5, 2.5]
        dataSet.formLineWidth = 1
        dataSet.formSize = 15
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("### chartValueSelected")
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("### chartValueNothingSelected")
    }
}
