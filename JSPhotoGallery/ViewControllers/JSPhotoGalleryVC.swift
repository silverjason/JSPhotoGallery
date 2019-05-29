//
//  PhotoGalleryVC.swift
//  WorkyardCrew
//
//  Created by Jason Silver on 13/5/19.
//  Copyright © 2019 Workyard Pty Ltd. All rights reserved.
//

import UIKit
import Kingfisher

public protocol JSPhotoGalleryDelegate: class {
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapTopLeftButton button: UIButton)
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapTopRightButton button: UIButton)
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapBottomRightButton button: UIButton)
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapBottomLeftButton button: UIButton)
}

public extension JSPhotoGalleryDelegate {
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapTopLeftButton button: UIButton) {}
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapTopRightButton button: UIButton) {}
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapBottomRightButton button: UIButton) {}
    public func photoGalleryVC(_ photoGalleryVC: JSPhotoGalleryVC, didTapBottomLeftButton button: UIButton) {}
}

//MARK: - Presentation
extension UIViewController {
    
    public func presentGallery(imageURLs: [URL]? = nil,
                               images: [UIImage]? = nil,
                               initialIndex: Int = 0,
                               shouldStartInFullScreen: Bool = true,
                               delegate: JSPhotoGalleryDelegate? = nil,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) {
        
        if imageURLs == nil && images == nil {
            assertionFailure("List of image urls and images cannot both be nil")
        }
        
        let storyboard = UIStoryboard(name: JSPhotoGalleryVC.Constants.storyboardName,
                                      bundle: Bundle(identifier: JSPhotoGalleryVC.Constants.bundleID))
        let photoGallery = storyboard.instantiateViewController(withIdentifier: JSPhotoGalleryVC.Constants.storyboardID) as! JSPhotoGalleryVC
        
        photoGallery.imageURLs = imageURLs
        photoGallery.images = images
        photoGallery.initialIndex = initialIndex
        photoGallery.shouldStartInFullScreen = shouldStartInFullScreen
        photoGallery.delegate = delegate
        
        let nc = UINavigationController(rootViewController: photoGallery)
        present(nc, animated: animated, completion: completion)
    }
}

public struct JSPhotoGallery {
    
    public static var settings = Settings()
    
    public struct Settings {
        public var backgroundColor: UIColor = .white
        public var navBackgroundColor: UIColor = .white
        public var navTitleColor: UIColor = .white
        public var navTitle: String = "Photos"
    }
}

public class JSPhotoGalleryVC: UIViewController {
    
    //MARK: - Constants
    struct Constants {
        static let storyboardName = "JSPhotoGallery"
        static let storyboardID = "JSPhotoGalleryVC"
        static let bundleID = "org.cocoapods.JSPhotoGallery"
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    
    //MARK: - API
    var imageURLs: [URL]?
    var images: [UIImage]?
    var initialIndex: Int = 1
    var shouldStartInFullScreen = true
    var isDeleteEnabled = false
    
    weak var delegate: JSPhotoGalleryDelegate?
    
    
    //MARK: - Private Properties
    private let reuseIdentifier = "Cell"
    private let imageViewTag = 100
    private var lastContentOffset: CGFloat = 5
    private let fullScreenImageViewPadding: CGFloat = 5
    private var numberOfImages = 0
    private var paddingPerItem: CGFloat {
        return isFullScreenMode ? 0.0 : 5.0
    }
    
    private var itemsPerRow: CGFloat {
        return isFullScreenMode ? 1.0 : 3.0
    }
    
    private var currentPageIndex: Int {
        guard let collectionView = collectionView, isFullScreenMode else { return 0 }
        
        return Int(collectionView.contentOffset.x / collectionView.bounds.width)
    }
    
    private var isFullScreenMode = false {
        didSet {
            
            guard let collectionView = collectionView else { return }
            
            configureFlowLayout()
            collectionView.reloadData()
            
            configureButtonVisibilty()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if shouldStartInFullScreen {
            showFullScreenForIndex(initialIndex)
        } else {
            isFullScreenMode = false
        }
    }
    
    private func configureVC() {
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        configureCollectionView()
        configureButtonVisibilty()
        
        if let imageURLs = imageURLs {
            numberOfImages = imageURLs.count
        } else if let images = images {
            numberOfImages = images.count
        }
        
        if initialIndex > numberOfImages {
            assertionFailure("Initial index out of bounds")
        }
        
        pageControl?.numberOfPages = numberOfImages
    }
    
    
    
    private func showFullScreenForIndex(_ index: Int) {
        
        isFullScreenMode = true
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: IndexPath(item: index, section: 0),
                                              at: .centeredHorizontally,
                                              animated: false)
            self.pageControl?.currentPage = self.currentPageIndex
        }
        
    }
    
