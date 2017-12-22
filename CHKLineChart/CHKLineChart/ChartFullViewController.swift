//
//  ChartFullViewController.swift
//  CHKLineChart
//
//  Created by Chance on 2017/6/19.
//  Copyright © 2017年 bitbank. All rights reserved.
//

import UIKit

class ChartFullViewController: UIViewController {

    @IBOutlet var chartView: CHKLineChartView!
    @IBOutlet var loadingView: UIActivityIndicatorView!
    
    var klineDatas = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartView.delegate = self
        self.chartView.style = .simpleLineDark

        self.getRemoteServiceData(size: "200")       //读取网络
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRemoteServiceData(size: String) {
        self.loadingView.startAnimating()
        self.loadingView.isHidden = false
        // 快捷方式获得session对象
        let session = URLSession.shared
        
        
        let urlStr = "https://www.okex.com/api/v1/kline.do?symbol=btc_usdt&type=1min&size=200"
        
        //        let url = URL(string: "https://www.btc123.com/kline/klineapi?symbol=chbtc\(self.selectexPair)&type=\(self.selectTime)&size=\(size)")
        let url = URL(string: urlStr)
        
        // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if let data = data {
                
                DispatchQueue.main.async {
                    /*
                     对从服务器获取到的数据data进行相应的处理.
                     */
                    do {
                        //                        NSLog("\(NSString(data: data, encoding: String.Encoding.utf8.rawValue))")
                        let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [AnyObject]
                        
                        
                        let datas = dict as [AnyObject]
                        NSLog("chart.datas = \(datas.count)")
                        if self.klineDatas.count  == 0 {
                            self.klineDatas = datas
                        }
                        else {
                            self.klineDatas += datas
                        }
                        self.chartView.reloadData(toPosition: .end)
                        

                    } catch _ {
                        
                    }
                    
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
                
                
            }
        })
        
        // 启动任务
        task.resume()
    }
    
    @IBAction func handleClosePress(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - 实现K线图表的委托方法
extension ChartFullViewController: CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return self.klineDatas.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let data = self.klineDatas[index] as! [AnyObject]
        let item = CHChartItem()
        item.time = Int(data[0] as! Double)
        item.openPrice =  CGFloat((data[1] as! NSString).floatValue)
        item.highPrice = CGFloat((data[2] as! NSString).floatValue)
        item.lowPrice = CGFloat((data[3] as! NSString).floatValue)
        item.closePrice = CGFloat((data[4] as! NSString).floatValue)
        item.vol = CGFloat((data[5] as! NSString).floatValue)
        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, section: CHSection) -> String {
        var strValue = value.ch_toString(maxF: section.decimal)
        return strValue
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        let data = self.klineDatas[index] as! [Double]
        let timestamp = Int(data[0])
        var time = Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
        if time == "00:00" {
            time = Date.ch_getTimeByStamp(timestamp, format: "MM-dd")
        }
        return time
    }
    
    
    /// 调整每个分区的小数位保留数
    ///
    /// - parameter chart:
    /// - parameter section:
    ///
    /// - returns:
    func kLineChart(chart: CHKLineChartView, decimalAt section: Int) -> Int {
        return 2
    }
    
    
    /// 调整Y轴标签宽度
    ///
    /// - parameter chart:
    ///
    /// - returns:
    func widthForYAxisLabel(in chart: CHKLineChartView) -> CGFloat {
        return chart.kYAxisLabelWidth
    }
    
    func hegihtForXAxis(in chart: CHKLineChartView) -> CGFloat {
        return 16
    }
    
    
    /// 点击图标返回点击的位置和数据对象
    ///
    /// - Parameters:
    ///   - chart:
    ///   - index:
    ///   - item:
    func kLineChart(chart: CHKLineChartView, didSelectAt index: Int, item: CHChartItem) {
        NSLog("selected index = \(index)")
        NSLog("selected item closePrice = \(item.closePrice)")
    }
    
}
