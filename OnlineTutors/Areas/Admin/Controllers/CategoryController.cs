using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineTutorsEntities;
namespace OnlineTutors.Areas.Admin.Controllers
{
    public class CategoryController : Controller
    {

        TutorsOnlineEntities onlinetutor = new TutorsOnlineEntities();
        bool duplicate=false;
        // GET: Admin/Category
        public ActionResult Index()
        {
            try
            {
                List<usp_CategoryGet_Result> categorylist = onlinetutor.usp_CategoryGet().ToList();
                return View(categorylist);
            }
            catch(Exception ex)
            {
                return View();
            }
        }

        [HttpGet]
        public ActionResult Edit(int categoryid)
        {
            try
            {
                usp_CategoryGetbyID_Result caltegorydetail = onlinetutor.usp_CategoryGetbyID(categoryid).FirstOrDefault();
                return View(caltegorydetail);
            }
            catch(Exception ex)
            {
                return View();
            }
        }
        [HttpPost]
        public ActionResult Edit()
        {
            try
            {
                usp_CategoryGetbyID_Result category = new usp_CategoryGetbyID_Result();
                TryUpdateModel(category);
               int result=(int) onlinetutor.usp_CategoryUpdate(category.CategoryID, category.CategoryName, 1, category.Status).FirstOrDefault();
            return RedirectToAction("Index");
            }
            catch(Exception ex)
            {
                return View("Index");
            }
        }

        [HttpGet]
        public ActionResult Create()
        {
            if(duplicate)
                ViewBag.error = "Duplicate Category Name";
            return View();
        }
        [HttpPost]
        public ActionResult Create(FormCollection frm)
        {
            try
            {
                int result = (int)onlinetutor.usp_CategoryInsert(frm["CategoryName"], 1).FirstOrDefault();
                if (result == 1)
                    return RedirectToAction("Index");
                else
                {
                    duplicate = true;
                    
                    return View("Create");
                }
            }
            catch(Exception ex)
            {
                return RedirectToAction("Index");
            }
        }
    }
}