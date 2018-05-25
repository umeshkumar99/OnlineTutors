using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;

namespace OnlineTutors.Areas.Admin.Controllers
{
    public class ServiceController : Controller
    {
        // GET: Admin/Service
        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        bool duplicate = false;
        // GET: Admin/Category
        public ActionResult Index()
        {
            try
            {
        
                
                List<usp_ServiceGet_Result> servicelist = onlinetutor.usp_ServiceGet().ToList();
                return View(servicelist);
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        [HttpGet]
        public ActionResult Edit(int serviceid)
        {
            try
            {
                ViewBag.Category = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
                usp_ServiceGetbyID_Result servicedetail = onlinetutor.usp_ServiceGetbyID(serviceid).FirstOrDefault();
                return View(servicedetail);
            }
            catch (Exception ex)
            {
                return View();
            }
        }
        [HttpPost]
        public ActionResult Edit()
        {
            try
            {
                usp_ServiceGetbyID_Result service = new usp_ServiceGetbyID_Result();
                TryUpdateModel(service);
                int result = (int)onlinetutor.usp_ServiceUpdate(service.ServiceID,service.Description, 1,service.Status,service.CategoryID).FirstOrDefault();
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                return View("Index");
            }
        }

        [HttpGet]
        public ActionResult Create()
        {

            ViewBag.Category = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
            if (duplicate)
                ViewBag.error = "Duplicate Category Name";
            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                usp_ServiceGetbyID_Result service = new usp_ServiceGetbyID_Result();
                TryUpdateModel(service);
                int result = (int)onlinetutor.usp_ServiceInsert(service.Description, 1,service.CategoryID).FirstOrDefault();
                if (result == 1)
                    return RedirectToAction("Index");
                else
                {
                    duplicate = true;

                    return View("Create");
                }
            }
            catch (Exception ex)
            {
                return RedirectToAction("Index");
            }
        }


    }
}