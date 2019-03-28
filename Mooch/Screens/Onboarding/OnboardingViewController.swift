////
//  OnboardingViewController.swift
//  MoochApp
//
//  Created by App Center on 12/28/18.
//  Copyright © 2018 rlukedavis. All rights reserved.
//

import UIKit
import SwiftyOnboard
import SnapKit
import LDLogger

class OnboardingViewController: UIPageViewController, Storyboarded {

    var coordinator: MainCoordinator!
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let first = onboardingViewControllers.first {
            self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator.navigationController.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        coordinator.navigationController.isNavigationBarHidden = false
    }
    
    let pageText: [String] = ["Mooch - create your own econcomy",
                              "Share stuff with people you know and trust, track who has items, set reminders for return",
                              "Rent you stuff so you can make money on things you own.",
                              "Sell your things in a network you create",
                              "Create a shared economy with people you choose or make your items available on the Mooch Market."]
    
    lazy var onboardingViewControllers: [UIViewController] = {
        var vcs: [UIViewController] = []
        for item in pageText {
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            configureLabel(in: vc, with: item)
            createSkipButton(in: vc)
            vcs.append(vc)
        }
        let getStarted = GetStartedViewController.instantiate(from: "Onboarding")
        getStarted.coordinator = self.coordinator
        vcs.append(getStarted)

        return vcs
    }()
    
    // MARK: - Setup
    private func setupPageControl() {
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.onboardingViewControllers.count
        self.pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    @IBAction func startLoginSignUp(_ sender: UIButton) {
        coordinator.signup()
    }
    
    // MARK: - Class Functions
    func configureLabel(in controller: UIViewController, with text: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        label.text = text
        label.numberOfLines = 0
        
        controller.view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    func createSkipButton(in controller: UIViewController) {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.addTarget(self, action: #selector(skipToGettingStarted(_:)), for: .touchUpInside)
        controller.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview().inset(32)
        }
    }
    
    @objc func skipToGettingStarted(_ button: UIButton) {
        if let last = onboardingViewControllers.last {
            setViewControllers([last], direction: .forward, animated: true) { (done) in
                Log.d("Moved to Getting Started")
                self.pageControl.currentPage = self.onboardingViewControllers.count
            }
        }
    }
    
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let vcindex = onboardingViewControllers.firstIndex(where: { (vc) -> Bool in
//            return vc == viewController
//        }) else {
//            return nil
//        }
        
        guard let vcindex = onboardingViewControllers.firstIndex(of: viewController) else { return nil }
        
        let previous = vcindex - 1
        
        guard previous >= 0 else { return nil }
        
        guard onboardingViewControllers.count > previous else { return nil }
        
        return onboardingViewControllers[previous]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcindex = onboardingViewControllers.firstIndex(where: { (vc) -> Bool in
            return vc == viewController
        }) else {
            return nil
        }
        
        let next = vcindex + 1
        
        guard next != onboardingViewControllers.count else { return nil }
        
        guard onboardingViewControllers.count > next else { return nil }
        
        return onboardingViewControllers[next]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.onboardingViewControllers.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }
    
}
