//
//  DashboardListPresenter.swift
//  Dashborad
//
//  Created by Gamil Ali Qaid Shamar on 25/01/2020.
//  Copyright © 2020 Jamil. All rights reserved.
//

import UIKit

protocol DashboardListPresenterDelegate : AnyObject {
    func didFetchDashboardItems(success:Bool)
}

class DashboardListPresenter: NSObject {
    weak var delegate: DashboardListPresenterDelegate?
    private let dashboardViewModel: DashboardViewModel
    private var dashboardModel: DashboardModel!
    var dashboardViewController: DashboardViewController!

    init(dashboardViewModel:DashboardViewModel) {
           self.dashboardViewModel = dashboardViewModel
           super.init()
           self.dashboardViewModel.delegate = self
       }
    
    public func fetchDashboardItems (scope:String = "ALL") {
        self.dashboardViewModel.fetchDashboardItems(scope: scope)
    }
    
    public func getRating() -> Rating {
        
        guard let rating = dashboardModel.response?.data?.analytics?.rating else {
            return Rating()
        }
        return rating
    }

    public func getRatingDescription () -> String {
        guard let description = dashboardModel.response?.data?.analytics?.rating?.ratingDescription!else {
            return ""
        }
        return description
    }
    
    
    public func jobsCount() -> Int {
        
        guard let count = dashboardModel.response?.data?.analytics?.job?.items!.count else {
            return 0
        }
        return count
    }
    
    public func getJobs() -> [JobItem] {
        guard let jobs = dashboardModel.response?.data?.analytics?.job?.items!else {
                   return []
               }
        return jobs
    }
    
    public func getJobDescription () -> String {
        guard let description = dashboardModel.response?.data?.analytics?.job?.jobDescription!else {
            return ""
        }
        return description
    }
    
    public func getJob(index:Int) -> JobItem {
        return self.getJobs()[index]
    }
    
    
     public func getLineCharts () -> [[LineChart]]{
         guard let lineCharts = dashboardModel.response?.data?.analytics?.lineCharts else {
                   return [[LineChart]]()
             }
                
         return lineCharts
     }
    
    public func getPieCharts () -> [PieChart]{
           guard let pieCharts = dashboardModel.response?.data?.analytics?.pieCharts else {
                     return [PieChart]()
               }
                  
           return pieCharts
       }
    
    
    public func servicesCount() -> Int {
           
        guard let count = dashboardModel.response?.data?.analytics?.service?.items!.count else {
               return 0
           }
           return count
    }
    
    public func getServices() -> [JobItem] {
           guard let jobs = dashboardModel.response?.data?.analytics?.service?.items!else {
                      return []
                  }
           return jobs
       }
       
    public func getServiceDescription () -> String {
           guard let description = dashboardModel.response?.data?.analytics?.service?.jobDescription!else {
               return ""
           }
           return description
       }
    
    
    public func getService(index:Int) -> JobItem {
           return self.getServices()[index]
       }

       
}

extension DashboardListPresenter : DashboardListModelDelegate {
   
    func didFetchDashboardItems(success: Bool, dashboardItems: DashboardModel) {
        self.dashboardModel = dashboardItems
        
        if dashboardItems.httpStatus == 201 || dashboardItems.httpStatus == 200{
            if let delegate = self.delegate {
                delegate.didFetchDashboardItems(success: success)
                return
            }
        } else {
            let alert = UIAlertController(title: "APi Error", message: "Something wenr wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


            }}))
            dashboardViewController.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
}
