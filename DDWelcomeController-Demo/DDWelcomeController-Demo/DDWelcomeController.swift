//
//  DDWelcomeController.swift
//  DDWelcomeController-Demo
//
//  Created by 端 闻 on 8/3/15.
//  Copyright (c) 2015年 monk-studio. All rights reserved.
//

import UIKit


func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class DDWelcomeController: UIViewController,UIGestureRecognizerDelegate{
    var views:[UIView]!
    var scrollView:UIScrollView!
    var panGesture:UIPanGestureRecognizer!
    var animator = WelcomeAnimator()
    let pageBottomSpace = 40
    
    init(views:[UIView]){
        super.init()
        self.views = views
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width * CGFloat(self.views.count), self.scrollView.bounds.height)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        var index = 0
        for member in views{
            member.frame = CGRectMake(CGFloat(index) * self.scrollView.bounds.width, 0, self.scrollView.bounds.width, self.scrollView.bounds.height)
            self.scrollView.addSubview(member)
            let pageControler = UIPageControl()
            pageControler.numberOfPages =  self.views.count
            pageControler.currentPage = index
            pageControler.setTranslatesAutoresizingMaskIntoConstraints(false)
            pageControler.numberOfPages = views.count
            member.addSubview(pageControler)
            let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("|[pageController]|", options: nil, metrics: nil, views: ["pageController":pageControler])
            let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[pageController(20)]-(bottomSpace)-|", options: nil, metrics: ["bottomSpace":pageBottomSpace], views: ["pageController":pageControler])
            member.addConstraints(constraintsH)
            member.addConstraints(constraintsV)
            
            ++index
        }
        self.panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        let lastView = views.last
        lastView?.addGestureRecognizer(self.panGesture)
        

        
        //transitioning animation relevant
        self.transitioningDelegate = self

        
        
    }
    
    func handlePan(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .Began:
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            self.animator.handlePan(gesture)
        }
    }
    
    
}

extension DDWelcomeController:UIViewControllerTransitioningDelegate{
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animator
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.animator
    }
}

class WelcomeAnimator:UIPercentDrivenInteractiveTransition,UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.8
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as DDWelcomeController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        toViewController.view.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0)
        UIView.animateWithDuration(self.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                toViewController.view.layer.transform = CATransform3DIdentity
                fromViewController.view.layer.transform = CATransform3DMakeTranslation(0, -fromViewController.view.bounds.height, 0)
            }, completion: {_ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.animationDuration
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        let maxMov:CGFloat = -300
        let translation = recognizer.translationInView(recognizer.view!.superview!)
        if(translation.y < 0){
            let value = (translation.y < maxMov) ? maxMov : translation.y
            var progress = value / maxMov
            progress = min(max(progress, 0.01), 0.99)
            switch recognizer.state {
            case .Changed:
                updateInteractiveTransition(progress)
                
            case .Cancelled, .Ended:
                let transitionLayer = storedContext!.containerView().layer
                transitionLayer.beginTime = CACurrentMediaTime()
                if progress < 0.5 {
                    cancelInteractiveTransition()
                } else {
                    finishInteractiveTransition()
                }
            default:
                break
            }
        }
    }
    
    
    
}









