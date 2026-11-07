//
//  CameraViewController.swift
//  EmojiHunter
//

import UIKit
import AVFoundation
import Vision
import CoreML

// Shows the camera full screen, runs each frame through MobileNetV2,
// and tells the delegate when the target object is found
class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Setup VC and video settings

    weak var delegate: EmojiFoundDelegate?
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    private let videoDataOutput = AVCaptureVideoDataOutput()
    var emojiString = ""

    init(emoji: String) {
        self.emojiString = emoji
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Sets up the camera input, the frame output, and the preview layer
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        // No camera (e.g. simulator) -> show a message instead of a black screen
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showCameraUnavailableMessage()
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch { return }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }

        // Send camera frames to captureOutput on a background queue
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)

        // Full-screen camera preview
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        // startRunning() blocks, so run it off the main thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    private func showCameraUnavailableMessage() {
        let label = UILabel(frame: view.bounds)
        label.text = "📷 Camera not available\n(Run on a real device)"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(label)
    }

    // Called for every camera frame; grabs the image and sends it to be classified.
    // nonisolated because AVFoundation calls this from its own queue.
    nonisolated func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {

        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        Task { @MainActor in
            self.updateClassifications(in: frame)
        }
    }

    // Restart / stop the camera when the screen appears / disappears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Setup ML Model

    // Vision request that runs MobileNetV2 on an image and then calls
    // processClassifications with the results (lazy = created on first use)
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNetV2().model)

            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    // MARK: - Classification methods

    // Runs the model on one frame in the background
    func updateClassifications(in image: CVPixelBuffer) {

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:])
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    // Checks the model's top guess: if it's over 50% confident and its label
    // contains our target name (e.g. "fountain pen" contains "pen"), it's a match
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }

            guard let top = results.first, top.confidence > 0.5 else { return }

            // Adding in a print statement so students can see how the classifier is processing images in real time
            print("Classification: Identifier \(top.identifier) ; Confidence \(top.confidence)")

            if top.identifier.contains(self.emojiString) {
                self.delegate?.emojiWasFound(result: true)
            }
        }
    }
}
