import LiquidGlassKit
import UIKit

final class ClearPresetDemoViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Clear Liquid Glass"
        configureBackground()
        configureLayout()
        populateCards()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.sublayers?.first { $0.name == "demo.background" }?.frame = view.bounds
    }

    private func configureBackground() {
        view.backgroundColor = .systemBackground

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "demo.background"
        gradientLayer.colors = [
            UIColor(red: 0.08, green: 0.13, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 0.18, green: 0.46, blue: 0.70, alpha: 1).cgColor,
            UIColor(red: 0.96, green: 0.57, blue: 0.25, alpha: 1).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        let pattern = PatternView()
        pattern.translatesAutoresizingMaskIntoConstraints = false
        pattern.isUserInteractionEnabled = false
        pattern.backgroundColor = .clear
        view.addSubview(pattern)
        NSLayoutConstraint.activate([
            pattern.topAnchor.constraint(equalTo: view.topAnchor),
            pattern.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pattern.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pattern.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .fill

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
        ])
    }

    private func populateCards() {
        let heading = UILabel()
        heading.text = "Fallback vs Native"
        heading.textColor = .white
        heading.font = .preferredFont(forTextStyle: .largeTitle)
        heading.adjustsFontForContentSizeCategory = true
        stackView.addArrangedSubview(heading)

        let body = UILabel()
        body.text = "The clear fallback should keep the center mostly transparent while retaining subtle refraction and edge highlights."
        body.textColor = UIColor.white.withAlphaComponent(0.86)
        body.font = .preferredFont(forTextStyle: .body)
        body.adjustsFontForContentSizeCategory = true
        body.numberOfLines = 0
        stackView.addArrangedSubview(body)

        stackView.addArrangedSubview(makeEffectCard(title: "Fallback Regular", style: .regular, isNative: false))
        stackView.addArrangedSubview(makeEffectCard(title: "Fallback Clear", style: .clear, isNative: false))

        if #available(iOS 26.0, *) {
            stackView.addArrangedSubview(makeEffectCard(title: "Native Regular", style: .regular, isNative: true))
            stackView.addArrangedSubview(makeEffectCard(title: "Native Clear", style: .clear, isNative: true))
        } else {
            stackView.addArrangedSubview(makeUnavailableCard(title: "Native Regular"))
            stackView.addArrangedSubview(makeUnavailableCard(title: "Native Clear"))
        }
    }

    private func makeEffectCard(title: String, style: LiquidGlassEffect.Style, isNative: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 150).isActive = true

        let effect = LiquidGlassEffect(style: style, isNative: isNative)
        let effectView = VisualEffectView(effect: effect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.layer.cornerRadius = 28
        effectView.layer.cornerCurve = .continuous
        effectView.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true

        let detailLabel = UILabel()
        detailLabel.text = isNative ? "iOS 26 native UIGlassEffect" : "LiquidGlassKit fallback renderer"
        detailLabel.textAlignment = .center
        detailLabel.textColor = UIColor.white.withAlphaComponent(0.78)
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.adjustsFontForContentSizeCategory = true

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.spacing = 4
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(effectView)
        effectView.contentView.addSubview(labelStack)

        NSLayoutConstraint.activate([
            effectView.topAnchor.constraint(equalTo: container.topAnchor),
            effectView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            effectView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            effectView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            labelStack.centerXAnchor.constraint(equalTo: effectView.contentView.centerXAnchor),
            labelStack.centerYAnchor.constraint(equalTo: effectView.contentView.centerYAnchor),
            labelStack.leadingAnchor.constraint(greaterThanOrEqualTo: effectView.contentView.leadingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(lessThanOrEqualTo: effectView.contentView.trailingAnchor, constant: -16),
        ])

        return container
    }

    private func makeUnavailableCard(title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 112).isActive = true
        container.backgroundColor = UIColor.black.withAlphaComponent(0.24)
        container.layer.cornerRadius = 22
        container.layer.cornerCurve = .continuous

        let label = UILabel()
        label.text = "\(title) requires iOS 26"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16),
        ])

        return container
    }
}

private final class PatternView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineWidth(10)

        let colors = [
            UIColor.white.withAlphaComponent(0.18).cgColor,
            UIColor.systemPink.withAlphaComponent(0.30).cgColor,
            UIColor.systemYellow.withAlphaComponent(0.28).cgColor,
            UIColor.systemTeal.withAlphaComponent(0.26).cgColor,
        ]

        for index in stride(from: -rect.height, through: rect.width, by: 54).enumerated() {
            context.setStrokeColor(colors[index.offset % colors.count])
            context.move(to: CGPoint(x: index.element, y: rect.maxY))
            context.addLine(to: CGPoint(x: index.element + rect.height, y: rect.minY))
            context.strokePath()
        }
    }
}