    private func configureButtonVisibilty() {
        
        pageControl?.isHidden = !isFullScreenMode
    }
    
    private func configureCollectionView() {
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.register(UINib(nibName: JSPhotoGalleryFullScreenCVCell.Constants.nibName,
                                       bundle: Bundle(identifier: JSPhotoGalleryFullScreenCVCell.Constants.bundleID)),
                                 forCellWithReuseIdentifier: JSPhotoGalleryFullScreenCVCell.Constants.identifier)
    }
    
    private func configureFlowLayout() {
        
        guard let collectionView = collectionView,
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.scrollDirection = isFullScreenMode ? .horizontal : .vertical
        flowLayout.invalidateLayout()
        flowLayout.minimumInteritemSpacing = paddingPerItem
        flowLayout.minimumLineSpacing = paddingPerItem
        flowLayout.sectionInset = UIEdgeInsets(top: paddingPerItem, left: paddingPerItem, bottom: paddingPerItem, right: paddingPerItem)
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isFullScreenMode {
            pageControl?.currentPage = currentPageIndex
        }
    }
    
    //MARK: - Public Methods
    public func showGrid() {
        isFullScreenMode = false
    }
    
    //MARK: - IBActions
    @IBAction func topLeftButtonTapped(_ button: UIButton) {
        delegate?.photoGalleryVC(self, didTapTopLeftButton: button)
    }
    
    @IBAction func topRightButtonTapped(_ button: UIButton) {
        delegate?.photoGalleryVC(self, didTapTopRightButton: button)
    }
    
    @IBAction func bottomRightButtonTapped(_ button: UIButton) {
        delegate?.photoGalleryVC(self, didBottomRightButton: button)
    }
    
    @IBAction func bottomLeftButtonTapped(_ button: UIButton) {
        delegate?.photoGalleryVC(self, didTapBottomLeftButton: button)
    }
    
}

//MARK: - UIGestoreRecognizerDelegate

