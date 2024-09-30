//
//  ImageZoomView.swift
//  SGTS
//
//  Created by Roman Vakulenko on 18.07.2024.
//

import UIKit

final class ImageScrollView: UIScrollView {

    // MARK: - Private properties

    private var imageViewForZoom: UIImageView?

//    private var currentRotation: CGFloat = 0.0

// if needs doubleTap for zoom x2 Image
//    private lazy var zoomingTap: UITapGestureRecognizer = {
//        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
//        zoomingTap.numberOfTapsRequired = 2
//        return zoomingTap
//    }()


    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.centerImage()
    }

    // MARK: - Public methods

    func set(image: UIImage) {

        imageViewForZoom?.removeFromSuperview()
        imageViewForZoom = nil
        imageViewForZoom = UIImageView(image: image)
        self.addSubview(imageViewForZoom ?? UIImageView())

        configurateFor(imageSize: image.size)
    }

    // MARK: - Actions
// делает поворот в 3D и не получается ограничить поворот плоскостью
//    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
//        guard let view = recognizer.view else { return }
//
//        switch recognizer.state {
//        case .began, .changed:
//            let newRotation = currentRotation + recognizer.rotation
//            view.transform = view.transform.rotated(by: newRotation - currentRotation)
//            currentRotation = newRotation
//            recognizer.rotation = 0.0
//        default:
//            break
//        }
//    }

    // MARK: - Private methods

    private func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize

        setMinAndMaxZoomScale()
        self.zoomScale = self.minimumZoomScale
        self.imageViewForZoom?.isUserInteractionEnabled = true

// if needs doubleTap for zoom x2 Image
//        self.imageZoomView.addGestureRecognizer(self.zoomingTap)


//        let rotationGestureRecognizer = UIRotationGestureRecognizer(
//            target: self,
//            action: #selector(handleRotationGesture(_:)))
//        imageViewForZoom?.addGestureRecognizer(rotationGestureRecognizer)

    }

    private func setMinAndMaxZoomScale() {
        let boundsSize = self.bounds.size
        guard let imageSize = imageViewForZoom?.bounds.size else {return}

        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        let minScale = min(xScale, yScale)

        var maxScale: CGFloat = 1.0
        if minScale < 0.16 {
            maxScale = 0.32
        }
        if minScale >= 0.16 && minScale < 0.64 {
            maxScale = 3.2
        }
        if minScale >= 0.64 {
            maxScale = max(1.0, minScale)
        }

        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
    }

    private func centerImage() {
        let boundsSize = self.bounds.size
        guard let imageView = imageViewForZoom else {return}
        var frameToCenter = imageView.frame

        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        imageViewForZoom?.frame = frameToCenter
    }

    private func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale

        if (minScale == maxScale && minScale > 1) {
            return
        }

        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }

    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds

        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}

// MARK: - UIScrollViewDelegate

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageViewForZoom
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }
}
