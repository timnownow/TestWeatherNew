
import UIKit

class PagerVC: UIViewController  {
    
    @IBOutlet weak var toolbar:UIToolbar!
    @IBOutlet weak var pageControl:UIPageControl!
    
    var pendingIndex: Int?

    var pages:[Page]!

    var alert:UIAlertController!
    var pageView:UIPageViewController!

    
    @IBAction func buttonEdit(_ sender: Any) {
        self.performSegue(withIdentifier: "pagerToCities", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = CoreDataManager.instance.getPages()
        
        if (pages.count) > 0
        {
            initPager()
            updatePageControl()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (pages.count) == 0
        {
            self.performSegue(withIdentifier: "pagerToAdd", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pagerToCities" {
            let controller = segue.destination as! CitiesVC
            controller.delegate = self
        }
        if segue.identifier == "pagerToAdd" {
            let controller = segue.destination as! CityAddVC
            controller.delegate = self
            controller.isFirstCity = true
        }
    }
    
    func updatePageControl()
    {
        pageControl.numberOfPages = pages.count
        pageControl.isHidden = !(pages.count > 1)
    }
    
    func initPager()
    {
        if pageView != nil
        {
            pageView.setViewControllers([getViewControllerAtIndex(index: 0)],
                                        direction: .forward,
                                        animated: false,
                                        completion: nil)
            return
        }
        
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageView.setViewControllers([getViewControllerAtIndex(index: 0)],
                                    direction: .forward,
                                    animated: false,
                                    completion: nil)
        
        pageView.dataSource = self
        pageView.delegate = self
        
        pageView.view.frame = CGRect(x:0,y:0,width:self.view.frame.width, height: self.view.frame.height)
        
        self.view.addSubview(pageView.view)
        self.addChildViewController(pageView)

        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: pageView.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 12)
        self.view.addConstraint(topConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: pageView.view, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 20)
        self.view.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: pageView.view, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -20)
        self.view.addConstraint(rightConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: pageView.view, attribute: .bottom, relatedBy: .equal, toItem: toolbar, attribute: .top, multiplier: 1, constant: 0)
        self.view.addConstraint(bottomConstraint)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> UIViewController
    {
        let pageContentViewController  = self.storyboard?.instantiateViewController(withIdentifier: "CityVC") as! CityVC
        pageContentViewController.page = pages[index]
        pageContentViewController.index = index
        return pageContentViewController
    }
}

extension PagerVC: DelegateToPagerFromCities
{
    func selectCity(pos: Int) {
        pages = CoreDataManager.instance.getPages()
        
        pageView.setViewControllers([getViewControllerAtIndex(index: pos)], direction: .forward, animated: false, completion: nil)
        updatePageControl()
        pageControl.currentPage = pos
    }
}

extension PagerVC: DelegateToPagerFromCityAdd
{
    func addFirstCity() {
        pages = CoreDataManager.instance.getPages()
        initPager()
        updatePageControl()
    }
}

extension PagerVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let itemVC = pendingViewControllers.first as? CityVC
        {
            pendingIndex = itemVC.index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let index = pendingIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageContent = viewController as! CityVC
        var index = pageContent.index!
        if ((index + 1 == pages.count) || (index == NSNotFound))         {  return nil }
        index = index + 1
        return getViewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageContent = viewController as! CityVC
        var index = Int(pageContent.index)
        if ((index == 0) || (index == NSNotFound))         {  return nil }
        index = index - 1
        return getViewControllerAtIndex(index: index)
    }
}
