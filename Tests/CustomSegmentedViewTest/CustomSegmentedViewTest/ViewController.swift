//
//  ViewController.swift
//  CustomSegmentedViewTest
//
//  Created by Huynh Tan Phu on 26/01/2022.
//

import UIKit
import Combine
import CustomSegmentedView

class ViewController: UIViewController {
    var cancelable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIButton()
        button1.setTitle("Button 1", for: .normal)
        button1.backgroundColor = .red

        let button2 = UIButton()
        button2.setTitle("Button 2", for: .normal)
        button2.backgroundColor = .green

        let button3 = UIButton()
        button3.setTitle("Button 3", for: .normal)
        button3.backgroundColor = .yellow

        // Indicator view
        let indicatorView = UIView()
        indicatorView.backgroundColor = .black

        let segmentedView = CustomSegmentedView(segmentedViews: [button1, button2, button3], spacing: 20, selectedIndex: 0, indicatorView: indicatorView)
        segmentedView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedView)
        NSLayoutConstraint.activate([
            segmentedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            segmentedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        cancelable = segmentedView.selectedIndexSubject.sink(receiveValue: { selectedIndex in
            print("Selected index \(selectedIndex)")
        })

        segmentedView.selectSegment(at: 1, animated: true)
    }
}

