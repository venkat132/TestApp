//
//  GenericService.swift
//  kPoint
//
//  Created by Mego Developer on 29/05/20.
//  Copyright © 2020 Mego Developer. All rights reserved.
//

import Foundation

var buffer: NSMutableData = NSMutableData()

var session: URLSession?
var dataTask: URLSessionDataTask?
var expectedContentLength = 0
var dataRec: Data?
var checksum: String?

class GenericService: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {

    weak var selfDelegate: GenericServiceDelegate?
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }

    init(delegate: GenericServiceDelegate) {
        super.init()
        selfDelegate = delegate
        let configuration = URLSessionConfiguration.default
        let mainqueue = OperationQueue.main
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: mainqueue)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // use buffer here.Download is done
        dataRec = Data(buffer as Data)
        DispatchQueue.global(qos: .default).async {
            if error == nil {
                self.selfDelegate?.onDataReceived(data: dataRec!, service: self, params: "")
            } else {
                self.selfDelegate?.onDataError(error: error!, service: self, params: "")
            }
        }
    }

}
