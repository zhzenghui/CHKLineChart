//
//  CustomStyleViewController.swift
//  CHKLineChart
//
//  Created by Chance on 2016/12/31.
//  Copyright © 2016年 Chance. All rights reserved.
//

import UIKit

class CustomStyleViewController: UIViewController {

    @IBOutlet var chartView: CHKLineChartView!
    
    var style: CHKLineChartStyle = .base
    
    var klineDatas = [CHChartItem]()
    
    var settingVC: StyleSettingViewController!
    
    var loopCount = 0
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartView.delegate = self
        self.chartView.style = self.style
//        self.getDataByFile()        //读取文件
        self.getRemoteServiceData()
        
        settingVC = self.storyboard?.instantiateViewController(withIdentifier: "StyleSettingViewController") as! StyleSettingViewController
        settingVC.chartView = self.chartView
        
//        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(getRemoteServiceData), userInfo: nil, repeats: true)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRemoteServiceData() {
        // 快捷方式获得session对象
        
        if loopCount == 2 {
            timer? .invalidate()
        }
        loopCount = loopCount + 1
        let session = URLSession.shared
        //
        let urlStr = "https://api.huobi.pro/market/history/kline?symbol=btcusdt&period=15min&size=500"
        
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
                        let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! Dictionary<String, AnyObject>
                        
                        var dataArray = [CHChartItem]()
                        if dict["status"] as! String == "ok" {
                            let arr = dict["data"] as! Array<NSDictionary>
                            for data in arr{
                                let item = CHChartItem()
                                item.time = Int((data["id"] as! Double) )
                                item.openPrice = CGFloat(data["open"] as! Double)
                                item.highPrice = CGFloat(data["high"] as! Double)
                                item.lowPrice = CGFloat(data["low"] as! Double)
                                item.closePrice = CGFloat(data["close"] as! Double)
                                item.vol = CGFloat(data["vol"] as! Double)
                                
                                dataArray.append(item)

                            }
                        }
                        
                        
//                        let datas = dict as [CHChartItem]
//                        NSLog("chart.datas = \(datas.count)")
//                        self.klineDatas = datas
                        
                        dataArray.reverse()

                        
                        NSLog("chart.datas = \(dataArray.count)")

                        if self.klineDatas.count  == 0 {
                            self.klineDatas = dataArray
                            self.chartView.reloadData(toPosition: .end)

                        }
                        else {
                            self.klineDatas += dataArray
                            self.chartView.reloadData(toPosition: .none)

                        }
                    } catch _ {
                        
                    }
                }
                
                
            }
        })
        
        // 启动任务
        task.resume()
    }


    func getDataByFile() {
        
        //                        火币
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!))
        let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]
        
        let isSuc = dict["isSuc"] as? Bool ?? false
        if isSuc {
            let datas = dict["datas"] as! [AnyObject]
            NSLog("chart.datas = \(datas.count)")
//            self.klineDatas = datas
            self.chartView.reloadData()
        }
    }
    
    @IBAction func handleStyleSettingPress(sender: AnyObject?) {
        self.present(self.settingVC, animated: true, completion: nil)
    }
    
    @IBAction func handleClosePress(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - 实现K线图表的委托方法
extension CustomStyleViewController: CHKLineChartDelegate {
    
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return self.klineDatas.count
    }
    
    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let item = self.klineDatas[index]

        return item
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, section: CHSection) -> String {
        var strValue = ""
        if value / 10000 > 1 {
            strValue = (value / 10000).ch_toString(maxF: 2) + "万"
        } else {
            strValue = value.ch_toString(maxF: 2)
        }
        return strValue
    }
    
    func kLineChart(chart: CHKLineChartView, labelOnXAxisForIndex index: Int) -> String {
        let data = self.klineDatas[index]
        
        let timestamp = data.time
        return Date.ch_getTimeByStamp(timestamp, format: "HH:mm")
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