extension JSPhotoGalleryVC: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Selectors
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        
        guard let collectionView = collectionView, let cell = collectionView.visibleCells.first as? JSPhotoGalleryFullScreenCVCell,
            let imageView = cell.imageView else { return }
        
        if  [.changed, .began].contains(gesture.state) {
            
            collectionView.isScrollEnabled = false
            
            //Zoom limit
            if imageView.frame.height > collectionView.frame.height * 3 && gesture.scale >= 1 {
                return
            }
            
            let pinchCenter = CGPoint(x: gesture.location(in: imageView).x - imageView.bounds.midX,
                                      y: gesture.location(in: imageView).y - imageView.bounds.midY)
            
            
            let transform = imageView.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = imageView.frame.size.width / imageView.bounds.size.width
            let newScale = currentScale * gesture.scale
            
            if newScale > 1 {
                imageView.transform = transform
            } else {
                imageView.transform = .identity
            }
            
            gesture.scale = 1
        }
    }
    
    
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        guard let collectionView = collectionView, let cell = collectionView.visibleCells.first as? JSPhotoGalleryFullScreenCVCell,
            let imageView = cell.imageView else { return }
        
        let originX = round(imageView.frame.origin.x)
        let maxX = round(imageView.frame.maxX)
        
        if  [.changed, .began].contains(gesture.state) {
            
            if originX >= fullScreenImageViewPadding || maxX <= cell.contentView.frame.maxX - fullScreenImageViewPadding {
                collectionView.isScrollEnabled = true
                
            } else {
                collectionView.isScrollEnabled = false
                performTranslation(imageView: imageView, gesture: gesture)
            }
            
            if originX == fullScreenImageViewPadding || maxX == cell.contentView.frame.maxX - fullScreenImageViewPadding {
                performTranslation(imageView: imageView, gesture: gesture)
            }
            
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                //Reset image origin once gesture is ended if too far right or left
                if originX >= self.fullScreenImageViewPadding  {
                    imageView.frame.origin.x = self.fullScreenImageViewPadding
                } else if maxX <= cell.contentView.frame.maxX {
                    imageView.frame.origin.x = (imageView.frame.width - cell.contentView.frame.width + self.fullScreenImageViewPadding) * -1
                }
                
                if imageView.frame.origin.y >= 0  {
                    imageView.frame.origin.y = 0
                } else if imageView.frame.maxY < cell.contentView.frame.maxY {
                    imageView.frame.origin.y = (imageView.frame.height - cell.contentView.frame.height) * -1
                }
            })
        }
    }
    
    private func performTranslation(imageView: UIImageView, gesture: UIPanGestureRecognizer) {
        
        // Get the touch position
        let translation = gesture.translation(in: imageView)
        
        // Edit the center of the image by adding the gesture position
        imageView.center = CGPoint(x: imageView.center.x + translation.x * 2, y: imageView.center.y + translation.y * 2)
        gesture.setTranslation(.zero, in: imageView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let collectionView = collectionView, let cell = collectionView.visibleCells.first as? JSPhotoGalleryFullScreenCVCell,
            let imageView = cell.imageView else { return }
        
        // If imageView is to the right and user swipes right - keep collectionview scroll enabled
        if round(imageView.frame.origin.x) >= self.fullScreenImageViewPadding && collectionView.contentOffset.x < lastContentOffset  {
            collectionView.isScrollEnabled = true
            
            // If imageView is to the left and user swipes left - keep collectionview scroll enabled
        } else if round(imageView.frame.maxX) <= cell.contentView.frame.maxX - self.fullScreenImageViewPadding && collectionView.contentOffset.x > lastContentOffset {
            collectionView.isScrollEnabled = true
            
            // Disable scroll on collectionview which will allow to pan image the other way
        } else {
            collectionView.isScrollEnabled = false
        }
        
        lastContentOffset = collectionView.contentOffset.x
    }
    
}


// MARK: - UICollectionViewDataSource
extension JSPhotoGalleryVC: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfImages
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if isFullScreenMode {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JSPhotoGalleryFullScreenCVCell.Constants.identifier, for: indexPath) as! JSPhotoGalleryFullScreenCVCell
            
            if let imageView = cell.imageView {
                loadImageViewWithItem(imageView, indexPath: indexPath)
                
                imageView.gestureRecognizers?.removeAll()
                
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
                
                pinchGesture.delegate = self
                panGesture.delegate = self
                
                panGesture.minimumNumberOfTouches = 1
                panGesture.maximumNumberOfTouches = 2
                
                imageView.addGestureRecognizer(pinchGesture)
                imageView.addGestureRecognizer(panGesture)
                
            }
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            
            if let imageView = cell.contentView.viewWithTag(imageViewTag) as? ImageView {
                loadImageViewWithItem(imageView, indexPath: indexPath)
                imageView.bounds = cell.bounds
            } else {
                let imageView = ImageView(frame: cell.bounds)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.tag = imageViewTag
                loadImageViewWithItem(imageView, indexPath: indexPath)
                cell.contentView.addSubview(imageView)
            }
            return cell
            
        }
        
    }
    
    private func loadImageViewWithItem(_ imageView: UIImageView, indexPath: IndexPath) {
        
        if let imageURLs = imageURLs {
            imageView.kf.setImage(with: imageURLs[indexPath.row])
        } else if let images = images {
            imageView.image = images[indexPath.row]
        }
        
    }
}

extension JSPhotoGalleryVC: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? JSPhotoGalleryFullScreenCVCell else { return }
        cell.imageView.transform = .identity
        cell.imageView.frame = cell.imageView.bounds
        cell.imageView.frame.origin.x = fullScreenImageViewPadding
    }
    
}


// MARK: - Collection View Flow Layout Delegate
extension JSPhotoGalleryVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        
        let width = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (itemsPerRow - 1)
        
        if isFullScreenMode {
            return CGSize(width: width, height: collectionView.bounds.height * 0.8)
        } else {
            let itemSize = width / itemsPerRow
            return CGSize(width: itemSize, height: itemSize)
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !isFullScreenMode {
            showFullScreenForIndex(indexPath.row)
        }
    }
}
