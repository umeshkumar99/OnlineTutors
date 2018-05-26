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
                ViewBag.Categoryid = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
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

            ViewBag.CategoryID = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
           
            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                usp_ServiceGetbyID_Result service = new usp_ServiceGetbyID_Result();
                int result=0;
                if (ModelState.IsValid)
                {
                    TryUpdateModel(service);
                     result = (int)onlinetutor.usp_ServiceInsert(service.Description, 1, service.CategoryID).FirstOrDefault();
                }
                if (result == 1) {
                             return RedirectToAction("Index");
                }
                  
                else
                {
                    ViewBag.CategoryID = new SelectList(onlinetutor.usp_CategoryGetList(), "CategoryID", "CategoryName");
                    ModelState.AddModelError("", "Service already exists");
                    return View("create");
                    
                }
            }
            catch (Exception ex)
            {
                return RedirectToAction("Index");
            }
        }


    }
}