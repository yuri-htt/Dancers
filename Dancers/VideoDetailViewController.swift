
//
//  VideoDetailViewController.swift
//  Dancers
//
//  Created by 田山　由理 on 2017/01/05.
//  Copyright © 2017年 Yuri Tayama. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit

enum ExpandBtnStatus {
    case opened
    case closed
}

class VideoDetailViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, WKNavigationDelegate, URLSessionDownloadDelegate {

    fileprivate var expandBtnState: ExpandBtnStatus = .closed
    var colorType:ColorPattern = .Blue
    var videoMap:VideoMap?
    var video:Video?
    
    @IBOutlet weak var backNavBtn: UIBarButtonItem!
    @IBOutlet weak var videoWebView: UIWebView!
    @IBOutlet weak var videoDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setColors()
        setCellHeight()
        setVideo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	// TODO; setColorsメソッドは、大半の画面で使うはずだから、ここに書かずに外出してください
    func setColors() {
        
        let realm = try! Realm()
        let rUser = realm.objects(RUser.self)
        for user in rUser {
            self.colorType = ColorPattern.getColorType(colorType: user.colorType)
        }
        
        self.view.backgroundColor = self.colorType.makeBaseColor()
        self.videoDetailTableView.backgroundColor = UIColor.clear
        
        let layer = CAGradientLayer()
        var gradiationColors:[Any] = []
        gradiationColors = self.colorType.makeGradation()
        layer.colors = gradiationColors
        layer.frame = CGRect(x: 0, y: 76 , width: self.view.frame.size.height, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(layer, at: 0)
        
    }
    
    func setCellHeight() {
        
        self.videoDetailTableView.estimatedRowHeight = 270
        self.videoDetailTableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func setVideo() {
        if let url = self.video?.embedded_url {
            let urlRequest = URLRequest(url: NSURL(string:url) as! URL)
			// TODO; GitHubにコミットする時は、テスト時に使用した特定のURLは消しましょう
            //let urlRequest = URLRequest(url: NSURL(string:"https://www.youtube.com/watch?v=0v5wtDt2Wbc&feature=player_embedded") as! URL)
            self.videoWebView.loadRequest(urlRequest)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.videoMap?.videos!.count)! + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        case 1:
            if expandBtnState == .opened {
                return UITableViewAutomaticDimension
            } else {
                return 0
            }
        default:
            return 100
        }
    }
    
    @IBAction func didPressbackNavBtn(_ sender: UIBarButtonItem) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        // TODO;（可能であれば）特にcase0とdefaultってほとんど同じだよね、、、setTableCellItemsみたいなメソッド作って共通部分は外出したほうがよさそう
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailCell", for: indexPath)  as! VideoDetailCell
            cell.backgroundColor = UIColor.clear
            cell.videoTitleLabel.text = self.video?.title
            cell.favoriteCountLabel.text = self.video?.favorite_counter
            cell.viewCountLabel.text = self.video?.view_counter
            cell.creatorNameLabel.text = self.video?.creator
            if let totalSec = self.video?.length_seconds {
                cell.playbackTimeLabel.text = Utils.convertSec(seconds: totalSec)
            }
            cell.expandBtn.addTarget(self, action: #selector(VideoDetailViewController.expandBtnTapped(_:)), for: .touchUpInside)
            cell.downloadbtn.addTarget(self, action: #selector(VideoDetailViewController.downloadbtnTapped(_:)), for: .touchUpInside)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoDetailDescriptionCell", for: indexPath)  as! VideoDetailDescriptionCell
            cell.backgroundColor = UIColor.clear
            cell.descriptionLabel.text = self.video?.description
            cell.layoutIfNeeded()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListSCell", for: indexPath)  as! VideoListSCell
            let index = indexPath.row - 2
            cell.backgroundColor = UIColor.clear
            cell.thumbnailImageView.kf.setImage(with: URL(string: (self.videoMap?.videos![index].thumbnail_url)!))
            cell.videoTitleLabel.text = self.videoMap?.videos![index].title
            cell.favoriteCountLabel.text = self.videoMap?.videos![index].favorite_counter
            cell.viewCountLabel.text = self.videoMap?.videos![index].view_counter
            cell.creatorNameLabel.text = self.videoMap?.videos![index].creator
            if let totalSec = self.videoMap?.videos![index].length_seconds {
                cell.playbackTimeLabel.text = Utils.convertSec(seconds: totalSec)
            }
            return cell
        }
    }
    
    func expandBtnTapped(_ sender: UIButton) {
        
        if self.expandBtnState == .closed {
            self.expandBtnState = .opened
            let upperAngle:CGFloat = CGFloat(180 * M_PI / 180)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: upperAngle)
            }, completion: nil)
            openDescriptionArea(open: true)
        } else {
            self.expandBtnState = .closed
            let underAngle:CGFloat = CGFloat(0 * M_PI / 180)
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                sender.transform = CGAffineTransform(rotationAngle: underAngle)
            }, completion: nil)
            openDescriptionArea(open: false)
        }
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        
        if let videoMap = self.videoMap, let videos = videoMap.videos, videos.count > indexPath.row - 2 {
            self.video = self.videoMap?.videos![indexPath.row - 2]
            setVideo()
            self.videoDetailTableView.reloadData()
        }
        
    }
    
    func openDescriptionArea(open:Bool) {
        
        let indexPath:NSIndexPath = NSIndexPath(row: 1, section: 0)
        let cell = self.videoDetailTableView.dequeueReusableCell(withIdentifier: "VideoDetailDescriptionCell", for: indexPath as IndexPath)  as! VideoDetailDescriptionCell
        
        if open {
            self.videoDetailTableView.beginUpdates()
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                cell.isHidden = false
            })
            self.videoDetailTableView.endUpdates()
        } else {
            self.videoDetailTableView.beginUpdates()
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                cell.isHidden = true
            })
            self.videoDetailTableView.endUpdates()
        }
    }
    
    func downloadbtnTapped(_ sender: UIButton) {
        
        startDownloadTask()
        
//        // 通信のコンフィグを用意.
//        let config: URLSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
//        
//        // Sessionを作成する.
//        let session: URLSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
//        
//        // ダウンロード先のURLからリクエストを生成.
//        let url:NSURL = NSURL(string: (self.video?.embedded_url!)!)!
//        let request: URLRequest =  URLRequest(url: url as URL)
//        
//        // ダウンロードタスクを生成.
//        let myTask: URLSessionDownloadTask = session.downloadTask(with: request)
//        
//        // タスクを実行.
//        myTask.resume()
//        
//        //すでにダウンロードされている数を取得
//        let myDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
//        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//        
//        print(try! FileManager.default.displayName(atPath: cache))
        
    }
    
    // バックグラウンドで動作する非同期通信
    func startDownloadTask() {
        
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "myapp-background")
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        
        let url = URL(string: self.video!.embedded_url!)!
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    // 現在時刻からユニークな文字列を得る
    func getIdFromDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.string(from: Date())
    }
    
    // 保存するディレクトリのパス
    func getSaveDirectory() -> String {
        
        let fileManager = Foundation.FileManager.default
        
        // ドキュメントディレクトリのルートパスを取得して、それにフォルダ名を追加
        let path = NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.documentDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/DownloadFiles/"
        
        // ディレクトリがない場合は作る
        if !fileManager.fileExists(atPath: path) {
            createDir(path: path)
        }
        
        return path
    }
    
    // ディレクトリを作成
    func createDir(path: String) {
        do {
            let fileManager = Foundation.FileManager.default
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("createDir: \(error)")
        }
    }
    
    /*
     ダウンロード終了時に呼び出されるデリゲート.
     */
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("finish download")
        
        var data: NSData!
        
        do {
            data = try NSData(contentsOf: location, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            print(error)
        }
        
        do {
            if let data = NSData(contentsOf: location) {
                
                let fileExtension = location.pathExtension
                let filePath = getSaveDirectory() + getIdFromDateTime() + "." + fileExtension
                
                print(filePath)
                
                try data.write(toFile: filePath, options: .atomic)
                
            }
        } catch let error as NSError {
            print("download error: \(error)")
        }
       
    }
    

    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // ダウンロード進行中の処理
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        // ダウンロードの進捗をログに表示
        print(String(format: "%.2f", progress * 100) + "%")
     

    }
    
    
    /*
     タスク終了時に呼び出されるデリゲート.
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
            print("ダウンロードが完了しました")
        } else {
            print("ダウンロードが失敗しました")
        }
        
    }
    
    func getData(){
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig)
        
        guard let text = self.video?.embedded_url else { return }
        
        let url = NSURL(string: text)!
        
        let task = session.dataTask(with: url as URL) {
            
            (data:Data?,response:URLResponse?,error:Error?) in
            
            guard let getData = data else{
                session.invalidateAndCancel()
                return
            }
            
            let myDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let moviesDirectory = myDirectory[0]
            
            print("----")
            print(moviesDirectory)
            let fileName = "test.mp3"
            
            //let downloadTo = URL(string: "file://\(moviesDirectory)/\(fileName)")
            //let downloadTo = URL(string: "file://\(moviesDirectory)")
            //let path = "file://\(moviesDirectory)/\(fileName)"
            let path = "\(moviesDirectory)/\(fileName)"
            
            
            let fileManager = FileManager.default
            var isDir :Bool = false
            isDir = fileManager.fileExists(atPath: path)
            
            if !isDir {
                try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: true, attributes: nil)
                try! getData.write(to: URL(string:path)!)
            }else {
                try! getData.write(to: URL(string:path)!)
            }
            
//            do {
//                try! getData.write(to: downloadTo!)
//            } catch {
//                print("Error")
//            }
            
        }
        
        task.resume()
        
    }

    func test2() {

        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + "/folder_name"
        
        // -- start check directory --
        let fileManager = FileManager.default
        var isDir : Bool = false
        
        isDir = fileManager.fileExists(atPath: path)
        
        if !isDir {
            try! fileManager.createDirectory(atPath: path ,withIntermediateDirectories: true, attributes: nil)
        }
        
        // 保存するもの
        let fileObject = "hogehoge"
        // ファイル名
        let fileName = "tes1.txt"
        // 保存処理
        try! fileObject.write(toFile: "\(path)/\(fileName)", atomically: true, encoding: String.Encoding.utf8)
        
        // 旧ファイル名
        let old_fileName = "tes1.txt"
        // 新ファイル名
        let new_fileName = "tes.txt"
        try! FileManager.default.moveItem(atPath: "\(path)/\(old_fileName)", toPath: "\(path)/\(new_fileName)")
    }


}

