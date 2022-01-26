//
//  CustomSegmentedView.swift
//  CustomSegmentedView
//
//  Created by Huynh Tan Phu on 26/01/2022.
//

import UIKit
import Combine

public class CustomSegmentedView: UIView {
    /// A spacing between each segmented view
    private var spacing: CGFloat = 8.0
    /// A array of segmented view
    private var segmentedViews: [UIView]
    /// A selected index
    public var selectedIndex: Int
    /// A pass through subject to emit the selected index
    public let selectedIndexSubject = PassthroughSubject<Int, Never>()
    /// A indicator view
    private var indicatorView: UIView?
    /// A indicator height
    private var indicatorHeight: CGFloat
    /// A type for animating closure
    public typealias AnimatingClosure = (_ index: Int, _ selectedIndex: Int, _ view: UIView) -> Void
    /// A animator closure. Used to animate the selected segment.
    /// It will be called many times depending on the number of segmented views.
    private var animatorClosure: AnimatingClosure?

    /// Init a segmented view
    /// - Parameters:
    ///   - segmentedViews: An array of views
    ///   - spacing: A spacing between each segmented view
    ///   - selectedIndex: A selected index
    ///   - indicatorView: A indicator view. Input `nil` if you don't want to show the indicator.
    ///   - indicatorHeight: A height of the indicator view
    ///   - animatorClosure: Used to animate the selected segmented. It will be called many times depending the number of added views.
    public init(segmentedViews: [UIView], spacing: CGFloat = 8.0,
         selectedIndex: Int = 0, indicatorView: UIView? = nil,
         indicatorHeight: CGFloat = 3,
         animatorClosure: AnimatingClosure? = CustomSegmentedView.alphaAnimator
    ) {
        self.spacing = spacing
        self.segmentedViews = segmentedViews
        self.selectedIndex = selectedIndex
        self.indicatorView = indicatorView
        self.indicatorHeight = indicatorHeight
        self.animatorClosure = animatorClosure

        super.init(frame: .zero)
        configureView()
    }

    @available(*, unavailable, message: "Instantiating via Xib & Storyboard is prohibited.")
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        // Add stack view
        addSubview(stackView)
        // Add indicator view if any
        indicatorView.map {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Config stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        // Update spacing for stack view
        stackView.spacing = spacing

        // Add all segmented views into the stack view
        segmentedViews.forEach{stackView.addArrangedSubview($0)}

        // Select segment
        selectSegment(at: selectedIndex)

        // Add tap gesture for all segmented view
        addGesture(for: segmentedViews)
    }

    public override func layoutSubviews() {
        // Update indicator
        self.updateIndicator()
    }

    // MARK: - Helper methods

    private func updateIndicator() {
        // Draw indicator view
        if let indicatorView = indicatorView {
            let width = (frame.width - spacing * CGFloat(segmentedViews.count - 1)) / CGFloat(segmentedViews.count)
            let x = width * CGFloat(selectedIndex) + (spacing * CGFloat(selectedIndex))
            let y = bounds.height - indicatorView.bounds.height
            let frame = CGRect(x: x, y: y, width: width, height: indicatorHeight)
            indicatorView.frame = frame
        }
    }

    public func selectSegment(at index: Int, animated: Bool = true) {
        selectedIndex = index
        let closure = {
            for (i, view) in self.segmentedViews.enumerated() {
                self.animatorClosure?(i, index, view)
            }
            // Update indicator
            self.updateIndicator()
        }
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { closure() }
        if animated {
            animator.startAnimation()
        } else {
            closure()
        }
    }

    /// Add tap gesture for all segmented view
    private func addGesture(for views: [UIView]) {
        views.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
            $0.addGestureRecognizer(tapGesture)
            $0.isUserInteractionEnabled = true
        }
    }

    @objc func viewTapped(sender: UITapGestureRecognizer) {
        print("[CustomSegmentedView]segmented view tapped!")
        guard let view = sender.view else { return }
        guard let viewIndex = segmentedViews.firstIndex(of: view) else { return }
        selectSegment(at: viewIndex)
        // Emits selected index to all subscribers
        selectedIndexSubject.send(viewIndex)
    }

    // MARK: - Subviews

    /// A stack view used to arrange the segmented view
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public static let alphaAnimator: AnimatingClosure = { index, selectedIndex, view in
        view.alpha = selectedIndex == index ? 1.0 : 0.4
    }
}
